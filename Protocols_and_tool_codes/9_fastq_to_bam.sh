#!/bin/bash
#SBATCH --job-name 1754-fq2BAM
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/ERROR/DNA/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


genome=/shared/home/bhandarim/4_tools_index/bwamem2/

fq_xengsort=/shared/home/bhandarim/5b_sorted_DNA/WES_SORTED/1_xengsort/Sample_1754_PDX
name_xengsort=/shared/home/bhandarim/5b_sorted_DNA/WES_SORTED/1_xengsort/1_name_sorted

fq_bbmap=/shared/home/bhandarim/5b_sorted_DNA/WES_SORTED/3_bbmap/Sample_1754_PDX
name_bbmap=/shared/home/bhandarim/5b_sorted_DNA/WES_SORTED/3_bbmap/1_name_sorted

fq_xenome=/shared/home/bhandarim/5b_sorted_DNA/WES_SORTED/6_xenome/Sample_1754_PDX
name_xenome=/shared/home/bhandarim/5b_sorted_DNA/WES_SORTED/6_xenome/1_name_sorted


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bwamemsamtools

bwa-mem2 mem -t 16 -M -R "@RG\tID:1754_PDX_WES\tPL:illumina\tLB:1754_PDX_WES\tPU:1754_PDX_WES\tSM:1754_PDX_WES" $genome/human/hg38.fa $fq_xengsort/1754-graft.1.fq $fq_xengsort/1754-graft.2.fq|samtools view -@ 16 -Shb -o $name_xengsort/1754_WES.human.bam -
samtools sort  -@ 16 -o $name_xengsort/1754_WES.human.namesorted.bam -n $name_xengsort/1754_WES.human.bam
#rm $name_xengsort/1754_WES.human.bam


bwa-mem2 mem -t 16 -M -R "@RG\tID:1754_PDX_WES\tPL:illumina\tLB:1754_PDX_WES\tPU:1754_PDX_WES\tSM:1754_PDX_WES" $genome/human/hg38.fa $fq_bbmap/1754_Human_WESseq_1.fq $fq_bbmap/1754_Human_WESseq_2.fq|samtools view -@ 16 -Shb -o $name_bbmap/1754_WES.human.bam -
samtools sort  -@ 16 -o $name_bbmap/1754_WES.human.namesorted.bam -n $name_bbmap/1754_WES.human.bam
#rm $name_bbmap/1754_WES.human.bam

bwa-mem2 mem -t 16 -M -R "@RG\tID:1754_PDX_WES\tPL:illumina\tLB:1754_PDX_WES\tPU:1754_PDX_WES\tSM:1754_PDX_WES" $genome/human/hg38.fa $fq_xenome/1754_human_1.fastq $fq_xenome/1754_human_2.fastq|samtools view -@ 16 -Shb -o $name_xenome/1754_WES.human.bam -
samtools sort  -@ 16 -o $name_xenome/1754_WES.human.namesorted.bam -n $name_xenome/1754_WES.human.bam
#rm $name_xenome/1754_WES.human.bam


conda deactivate