############################################################################################################## 
################################################  6. xenofilter-hisat2 ################################################ 
############################################################################################################## 


################################################## sorted hisat2 mapped files ######################################## 
#!/bin/bash
#SBATCH --job-name hisat-xenofilteR-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 0-5:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


hi_i=/shared/home/bhandarim/4_tools_index/hisat2

fq=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1739_PDX

transit_files=/shared/home/bhandarim/5_sorted/1_RNA/5_xenofilteR/1_hisat/Sample_1739_PDX

mkdir -p $transit_files/{sam,bam}

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate hisat2
hisat2  -k 5 --phred33  --no-mixed --no-discordant -p 16 -q -x $hi_i/grch38_snp_tran/genome_snp_tran -1 $fq/"1739_PDX_R1.fastq"  -2 $fq/"1739_PDX_R2.fastq"  -S $transit_files/sam/"human_hisat2_mapped_1739.sam"
hisat2  -k 5 --phred33  --no-mixed --no-discordant -p 16 -q -x $hi_i/grcm38_snp_tran/genome_snp_tran -1 $fq/"1739_PDX_R1.fastq"  -2 $fq/"1739_PDX_R2.fastq"  -S $transit_files/sam/"mouse_hisat2_mapped_1739.sam"
conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate samtools
samtools sort -@ 16 -o $transit_files/bam/"human_hisat2_sorted_1739.bam" $transit_files/sam/"human_hisat2_mapped_1739.sam"
rm -r $transit_files/sam/"human_hisat2_mapped_1739.sam"

samtools sort -@ 16 -o $transit_files/bam/"mouse_hisat2_sorted_1739.bam" $transit_files/sam/"mouse_hisat2_mapped_1739.sam"
rm -r $transit_files/sam/"mouse_hisat2_mapped_1739.sam"
conda deactivate
############################################################################################################## 


#!/bin/bash
#SBATCH --job-name hisat-xenofilter-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 1-23:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


scripts=/shared/home/bhandarim/1_scripts/5_xenofilteR/1_hisat
log=/shared/home/bhandarim/5_sorted/1_RNA/5_xenofilteR/3_log



source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate R
srun Rscript $scripts/1739.R > $log/1739.R.log
conda deactivate



#usage: run this R script using .sh script 

# args <- commandArgs(trailingOnly = TRUE)
# print(args)

#load library
library("XenofilteR")
#setting environment
bp.param <- SnowParam(workers = 16, type = "SOCK")


##define path and final output directory
path <- ("/shared/home/bhandarim/5_sorted/1_RNA/5_xenofilteR/1_hisat/Sample_1739_PDX/bam")
out_dir<- '/shared/home/bhandarim/5_sorted/1_RNA/5_xenofilteR/4_hisatXR_sorted/Sample_1739_PDX'

#make list of files
human= list.files(path= path, pattern = "human", full.names = TRUE)
mouse= list.files(path= path, pattern = "mouse", full.names = TRUE)

#make single matrix
sample.list <- as.data.frame(cbind (human, mouse))
#running XenofilteR
XenofilteR(sample.list, destination.folder = out_dir, bp.param = bp.param)