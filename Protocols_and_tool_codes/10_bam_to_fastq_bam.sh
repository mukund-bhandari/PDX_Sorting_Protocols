#!/bin/bash
#SBATCH --job-name 1754-BAM2fq2BAM
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 2-23:59:59
#SBATCH --output /shared/home/bhandarim/ERROR/DNA/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


genome=/shared/home/bhandarim/4_tools_index/bwamem2/

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bwamemsamtools

############################################################ Disambiguate ########
disamNS=/shared/home/bhandarim/5b_sorted_DNA/WES_SORTED/2_disambiguate/Sample_1754_PDX
mkdir -p /shared/home/bhandarim/TEMP/disambi/Sample_1754_PDX
tempDIS=/shared/home/bhandarim/TEMP/disambi/Sample_1754_PDX
mkdir -p /shared/home/bhandarim/5b_sorted_DNA/cleaned_for_GATK/disambi/Sample_1754_PDX
disamBWANS=/shared/home/bhandarim/5b_sorted_DNA/cleaned_for_GATK/disambi/Sample_1754_PDX


samtools sort  -@ 16 -o $tempDIS/1754_WES.human.namesorted.bam -n $disamNS/bwamem_disambi_1754.disambiguatedSpeciesA.bam
samtools fastq -@ 16 $tempDIS/1754_WES.human.namesorted.bam -1 $tempDIS/1754_PDX_WES_1.fastq.gz -2 $tempDIS/1754_PDX_WES_2.fastq.gz -0 /dev/null -s /dev/null -n -F 0x900

bwa-mem2 mem -t 16 -M -R "@RG\tID:1754_PDX_WES\tPL:illumina\tLB:1754_PDX_WES\tPU:1754_PDX_WES\tSM:1754_PDX_WES" $genome/human/hg38.fa $tempDIS/1754_PDX_WES_1.fastq.gz $tempDIS/1754_PDX_WES_2.fastq.gz|samtools view -@ 16 -Shb -o $disamBWANS/1754_WES.human.bam -
samtools sort  -@ 16 -o $disamBWANS/1754_WES.human.namesorted.bam -n $disamBWANS/1754_WES.human.bam
#rm $tempDIS/1754_WES.human.namesorted.bam $tempDIS/1754_PDX_WES_1.fastq.gz $tempDIS/1754_PDX_WES_2.fastq.gz


####################################################### BAMCMP ########
bamcmpNS=/shared/home/bhandarim/5b_sorted_DNA/WES_SORTED/4_bamcmp/Sample_1754_PDX
mkdir -p /shared/home/bhandarim/TEMP/bamcmp/Sample_1754_PDX
tempBAMCMP=/shared/home/bhandarim/TEMP/bamcmp/Sample_1754_PDX
mkdir -p /shared/home/bhandarim/5b_sorted_DNA/cleaned_for_GATK/bamcmp/Sample_1754_PDX
bamcmpBWANS=/shared/home/bhandarim/5b_sorted_DNA/cleaned_for_GATK/bamcmp/Sample_1754_PDX



samtools sort  -@ 16 -o $tempBAMCMP/1754_WES.human.namesorted.bam -n $bamcmpNS/bwamem_1754.bamcmp.merged.bam
samtools fastq -@ 16 $tempBAMCMP/1754_WES.human.namesorted.bam -1 $tempBAMCMP/1754_PDX_WES_1.fastq.gz -2 $tempBAMCMP/1754_PDX_WES_2.fastq.gz -0 /dev/null -s /dev/null -n -F 0x900

bwa-mem2 mem -t 16 -M -R "@RG\tID:1754_PDX_WES\tPL:illumina\tLB:1754_PDX_WES\tPU:1754_PDX_WES\tSM:1754_PDX_WES" $genome/human/hg38.fa $tempBAMCMP/1754_PDX_WES_1.fastq.gz $tempBAMCMP/1754_PDX_WES_2.fastq.gz|samtools view -@ 16 -Shb -o $bamcmpBWANS/1754_WES.human.bam -
samtools sort  -@ 16 -o $bamcmpBWANS/1754_WES.human.namesorted.bam -n $bamcmpBWANS/1754_WES.human.bam
#rm $tempBAMCMP/1754_WES.human.namesorted.bam $tempBAMCMP/1754_PDX_WES_1.fastq.gz $tempBAMCMP/1754_PDX_WES_2.fastq.gz 


########################################################## XENOFILTER ########

XenRNS=/shared/home/bhandarim/5b_sorted_DNA/WES_SORTED/5_xenofilteR/Sample_1754_PDX/Filtered_bams
mkdir -p /shared/home/bhandarim/TEMP/xenof/Sample_1754_PDX
tempXENO=/shared/home/bhandarim/TEMP/xenof/Sample_1754_PDX
mkdir -p /shared/home/bhandarim/5b_sorted_DNA/cleaned_for_GATK/xenof/Sample_1754_PDX
XenRBWANS=/shared/home/bhandarim/5b_sorted_DNA/cleaned_for_GATK/xenof/Sample_1754_PDX



samtools sort  -@ 16 -o $tempXENO/1754_WES.human.namesorted.bam -n $XenRNS/human_1754_sorted_Filtered.bam
samtools fastq -@ 16 $tempXENO/1754_WES.human.namesorted.bam -1 $tempXENO/1754_PDX_WES_1.fastq.gz -2 $tempXENO/1754_PDX_WES_2.fastq.gz -0 /dev/null -s /dev/null -n -F 0x900

bwa-mem2 mem -t 16 -M -R "@RG\tID:1754_PDX_WES\tPL:illumina\tLB:1754_PDX_WES\tPU:1754_PDX_WES\tSM:1754_PDX_WES" $genome/human/hg38.fa $tempXENO/1754_PDX_WES_1.fastq.gz $tempXENO/1754_PDX_WES_2.fastq.gz|samtools view -@ 16 -Shb -o $XenRBWANS/1754_WES.human.bam -
samtools sort  -@ 16 -o $XenRBWANS/1754_WES.human.namesorted.bam -n $XenRBWANS/1754_WES.human.bam
#rm $tempXENO/1754_WES.human.namesorted.bam $tempXENO/1754_PDX_WES_1.fastq.gz $tempXENO/1754_PDX_WES_2.fastq.gz


conda deactivate