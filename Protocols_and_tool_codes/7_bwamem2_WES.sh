#!/bin/bash
#SBATCH --job-name MEM-WES-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/ERROR/DNA/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


genome=/shared/home/bhandarim/4_tools_index/bwamem2/
fq=/shared/home/bhandarim/2_DNA_files/WES/Sample_1739_PDX


bwa_output=/shared/home/bhandarim/5b_sorted_DNA/aligned_WES/WES/Sample_1739_PDX
name_sorted=/shared/home/bhandarim/5b_sorted_DNA/aligned_WES/WES_name_sorted/Sample_1739_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bwamemsamtools


bwa-mem2 mem -t 8 -M -R "@RG\tID:1739_PDX_WES\tPL:illumina\tLB:1739_PDX_WES\tPU:1739_PDX_WES\tSM:1739_PDX_WES" $genome/human/hg38.fa $fq/*R1.fastq $fq/*R2.fastq|samtools view -Shb -o $bwa_output/1739_PDX_WES.human.bam -
samtools sort  -@ 8 -o $name_sorted/1739_PDX_WES.human.namesorted.bam -n $bwa_output/1739_PDX_WES.human.bam

bwa-mem2 mem -t 8 -M -R "@RG\tID:1739_PDX_WES\tPL:illumina\tLB:1739_PDX_WES\tPU:1739_PDX_WES\tSM:1739_PDX_WES" $genome/mouse/mm10.fa $fq/*R1.fastq $fq/*R2.fastq|samtools view -Shb -o $bwa_output/1739_PDX_WES.mouse.bam -
samtools sort  -@ 8 -o $name_sorted/1739_PDX_WES.mouse.namesorted.bam -n $bwa_output/1739_PDX_WES.mouse.bam


conda deactivate