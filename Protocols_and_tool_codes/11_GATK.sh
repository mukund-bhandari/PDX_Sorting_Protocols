#!/bin/bash
#SBATCH --job-name 1754-xengsort-GATK
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 2-23:59:59
#SBATCH --output /shared/home/bhandarim/ERROR/DNA/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


module load gatk/4.4
picard_path=/shared/home/bhandarim/Tools

mkdir -p /shared/home/bhandarim/PICARD_TEMP/1_xengsort
temp=/shared/home/bhandarim/PICARD_TEMP/1_xengsort
broad_hg38=/shared/home/bhandarim/GATK_resources
GATK_path=/shared/.apps2/spack/opt/spack/linux-centos7-x86_64_v3/gcc-4.8.5/gatk-4.4.0.0-52tbsjddwz2mxkci2bxp2apz3w4elmmr/bin/

PDX=/shared/home/bhandarim/5b_sorted_DNA/FINAL_all/1_xengsort
PDX_WES_BWA_processed=/shared/home/bhandarim/D_GATK/1_xengsort


java -Xmx200g -Djava.io.tmpdir=$temp -jar $picard_path/picard.jar AddOrReplaceReadGroups I=$PDX/1754_WES.human.namesorted.bam O=$PDX_WES_BWA_processed/1754_PDX_WES.added.sorted.bam SO=coordinate RGLB=1754_PDX_WES RGPL=illumina RGPU=1754_PDX_WES RGSM=1754_PDX_WES

java -Xmx200g -Djava.io.tmpdir=$temp -jar $picard_path/picard.jar MarkDuplicates I=$PDX_WES_BWA_processed/1754_PDX_WES.added.sorted.bam O=$PDX_WES_BWA_processed/1754_PDX_WES.added.dedupped.bam VALIDATION_STRINGENCY=SILENT CREATE_INDEX=true M=$PDX_WES_BWA_processed/1754_PDX_WES.dedup.metrics.txt

java -Xmx200g -Djava.io.tmpdir=$temp -jar $GATK_path/gatk-package-4.4.0.0-local.jar BaseRecalibrator -R $broad_hg38/Homo_sapiens_assembly38.fasta \
-I $PDX_WES_BWA_processed/1754_PDX_WES.added.dedupped.bam --known-sites  $broad_hg38/1000G_phase1.snps.high_confidence.hg38.vcf --known-sites $broad_hg38/Homo_sapiens_assembly38.dbsnp138.vcf \
--known-sites $broad_hg38/Mills_and_1000G_gold_standard.indels.hg38.vcf --known-sites $broad_hg38/Homo_sapiens_assembly38.known_indels.vcf -O $PDX_WES_BWA_processed/1754_PDX_WES.data.table

java -Xmx200g -Djava.io.tmpdir=$temp -jar $GATK_path/gatk-package-4.4.0.0-local.jar ApplyBQSR -R $broad_hg38/Homo_sapiens_assembly38.fasta  \
-I $PDX_WES_BWA_processed/1754_PDX_WES.added.dedupped.bam --bqsr-recal-file $PDX_WES_BWA_processed/1754_PDX_WES.data.table -O $PDX_WES_BWA_processed/1754_PDX_WES.dedupped.recal.bam

/bin/rm -rf $PDX_WES_BWA_processed/1754_PDX_WES.added.sorted.bam $PDX_WES_BWA_processed/1754_PDX_WES.added.dedupped.bam