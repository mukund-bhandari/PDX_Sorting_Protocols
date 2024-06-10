############################################################################################################## 
################################################  5. Bamcmp-hisat2 ################################################ 
############################################################################################################## 

#!/bin/bash
#SBATCH --job-name hisat-bamcmp-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 0-5:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


transit_files=/shared/home/bhandarim/transit_files/Sample_1739_PDX
sorted_files=/shared/home/bhandarim/5_sorted/1_RNA/4_bamcmp/1_hisat/Sample_1739_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bamcmp
bamcmp -n -t 16 \
   -1 $transit_files/bam/"human_hisat2_sorted_1739.bam"  \
   -2 $transit_files/bam/"mouse_hisat2_sorted_1739.bam" \
   -a $sorted_files/hisat_1739.bamcmp.humanOnly.bam \
   -A $sorted_files/hisat_1739.bamcmp.humanBetter.bam \
   -b $sorted_files/hisat_1739.bamcmp.mouseOnly.bam \
   -B $sorted_files/hisat_1739.bamcmp.mouseBetter.bam \
   -s match

conda deactivate