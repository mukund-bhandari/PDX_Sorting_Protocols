
############################################################################################################## 
################################################  6. xenofilter-star ################################################ 
############################################################################################################## 



################################################## sorted star mapped files ######################################## 

#!/bin/bash
#SBATCH --job-name sorted-star-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 0-20:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu

transit_files=/shared/home/bhandarim/transit_files_star/Sample_1739_PDX
sorted=/shared/home/bhandarim/transit_files_star/1_coord_sorted/Sample_1739_PDX

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate samtools
samtools sort -@ 16  -o $sorted/"human_star_sorted_1739.bam" $transit_files/"human_star_1739_Aligned.out.bam"
samtools sort -@ 16  -o $sorted/"mouse_star_sorted_1739.bam" $transit_files/"mouse_star_1739_Aligned.out.bam"
conda deactivate
############################################################################################################## 



#!/bin/bash
#SBATCH --job-name star-xenofilter-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu



scripts=/shared/home/bhandarim/1_scripts/5_xenofilteR/2_star
log=/shared/home/bhandarim/5_sorted/1_RNA/5_xenofilteR/3_log


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate R
srun Rscript $scripts/1739.R > $log/star_1739.R.log
conda deactivate


#usage: run this R script using .sh script 

# args <- commandArgs(trailingOnly = TRUE)
# print(args)

#load library
library("XenofilteR")
#setting environment
bp.param <- SnowParam(workers = 16, type = "SOCK")


##define path and final output directory
path <- ("/shared/home/bhandarim/transit_files_star/1_coord_sorted/Sample_1739_PDX")
out_dir<- '/shared/home/bhandarim/5_sorted/1_RNA/5_xenofilteR/5_starXR_sorted/Sample_1739_PDX'

#make list of files
human= list.files(path= path, pattern = "human", full.names = TRUE)
mouse= list.files(path= path, pattern = "mouse", full.names = TRUE)

#make single matrix
sample.list <- as.data.frame(cbind (human, mouse))
#running XenofilteR
XenofilteR(sample.list, destination.folder = out_dir, bp.param = bp.param)