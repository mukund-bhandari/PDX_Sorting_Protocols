############################################################################################################## 
################################################  1. Xengsort ################################################ 
############################################################################################################## 

########################  create xengsort index ######################## 

#!/bin/bash
#SBATCH --job-name xengsort-index
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 0-23:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


ref=/shared/home/bhandarim/3_reference_genomes/ensemble
index=/shared/home/bhandarim/0_testing

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate xengsort
xengsort index --index $index/myindex -H $ref/Mus_musculus.GRCm39.dna.toplevel.fa -G $ref/Homo_sapiens.GRCh38.dna.toplevel.fa -n 4_500_000_000 -k 25
conda deactivate


########################  sort using xengsort ############################

#!/bin/bash
#SBATCH --job-name xengsort-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 0-01:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu

index=/shared/home/bhandarim/0_testing

PDX_RNA=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1739_PDX
fq1=$PDX_RNA/1739_PDX_R1.fastq
fq2=$PDX_RNA/1739_PDX_R2.fastq

sorted=/shared/home/bhandarim/5_sorted/1_RNA/1_xengsort/Sample_1739_PDX
combined_fq=/shared/home/bhandarim/5_sorted/1_RNA/1_xengsort/1_Combined

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate xengsort
xengsort classify --index $index/myindex --compression none --fastq $fq1 --pairs $fq2 --prefix $sorted/1739 --threads 16
conda deactivate

#gzip -dk $sorted/*.gz

cat $sorted/1739-ambiguous.1.fq  $sorted/1739-both.1.fq  $sorted/1739-graft.1.fq  $sorted/1739-neither.1.fq   > $combined_fq/1739_PDX_RNAseq.R1.fq
cat $sorted/1739-ambiguous.2.fq  $sorted/1739-both.2.fq  $sorted/1739-graft.2.fq  $sorted/1739-neither.2.fq   > $combined_fq/1739_PDX_RNAseq.R2.fq

rm -r $sorted/*.fq