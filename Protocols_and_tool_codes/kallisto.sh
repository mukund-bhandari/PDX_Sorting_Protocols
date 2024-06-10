#!/bin/bash
#SBATCH --job-name xengs-kallisto-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/kallisto/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu



index=/shared/home/bhandarim/0_testing

PDX_RNA=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1739_PDX
fq1=$PDX_RNA/1739_PDX_R1.fastq
fq2=$PDX_RNA/1739_PDX_R2.fastq

sorted=/shared/home/bhandarim/5_sorted/1_RNA/1_xengsort/Sample_1739_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate xengsort

xengsort classify --index $index/myindex --compression none --fastq $fq1 --pairs $fq2 --prefix $sorted/1739

conda deactivate


######## now run kallisto ##################################################

fq=/shared/home/bhandarim/5_sorted/1_RNA/1_xengsort/Sample_1739_PDX
index=/shared/home/bhandarim/4_tools_index/kallisto

mkdir -p /shared/home/bhandarim/6_analysis/COUNTS/1_xengsort/Sample_1739_PDX
countfiles=/shared/home/bhandarim/6_analysis/COUNTS/1_xengsort/Sample_1739_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate kallisto


#need index file
kallisto quant \
-i $index/index \
-o $countfiles \
-t 8 \
--plaintext \
$fq/1739-graft.1.fq \
$fq/1739-graft.2.fq


conda deactivate