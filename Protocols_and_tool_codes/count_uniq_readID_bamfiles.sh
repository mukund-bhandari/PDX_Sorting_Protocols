#!/bin/bash
#SBATCH --job-name BAMCMP_HISAT-count-uniq
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 3-23:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu



source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate samtools

uniq_folder="/shared/home/bhandarim/6_analysis/UNIQ_READS"
count_folder="/shared/home/bhandarim/6_analysis/READ_COUNTS"

for number in 1795 1979 1754 1823 1913 2129 1932 2035 1792 462 2050 655 1925 529 1957 498 2264 1739 1826 585 668; do
    files="/shared/home/bhandarim/5_sorted/1_RNA/4_bamcmp/1_hisat/Sample_${number}_PDX"

    samtools view "$files/hisat_${number}.bamcmp.humanBetter.bam" | cut -f1 | sort | uniq > "$uniq_folder/BAMCMP_hisat_${number}.bamcmp.humanBetter.bam.txt"
    samtools view "$files/hisat_${number}.bamcmp.humanOnly.bam" | cut -f1 | sort | uniq > "$uniq_folder/BAMCMP_hisat_${number}.bamcmp.humanOnly.bam.txt"
    samtools view "$files/hisat_${number}.bamcmp.mouseBetter.bam" | cut -f1 | sort | uniq > "$uniq_folder/BAMCMP_hisat_${number}.bamcmp.mouseBetter.bam.txt"
    samtools view "$files/hisat_${number}.bamcmp.mouseOnly.bam" | cut -f1 | sort | uniq > "$uniq_folder/BAMCMP_hisat_${number}.bamcmp.mouseOnly.bam.txt"
    samtools view "$files/hisat_bamcmp_${number}.human_merged.bam" | cut -f1 | sort | uniq > "$uniq_folder/hisat_bamcmp_${number}.human_merged.bam.txt"
    for f in "$files"/*.bam; do
        # Extracting filename without path
        filename=$(basename "$f")
        # Counting and storing read counts
        count=$(samtools view -c -F 260 "$f")
        echo "$filename $count" >> "$count_folder/BAMCMP_HISAT_readcount.txt"
    done
done