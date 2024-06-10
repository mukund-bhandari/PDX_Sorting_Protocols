############################################################################################################## 
################################################  5. Bamcmp-star ################################################ 
############################################################################################################## 
#!/bin/bash
#SBATCH --job-name STAR-disambiguate-bamcmp-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


star=/shared/home/bhandarim/4_tools_index/star
gtf=/shared/home/bhandarim/3_reference_genomes/genecode_gtf/
fq=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1739_PDX
temp=/shared/home/bhandarim/transit_files_star/Sample_1739_PDX
files=/shared/home/bhandarim/5_sorted/1_RNA/2_disambiguate/2_star/Sample_1739_PDX
RES=/shared/home/bhandarim/5_sorted/1_RNA/4_bamcmp/2_star/Sample_1739_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate STAR
STAR --runThreadN 16 \
--genomeDir $star/human \
--sjdbGTFfile $gtf/human/gencode.v29.annotation.gtf  \
--sjdbOverhang 99 \
--readFilesIn $fq/"1739_PDX_R1.fastq" $fq/"1739_PDX_R2.fastq" \
--outSAMtype BAM Unsorted \
--twopassMode Basic \
--outSAMattributes All \
--genomeLoad NoSharedMemory \
--outFileNamePrefix $temp/human_star_1739_  \
--outReadsUnmapped Fastx


STAR --runThreadN 16 \
--genomeDir $star/mouse \
--sjdbGTFfile $gtf/mouse/gencode.vM34.annotation.gtf  \
--sjdbOverhang 99 \
--readFilesIn $fq/"1739_PDX_R1.fastq" $fq/"1739_PDX_R2.fastq" \
--outSAMtype BAM Unsorted \
--twopassMode Basic \
--outSAMattributes All \
--genomeLoad NoSharedMemory \
--outFileNamePrefix $temp/mouse_star_1739_


conda deactivate

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate samtools
samtools sort -@ 16 -o $files/human_star_1739_sorted.bam -n $temp/human_star_1739_Aligned.out.bam
samtools sort -@ 16 -o $files/mouse_star_1739_sorted.bam -n $temp/mouse_star_1739_Aligned.out.bam
conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bamcmp
bamcmp -n -t 16 \
-1 $files/human_star_1739_sorted.bam  \
-2 $files/mouse_star_1739_sorted.bam \
-a $RES/star_1739.bamcmp.humanOnly.bam \
-A $RES/star_1739.bamcmp.humanBetter.bam \
-b $RES/star_1739.bamcmp.mouseOnly.bam \
-B $RES/star_1739.bamcmp.mouseBetter.bam \
-s match

conda deactivate