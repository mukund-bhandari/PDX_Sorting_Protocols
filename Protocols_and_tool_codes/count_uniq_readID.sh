#!/bin/bash
#SBATCH --job-name bbamp-count-uniq
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 3-23:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu



uniq_folder=/shared/home/bhandarim/6_analysis/UNIQ_READS
count_folder=/shared/home/bhandarim/6_analysis/READ_COUNTS

for number in 1795 1979 1754 1823 1913 2129 1932 2035 1792 462 2050 655 1925 529 1957 498 2264 1739 1826 585 668; do
    files="/shared/home/bhandarim/5_sorted/1_RNA/3_bbmap/Sample_${number}_PDX"

    awk 'NR%4==1 {print substr($1,2)}' "$files/${number}.clean1.fq" | sort -u > "$uniq_folder/bbmap_${number}.clean1.txt"
    awk 'NR%4==1 {print substr($1,2)}' "$files/${number}_Human_RNAseq_1.fq" | sort -u > "$uniq_folder/bbmap_${number}_Human_RNAseq_1.fq.txt"
    awk 'NR%4==1 {print substr($1,2)}' "$files/${number}_Mouse_RNAseq_1.fq" | sort -u > "$uniq_folder/bbmap_${number}_Mouse_RNAseq_1.fq.txt"
    awk 'NR%4==1 {print substr($1,2)}' "$files/AMBIGUOUS_${number}_Human_RNAseq_1.fq" | sort -u > "$uniq_folder/bbmap_AMBIGUOUS_${number}_Human_RNAseq_1.fq.txt"
    awk 'NR%4==1 {print substr($1,2)}' "$files/AMBIGUOUS_${number}_Mouse_RNAseq_1.fq" | sort -u > "$uniq_folder/bbmap_AMBIGUOUS_${number}_Mouse_RNAseq_1.fq.txt"


    for f in "$files"/*1.fq; do
        # Extracting filename without path
        filename=$(basename "$f")

        # Counting and storing read counts
        count=$(awk '{s++}END{print s/4}' "$f")
        echo "$filename $count" >> "$count_folder/bbmap_readcount.txt"
    done
done


