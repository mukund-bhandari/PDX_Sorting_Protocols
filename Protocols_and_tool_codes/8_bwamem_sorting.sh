#!/bin/bash
#SBATCH --job-name XSORT-WEGS-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/ERROR/DNA/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu



WES=/shared/home/bhandarim/2_DNA_files/WES/Sample_1739_PDX
WGS=/shared/home/bhandarim/2_DNA_files/WGS/trimmed/Sample_1739_PDX
index=/shared/home/bhandarim/0_testing


SORTED_WES=/shared/home/bhandarim/5b_sorted_DNA/WES_SORTED/1_xengsort/Sample_1739_PDX
SORTED_WGS=/shared/home/bhandarim/5b_sorted_DNA/WGS_SORTED/1_xengsort/Sample_1739_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate xengsort

xengsort classify --index $index/myindex --compression none --fastq $WES/*R1.fastq --pairs $WES/*R2.fastq --prefix $SORTED_WES/1739 --threads 8
xengsort classify --index $index/myindex --compression none --fastq $WGS/*1.fq --pairs $WGS/*2.fq --prefix $SORTED_WGS/1739 --threads 8

conda deactivate