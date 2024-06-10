############################################################################################
######################################## xengsort ##########################################
############################################################################################



#!/bin/bash
#SBATCH --job-name xengsort-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu

index=/shared/home/bhandarim/0_testing

PDX_RNA=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1795_PDX
fq1=$PDX_RNA/1795_PDX_R1.fastq
fq2=$PDX_RNA/1795_PDX_R2.fastq

sorted=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/1_xengsort/Sample_1795_PDX
log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate xengsort

start_time=$(date +%s)

xengsort classify --index $index/myindex --compression none --fastq $fq1 --pairs $fq2 --prefix $sorted/1795 --threads 4 > $log/xengsort_rna_1795.log

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "Xengsort 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/Xengsort_time.txt
rm -r /shared/home/bhandarim/B_time_test/2_tools/1_RNA/1_xengsort/Sample_1795_PDX

conda deactivate



############################################################################################
######################################## Disambiguate-hisat2 ###############################
############################################################################################


#!/bin/bash
#SBATCH --job-name disambi-hisat-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


hi_i=/shared/home/bhandarim/4_tools_index/hisat2
fq=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1795_PDX
log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time


transit_files=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/2_disambiguate/hisat_transit/Sample_1795_PDX
sorted_files=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/2_disambiguate/1_hisat/Sample_1795_PDX


mkdir -p $transit_files/{sam,bam}

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate hisat2

start_time=$(date +%s)

hisat2  -k 5 --phred33  --no-mixed --no-discordant -p 4 -q -x $hi_i/grch38_snp_tran/genome_snp_tran -1 $fq/"1795_PDX_R1.fastq"  -2 $fq/"1795_PDX_R2.fastq"  -S $transit_files/sam/"human_hisat2_mapped_1795.sam"
hisat2  -k 5 --phred33  --no-mixed --no-discordant -p 4 -q -x $hi_i/grcm38_snp_tran/genome_snp_tran -1 $fq/"1795_PDX_R1.fastq"  -2 $fq/"1795_PDX_R2.fastq"  -S $transit_files/sam/"mouse_hisat2_mapped_1795.sam"

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "Hisat2 mapping 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/hisat2_disambiguate_time.txt
conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate samtools

start_time=$(date +%s)
samtools sort -@ 4 -n  -o $transit_files/bam/"human_hisat2_sorted_1795.bam" $transit_files/sam/"human_hisat2_mapped_1795.sam"
samtools sort -@ 4 -n  -o $transit_files/bam/"mouse_hisat2_sorted_1795.bam" $transit_files/sam/"mouse_hisat2_mapped_1795.sam"

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "SAM2BAM 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/hisat2_disambiguate_time.txt
conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate disambiguate

start_time=$(date +%s)

ngs_disambiguate -s hisat2_DIS_1795  -o $sorted_files -a hisat2 $transit_files/bam/"human_hisat2_sorted_1795.bam" $transit_files/bam/"mouse_hisat2_sorted_1795.bam"

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "Disambiguate 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/hisat2_disambiguate_time.txt
conda deactivate


rm -r $transit_files/* $sorted_files/*.bam


############################################################################################
######################################## Disambiguate-star ###############################
############################################################################################

#!/bin/bash
#SBATCH --job-name disambi-star-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu

star=/shared/home/bhandarim/4_tools_index/star
gtf=/shared/home/bhandarim/3_reference_genomes/genecode_gtf/
fq=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1795_PDX
Time_test=/shared/home/bhandarim/B_time_test/4_time

temp=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/2_disambiguate/star_transit/Sample_1795_PDX
files=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/2_disambiguate/2_star/Sample_1795_PDX

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate STAR

start_time=$(date +%s)

STAR --runThreadN 4 \
--genomeDir $star/human \
--sjdbGTFfile $gtf/human/gencode.v29.annotation.gtf  \
--sjdbOverhang 99 \
--readFilesIn $fq/"1795_PDX_R1.fastq" $fq/"1795_PDX_R2.fastq" \
--outSAMtype BAM Unsorted \
--twopassMode Basic \
--outSAMattributes All \
--genomeLoad NoSharedMemory \
--outFileNamePrefix $temp/human_star_1795_

STAR --runThreadN 4 \
--genomeDir $star/mouse \
--sjdbGTFfile $gtf/mouse/gencode.vM34.annotation.gtf  \
--sjdbOverhang 99 \
--readFilesIn $fq/"1795_PDX_R1.fastq" $fq/"1795_PDX_R2.fastq" \
--outSAMtype BAM Unsorted \
--twopassMode Basic \
--outSAMattributes All \
--genomeLoad NoSharedMemory \
--outFileNamePrefix $temp/mouse_star_1795_

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "STAR mapping 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/STAR_disambiguate_time.txt

conda deactivate

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate samtools



start_time=$(date +%s)

samtools sort -@ 4 -o $files/human_star_1795_sorted.bam -n $temp/human_star_1795_Aligned.out.bam
samtools sort -@ 4 -o $files/mouse_star_1795_sorted.bam -n $temp/mouse_star_1795_Aligned.out.bam

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "BAM2BAM name sorting 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/STAR_disambiguate_time.txt

conda deactivate

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate disambiguate

start_time=$(date +%s)

ngs_disambiguate -s star_disambi_1795 -o $files -a star $files/human_star_1795_sorted.bam $files/mouse_star_1795_sorted.bam

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "disambiguate 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/STAR_disambiguate_time.txt

conda deactivate


rm -r $temp/*.bam $files/*.bam





############################################################################################
######################################## Disambiguate-WES ###############################
############################################################################################


#!/bin/bash
#SBATCH --job-name disambi-bwamem-WES-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu



bwa_output=/shared/home/bhandarim/transit_files_bwamem2/WES
name_sorted=/shared/home/bhandarim/transit_files_bwamem2/WES/name_sorted
files=/shared/home/bhandarim/B_time_test/2_tools/2_WES/2_disambiguate/Sample_1795_PDX

log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate disambiguate

start_time=$(date +%s)

ngs_disambiguate -s bwamem_disambi_1795 -o $files -a bwa $name_sorted/1795_PDX_WES.human.namesorted.bam $name_sorted/1795_PDX_WES.mouse.namesorted.bam

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "BWAmem2 disambiguate 1795 WES elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/Disambiguate_BWAmem2_WES_time.txt

conda deactivate


rm -r $files/*.bam



############################################################################################
######################################## Disambiguate-WGS ###############################
############################################################################################

#!/bin/bash
#SBATCH --job-name disambi-bwamem-WGS-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu



bwa_output=/shared/home/bhandarim/transit_files_bwamem2/WGS
name_sorted=/shared/home/bhandarim/transit_files_bwamem2/WGS/name_sorted
files=/shared/home/bhandarim/B_time_test/2_tools/3_WGS/2_disambiguate/Sample_1795_PDX

log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate disambiguate

start_time=$(date +%s)

ngs_disambiguate -s bwamem_disambi_1795 -o $files -a bwa $name_sorted/1795_PDX_WGS.human.namesorted.bam $name_sorted/1795_PDX_WGS.mouse.namesorted.bam

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "BWAmem2 disambiguate 1795 WGS elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/Disambiguate_BWAmem2_WGS_time.txt

conda deactivate


rm -r $files/*.bam





############################################################################################
######################################## bbsplit-RNA ###############################
############################################################################################

#!/bin/bash
#SBATCH --job-name bbmap-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


fq1=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1795_PDX
sorted_files=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/3_bbmap/Sample_1795_PDX


log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bbmap

start_time=$(date +%s)

bbsplit.sh \
        threads=4 \
        path=/shared/home/bhandarim/4_tools_index/bbmap \
        build=1 \
        in=$fq1/1795_PDX_R1.fastq \
        in2=$fq1/1795_PDX_R2.fastq \
        basename=$sorted_files/1795_%_RNAseq_#.fq \
        outu1=$sorted_files/1795.clean1.fq outu2=$sorted_files/1795.clean2.fq \
        ambig2=split \
        scafstats=$sorted_files/1795_read_mapped.txt \
        refstats=$sorted_files/1795_read_assigned.txt


end_time=$(date +%s)
duration=$((end_time - start_time))
echo "BBmap 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/BBmap_time.txt
rm -r $sorted_files/*.fq

conda deactivate


############################################################################################
######################################## bbsplit-WES ###############################
############################################################################################
#!/bin/bash
#SBATCH --job-name bbmap-WES-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


fq1=/shared/home/bhandarim/2_PDX_files/2_WES/Sample_1795_PDX
sorted_files=/shared/home/bhandarim/B_time_test/2_tools/2_WES/3_bbmap/Sample_1795_PDX


log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bbmap

start_time=$(date +%s)

bbsplit.sh \
        threads=4 \
        path=/shared/home/bhandarim/4_tools_index/bbmap \
        build=1 \
        in=$fq1/1795_PDX_R1.fastq \
        in2=$fq1/1795_PDX_R2.fastq \
        basename=$sorted_files/1795_%_WESseq_#.fq \
        outu1=$sorted_files/1795.clean1.fq outu2=$sorted_files/1795.clean2.fq \
        ambig2=split \
        scafstats=$sorted_files/1795_read_mapped.txt \
        refstats=$sorted_files/1795_read_assigned.txt


end_time=$(date +%s)
duration=$((end_time - start_time))
echo "BBmap 1795 WES elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/BBmap_WES_time.txt
rm -r $sorted_files/*.fq

conda deactivate


############################################################################################
######################################## bamcmp-hisat ###############################
############################################################################################
#!/bin/bash
#SBATCH --job-name bamcmp-hisat-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


hi_i=/shared/home/bhandarim/4_tools_index/hisat2
fq=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1795_PDX
log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time


transit_files=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/4_bamcmp/1_hisat/1_temp/Sample_1795_PDX
sorted_files=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/4_bamcmp/1_hisat/2_sorted/Sample_1795_PDX


mkdir -p $transit_files/{sam,bam}

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate hisat2

start_time=$(date +%s)

hisat2  -k 5 --phred33  --no-mixed --no-discordant -p 4 -q -x $hi_i/grch38_snp_tran/genome_snp_tran -1 $fq/"1795_PDX_R1.fastq"  -2 $fq/"1795_PDX_R2.fastq"  -S $transit_files/sam/"human_hisat2_mapped_1795.sam"
hisat2  -k 5 --phred33  --no-mixed --no-discordant -p 4 -q -x $hi_i/grcm38_snp_tran/genome_snp_tran -1 $fq/"1795_PDX_R1.fastq"  -2 $fq/"1795_PDX_R2.fastq"  -S $transit_files/sam/"mouse_hisat2_mapped_1795.sam"

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "Hisat2 mapping 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/hisat2_bamcmp_time.txt
conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate samtools

start_time=$(date +%s)
samtools sort -@ 4 -n  -o $transit_files/bam/"human_hisat2_sorted_1795.bam" $transit_files/sam/"human_hisat2_mapped_1795.sam"
samtools sort -@ 4 -n  -o $transit_files/bam/"mouse_hisat2_sorted_1795.bam" $transit_files/sam/"mouse_hisat2_mapped_1795.sam"

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "SAM2BAM 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/hisat2_bamcmp_time.txt
conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bamcmp


start_time=$(date +%s)

bamcmp -n -t 4 \
   -1 $transit_files/bam/"human_hisat2_sorted_1795.bam"  \
   -2 $transit_files/bam/"mouse_hisat2_sorted_1795.bam" \
   -a $sorted_files/hisat_1795.bamcmp.humanOnly.bam \
   -A $sorted_files/hisat_1795.bamcmp.humanBetter.bam \
   -b $sorted_files/hisat_1795.bamcmp.mouseOnly.bam \
   -B $sorted_files/hisat_1795.bamcmp.mouseBetter.bam \
   -s match

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "bamcmp 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/hisat2_bamcmp_time.txt

conda deactivate

rm -r $transit_files/sam/*.sam  $transit_files/bam/*.bam $sorted_files/*.bam


############################################################################################
######################################## bamcmp-star ###############################
############################################################################################

#!/bin/bash
#SBATCH --job-name disambi-star-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu

star=/shared/home/bhandarim/4_tools_index/star
gtf=/shared/home/bhandarim/3_reference_genomes/genecode_gtf/
fq=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1795_PDX
Time_test=/shared/home/bhandarim/B_time_test/4_time

temp=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/4_bamcmp/2_star/1_temp/Sample_1795_PDX
RES=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/4_bamcmp/2_star/2_sorted/Sample_1795_PDX

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate STAR

start_time=$(date +%s)

STAR --runThreadN 4 \
--genomeDir $star/human \
--sjdbGTFfile $gtf/human/gencode.v29.annotation.gtf  \
--sjdbOverhang 99 \
--readFilesIn $fq/"1795_PDX_R1.fastq" $fq/"1795_PDX_R2.fastq" \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic \
--outSAMattributes All \
--genomeLoad NoSharedMemory \
--outFileNamePrefix $temp/human_star_1795_

STAR --runThreadN 4 \
--genomeDir $star/mouse \
--sjdbGTFfile $gtf/mouse/gencode.vM34.annotation.gtf  \
--sjdbOverhang 99 \
--readFilesIn $fq/"1795_PDX_R1.fastq" $fq/"1795_PDX_R2.fastq" \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic \
--outSAMattributes All \
--genomeLoad NoSharedMemory \
--outFileNamePrefix $temp/mouse_star_1795_

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "STAR mapping 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/STAR_bamcmp_time.txt

conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bamcmp

start_time=$(date +%s)

bamcmp -n -t 4 \
-1 $temp/human_star_1795_Aligned.sortedByCoord.out.bam  \
-2 $temp/mouse_star_1795_Aligned.sortedByCoord.out.bam \
-a $RES/star_1795.bamcmp.humanOnly.bam \
-A $RES/star_1795.bamcmp.humanBetter.bam \
-b $RES/star_1795.bamcmp.mouseOnly.bam \
-B $RES/star_1795.bamcmp.mouseBetter.bam \
-s match

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "bamcmp 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/STAR_bamcmp_time.txt

conda deactivate

rm -r $temp/*.bam $RES/*.bam




############################################################################################
######################################## bamcmp-WES ###############################
############################################################################################
#!/bin/bash
#SBATCH --job-name bamcmp-bwamem-WES-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time

name_sorted=/shared/home/bhandarim/transit_files_bwamem2/WES/name_sorted
sorted_files=/shared/home/bhandarim/B_time_test/2_tools/2_WES/4_bamcmp/Sample_1795_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bamcmp

start_time=$(date +%s)

bamcmp -n -t 4 \
   -1 $name_sorted/1795_PDX_WES.human.namesorted.bam  \
   -2 $name_sorted/1795_PDX_WES.mouse.namesorted.bam \
   -a $sorted_files/hisat_1795.bamcmp.humanOnly.bam \
   -A $sorted_files/hisat_1795.bamcmp.humanBetter.bam \
   -C $sorted_files/hisat_1795.bamcmp.humanWorse.bam \
   -b $sorted_files/hisat_1795.bamcmp.mouseOnly.bam \
   -B $sorted_files/hisat_1795.bamcmp.mouseBetter.bam \
   -D $sorted_files/hisat_1795.bamcmp.mouseWorse.bam \
   -s match

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "BWAmem2 bamcmp 1795 WES elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/BAMCMP_BWAmem2_WES_time.txt

conda deactivate


rm -r $sorted_files/*.bam


############################################################################################
######################################## bamcmp-WGS ###############################
############################################################################################


#!/bin/bash
#SBATCH --job-name bamcmp-bwamem-WGS-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time

name_sorted=/shared/home/bhandarim/transit_files_bwamem2/WGS/name_sorted
sorted_files=/shared/home/bhandarim/B_time_test/2_tools/3_WGS/4_bamcmp/Sample_1795_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bamcmp

start_time=$(date +%s)

bamcmp -n -t 4 \
   -1 $name_sorted/1795_PDX_WGS.human.namesorted.bam  \
   -2 $name_sorted/1795_PDX_WGS.mouse.namesorted.bam \
   -a $sorted_files/hisat_1795.bamcmp.humanOnly.bam \
   -A $sorted_files/hisat_1795.bamcmp.humanBetter.bam \
   -C $sorted_files/hisat_1795.bamcmp.humanWorse.bam \
   -b $sorted_files/hisat_1795.bamcmp.mouseOnly.bam \
   -B $sorted_files/hisat_1795.bamcmp.mouseBetter.bam \
   -D $sorted_files/hisat_1795.bamcmp.mouseWorse.bam \
   -s match

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "BWAmem2 bamcmp 1795 WGS elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/BAMCMP_BWAmem2_WGS_time.txt

conda deactivate


rm -r $sorted_files/*.bam



############################################################################################
######################################## xenofilter-hisat ###############################
############################################################################################
#!/bin/bash
#SBATCH --job-name xenofilter-hisat-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


hi_i=/shared/home/bhandarim/4_tools_index/hisat2
fq=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1795_PDX
log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time


transit_files=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/5_xenofilteR/1_hisat/1_temp/Sample_1795_PDX
sorted_files=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/5_xenofilteR/1_hisat/2_sorted/Sample_1795_PDX
scripts=/shared/home/bhandarim/B_time_test/1_scipts/5_xenofilteR/1_hisat/2_Rcodes


mkdir -p $transit_files/{sam,bam}

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate hisat2

start_time=$(date +%s)

hisat2  -k 5 --phred33  --no-mixed --no-discordant -p 4 -q -x $hi_i/grch38_snp_tran/genome_snp_tran -1 $fq/"1795_PDX_R1.fastq"  -2 $fq/"1795_PDX_R2.fastq"  -S $transit_files/sam/"human_hisat2_mapped_1795.sam"
hisat2  -k 5 --phred33  --no-mixed --no-discordant -p 4 -q -x $hi_i/grcm38_snp_tran/genome_snp_tran -1 $fq/"1795_PDX_R1.fastq"  -2 $fq/"1795_PDX_R2.fastq"  -S $transit_files/sam/"mouse_hisat2_mapped_1795.sam"

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "Hisat2 mapping 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/hisat2_xenofilter_time.txt
conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate samtools

start_time=$(date +%s)
samtools sort -@ 4 -o $transit_files/bam/"human_hisat2_sorted_1795.bam" $transit_files/sam/"human_hisat2_mapped_1795.sam"
samtools sort -@ 4 -o $transit_files/bam/"mouse_hisat2_sorted_1795.bam" $transit_files/sam/"mouse_hisat2_mapped_1795.sam"

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "SAM2BAM 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/hisat2_xenofilter_time.txt
conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate R

start_time=$(date +%s)

srun Rscript $scripts/1795.R > $log/timetest_1795.R.log

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "xenofilter hisat 1795 RNA elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/hisat2_xenofilter_time.txt

conda deactivate


rm -r $transit_files/sam/*.sam  $transit_files/bam/*.bam $sorted_files/*.bam



#usage: run this R script using .sh script 

# args <- commandArgs(trailingOnly = TRUE)
# print(args)

#load library
library("XenofilteR")
#setting environment
bp.param <- SnowParam(workers = 4, type = "SOCK")


##define path and final output directory
path <- ("/shared/home/bhandarim/B_time_test/2_tools/1_RNA/5_xenofilteR/1_hisat/1_temp/Sample_1795_PDX/bam")
out_dir<- '/shared/home/bhandarim/B_time_test/2_tools/1_RNA/5_xenofilteR/1_hisat/2_sorted/Sample_1795_PDX'

#make list of files
human= list.files(path= path, pattern = "human", full.names = TRUE)
mouse= list.files(path= path, pattern = "mouse", full.names = TRUE)

#make single matrix
sample.list <- as.data.frame(cbind (human, mouse))
#running XenofilteR
XenofilteR(sample.list, destination.folder = out_dir, bp.param = bp.param)


############################################################################################
######################################## xenofilter-wes ###############################
############################################################################################

#!/bin/bash
#SBATCH --job-name bwamem-xenofilter-1795
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/B_time_test/0_err/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu

scripts=/shared/home/bhandarim/B_time_test/1_scipts/5_xenofilteR/3_WES
log=/shared/home/bhandarim/B_time_test/3_log
Time_test=/shared/home/bhandarim/B_time_test/4_time
bwa_output=/shared/home/bhandarim/transit_files_bwamem2/WES
coord_sorted=/shared/home/bhandarim/transit_files_bwamem2/WES/coord_sorted/Sample_1795_PDX

out_dir=/shared/home/bhandarim/B_time_test/2_tools/2_WES/5_xenofilteR/Sample_1795_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate samtools

start_time=$(date +%s)

samtools sort -@ 4 -o $coord_sorted/human_star_1795_sorted.bam  $bwa_output/1795_PDX_WES.human.bam
samtools sort -@ 4 -o $coord_sorted/mouse_star_1795_sorted.bam  $bwa_output/1795_PDX_WES.mouse.bam

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "BAM2BAM sorting 1795 WES elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/WES_bwamem2_xenofilter_time.txt

conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate R

start_time=$(date +%s)
srun Rscript $scripts/1795.R > $log/bwamem2_xenofilter_1795.R.log

end_time=$(date +%s)
duration=$((end_time - start_time))
echo "xenofilter BWAmem 1795 WES elapsed time $((duration/60)) minutes and $((duration % 60)) seconds" >> $Time_test/WES_bwamem2_xenofilter_time.txt
conda deactivate

rm -r $out_dir/*.bam


#usage: run this R script using .sh script 

# args <- commandArgs(trailingOnly = TRUE)
# print(args)

#load library
library("XenofilteR")
#setting environment
bp.param <- SnowParam(workers = 4, type = "SOCK")


##define path and final output directory
path <- ("/shared/home/bhandarim/transit_files_bwamem2/WES/coord_sorted/Sample_1795_PDX")
out_dir<- '/shared/home/bhandarim/B_time_test/2_tools/2_WES/5_xenofilteR/Sample_1795_PDX'

#make list of files
human= list.files(path= path, pattern = "human", full.names = TRUE)
mouse= list.files(path= path, pattern = "mouse", full.names = TRUE)

#make single matrix
sample.list <- as.data.frame(cbind (human, mouse))
#running XenofilteR
XenofilteR(sample.list, destination.folder = out_dir, bp.param = bp.param)


############################################################################################
######################################## xenomer-rna###############################
############################################################################################


#!/bin/bash
#SBATCH --job-name timetest-1795-xenome
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 0-06:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


index=/shared/home/bhandarim/4_tools_index/xenome
fq=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1795_PDX

sorted=/shared/home/bhandarim/B_time_test/2_tools/1_RNA/6_xenome/Sample_1795_PDX


module load /shared/apps2/modules/modulefiles/singularity/


timeout 400m singularity exec /shared/home/bhandarim/gossamer.sif xenome classify \
  -T 4 -P $index/idx \
  --pairs \
  --host-name mouse \
  --graft-name human \
  -i $fq/"1795_PDX_R1.fastq" \
  -i $fq/"1795_PDX_R2.fastq"  \
  --output-filename-prefix $sorted/1795
                                       



############################################################################################
######################################## xenomer-wes###############################
############################################################################################

#!/bin/bash
#SBATCH --job-name timetest-WES-1795-xenome
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 0-06:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


index=/shared/home/bhandarim/4_tools_index/xenome
fq=/shared/home/bhandarim/2_PDX_files/2_WES/Sample_1795_PDX

sorted=/shared/home/bhandarim/B_time_test/2_tools/2_WES/6_xenome/Sample_1795_PDX


module load /shared/apps2/modules/modulefiles/singularity/


timeout 400m singularity exec /shared/home/bhandarim/gossamer.sif xenome classify \
  -T 4 -P $index/idx \
  --pairs \
  --host-name mouse \
  --graft-name human \
  -i $fq/"1795_PDX_R1.fastq" \
  -i $fq/"1795_PDX_R2.fastq"  \
  --output-filename-prefix $sorted/1795



############################################################################################
######################################## xenomer-wgs###############################
############################################################################################


#!/bin/bash
#SBATCH --job-name timetest-WGS-1795-xenome
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 4
#SBATCH --partition=hpc
#SBATCH --time 0-06:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


index=/shared/home/bhandarim/4_tools_index/xenome
fq=/shared/home/bhandarim/2_PDX_files/3_WGS/Sample_1795_PDX

sorted=/shared/home/bhandarim/B_time_test/2_tools/3_WGS/6_xenome/Sample_1795_PDX


module load /shared/apps2/modules/modulefiles/singularity/


timeout 400m singularity exec /shared/home/bhandarim/gossamer.sif xenome classify \
  -T 4 -P $index/idx \
  --pairs \
  --host-name mouse \
  --graft-name human \
  -i $fq/"1795_PDX_R1.fastq" \
  -i $fq/"1795_PDX_R2.fastq"  \
  --output-filename-prefix $sorted/1795
