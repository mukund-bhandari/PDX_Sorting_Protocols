#!/bin/bash
#SBATCH --job-name 1754-mutect-xengsort
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 2-23:59:59
#SBATCH --output /shared/home/bhandarim/ERROR/DNA/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu

module load gatk/4.4

picard_path=/shared/home/bhandarim/Tools
GATK_path=/shared/.apps2/spack/opt/spack/linux-centos7-x86_64_v3/gcc-4.8.5/gatk-4.4.0.0-52tbsjddwz2mxkci2bxp2apz3w4elmmr/bin/
broad_hg38=/shared/home/bhandarim/GATK_resources

mkdir -p /shared/home/bhandarim/MUTECT2
temp=/shared/home/bhandarim/MUTECT2


###### test 1 sample #######################
normalsample=/shared/home/bhandarim/symbolic_files/D_GATK/00_GL
tumorsample=/shared/home/bhandarim/symbolic_files/D_GATK/1_xengsort

mkdir -p /shared/home/bhandarim/E_MUTECT/xengsort/Sample_1754_PDX
MUTECT=/shared/home/bhandarim/E_MUTECT/xengsort/Sample_1754_PDX


######run mutect2 ###########
java -Xmx200g -Djava.io.tmpdir=$temp -jar $GATK_path/gatk-package-4.4.0.0-local.jar \
Mutect2 -R $broad_hg38/Homo_sapiens_assembly38.fasta \
-L $broad_hg38/wgs_calling_regions.hg38.interval_list \
-I $tumorsample/1754_PDX_WES.dedupped.recal.bam \
-tumor 1754_PDX_WES \
-I $normalsample/1754_GL_WES.dedupped.recal.bam \
-normal 1754_GL_WES \
--germline-resource $broad_hg38/af-only-gnomad.hg38.vcf.gz \
--panel-of-normals $broad_hg38/gatk4_mutect2_4136_pon.vcf \
-O $MUTECT/1754_mutect.raw.vcf



####filter 
java -Xmx200g -Djava.io.tmpdir=$temp -jar $GATK_path/gatk-package-4.4.0.0-local.jar \
FilterMutectCalls \
-R $broad_hg38/Homo_sapiens_assembly38.fasta \
-V $MUTECT/1754_mutect.raw.vcf \
-O $MUTECT/1754_mutect.filter.vcf


###selelct variants snp
java -Xmx200g -Djava.io.tmpdir=$temp -jar $GATK_path/gatk-package-4.4.0.0-local.jar \
SelectVariants \
-R $broad_hg38/Homo_sapiens_assembly38.fasta \
-V $MUTECT/1754_mutect.filter.vcf \
-O $MUTECT/1754_mutect.raw.snp.vcf \
--select-type-to-include SNP \
--select-type-to-include MNP

###selelct variants indel
java -Xmx200g -Djava.io.tmpdir=$temp -jar $GATK_path/gatk-package-4.4.0.0-local.jar \
SelectVariants \
-R $broad_hg38/Homo_sapiens_assembly38.fasta \
-V $MUTECT/1754_mutect.filter.vcf \
-O $MUTECT/1754_mutect.raw.indel.vcf \
--select-type-to-include INDEL


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bcftools
####### fileter for quality ######################
less $MUTECT/1754_mutect.raw.snp.vcf|bcftools view -i 'FILTER="PASS"'>$MUTECT/1754_mutect.fil.snp.vcf
less $MUTECT/1754_mutect.raw.indel.vcf|bcftools view -i 'FILTER="PASS"'>$MUTECT/1754_mutect.fil.indel.vcf
conda deactivate

#### merge those snp and indel files
java -Xmx200g -Djava.io.tmpdir=$temp -jar $picard_path/picard.jar \
MergeVcfs \
I=$MUTECT/1754_mutect.fil.snp.vcf \
I=$MUTECT/1754_mutect.fil.indel.vcf  \
O=$MUTECT/1754.mutect.vcf


