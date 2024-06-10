#!/bin/bash
#SBATCH --job-name WGS-PDX-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/ERROR/DNA/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


untrimmed=/shared/home/bhandarim/2_DNA_files/WGS/Sample_1739_PDX
fq=/shared/home/bhandarim/2_DNA_files/WGS/trimmed/Sample_1739_PDX
genome=/shared/home/bhandarim/4_tools_index/bwamem2/


bwa_output=/shared/home/bhandarim/5b_sorted_DNA/aligned_WGS/WGS/Sample_1739_PDX
name_sorted=/shared/home/bhandarim/5b_sorted_DNA/aligned_WGS/WGS_name_sorted/Sample_1739_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bwamemsamtools


bwa-mem2 mem -t 8 -M -R "@RG\tID:1739_PDX_WGS\tPL:illumina\tLB:1739_PDX_WGS\tPU:1739_PDX_WGS\tSM:1739_PDX_WGS" $genome/human/hg38.fa $fq/*1.fq $fq/*2.fq|samtools view -Shb -o $bwa_output/1739_PDX_WGS.human.bam -
samtools sort  -@ 8 -o $name_sorted/1739_PDX_WGS.human.namesorted.bam -n $bwa_output/1739_PDX_WGS.human.bam

bwa-mem2 mem -t 8 -M -R "@RG\tID:1739_PDX_WGS\tPL:illumina\tLB:1739_PDX_WGS\tPU:1739_PDX_WGS\tSM:1739_PDX_WGS" $genome/mouse/mm10.fa $fq/*1.fq $fq/*2.fq|samtools view -Shb -o $bwa_output/1739_PDX_WGS.mouse.bam -
samtools sort  -@ 8 -o $name_sorted/1739_PDX_WGS.mouse.namesorted.bam -n $bwa_output/1739_PDX_WGS.mouse.bam


conda deactivate