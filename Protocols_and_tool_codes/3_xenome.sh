############################################################################################################## 
################################################  3.xenome ################################################ 
############################################################################################################## 

########################  create xenome index ######################## 
#!/bin/bash
#SBATCH --job-name xenome-index
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 12
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu

ref=/shared/home/bhandarim/3_reference_genomes/ensemble
index=/shared/home/bhandarim/4_tools_index/xenome


module load /shared/apps2/modules/modulefiles/singularity/

singularity exec /shared/home/bhandarim/gossamer.sif xenome index -T 12 -P $index/index  -H $ref/Mus_musculus.GRCm39.dna.toplevel.fa -G $ref/Homo_sapiens.GRCh38.dna.toplevel.fa

########################  sort using xengsort ############################
#!/bin/bash
#SBATCH --job-name 1739-xenome-classify-merge
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 0-01:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu

ref=/shared/home/bhandarim/3_reference_genomes/ensemble
index=/shared/home/bhandarim/4_tools_index/xenome
fq=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1739_PDX
sorted=/shared/home/bhandarim/5_sorted/1_RNA/6_xenome/Sample_1739_PDX
Time_test=/shared/home/bhandarim/B_time_test/4_time
combined_fq=/shared/home/bhandarim/5_sorted/1_RNA/6_xenome/1_Combined

module load /shared/apps2/modules/modulefiles/singularity/

#singularity exec /shared/home/bhandarim/gossamer.sif xenome index -T 12 -P $index/index  -H $ref/Mus_musculus.GRCm39.dna.toplevel.fa -G $ref/Homo_sapiens.GRCh38.dna.toplevel.fa


#start_time=$(date +%s)

timeout 75m singularity exec /shared/home/bhandarim/gossamer.sif xenome classify \
  -T 16 -M 100 -P $index/idx \
  --pairs \
  --host-name mouse \
  --graft-name human \
  -i $fq/"1739_PDX_R1.fastq" \
  -i $fq/"1739_PDX_R2.fastq"  \
  --output-filename-prefix $sorted/1739

#end_time=$(date +%s)
#duration=$((end_time - start_time))

#echo "xenome RNA 1739 elapsed time is $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/Xenome_RNA_time.txt


cat $sorted/1739_ambiguous_1.fastq  $sorted/1739_both_1.fq  $sorted/1739_human_1.fastq  $sorted/1739_neither_1.fq   > $combined_fq/1739_PDX_RNAseq.R1.fq
cat $sorted/1739_ambiguous_2.fastq  $sorted/1739_both_2.fq  $sorted/1739_human_2.fastq  $sorted/1739_neither_2.fq   > $combined_fq/1739_PDX_RNAseq.R2.fq

rm -r $sorted/*.fq