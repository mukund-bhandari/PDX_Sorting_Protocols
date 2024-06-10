############################################################################################################## 
################################################  4. Disambiguate-hisat2 ################################################ 
############################################################################################################## 



########################  sort using Disambiguate-hisat2  ############################
#!/bin/bash
#SBATCH --job-name hisat-dis-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 0-5:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


hi_i=/shared/home/bhandarim/4_tools_index/hisat2

fq=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1739_PDX


transit_files=/shared/home/bhandarim/transit_files/Sample_1739_PDX
hisat_unmapped=/shared/home/bhandarim/5_sorted/0_unmapped_hisat/Sample_1739_PDX
sorted_files=/shared/home/bhandarim/5_sorted/1_RNA/2_disambiguate/1_hisat/Sample_1739_PDX

mkdir -p $transit_files/{sam,bam}

#gzip -d $fq/1739_PDX_R1.fastq.gz 
#gzip -d $fq/1739_PDX_R2.fastq.gz 

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate hisat2
hisat2  -k 5 --phred33  --no-mixed --no-discordant -p 16 -q -x $hi_i/grch38_snp_tran/genome_snp_tran -1 $fq/"1739_PDX_R1.fastq"  -2 $fq/"1739_PDX_R2.fastq"  -S $transit_files/sam/"human_hisat2_mapped_1739.sam" --un-conc-gz $hisat_unmapped/"human_hisat2_Unmapped_1739_%.sam"
hisat2  -k 5 --phred33  --no-mixed --no-discordant -p 16 -q -x $hi_i/grcm38_snp_tran/genome_snp_tran -1 $fq/"1739_PDX_R1.fastq"  -2 $fq/"1739_PDX_R2.fastq"  -S $transit_files/sam/"mouse_hisat2_mapped_1739.sam"
conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate samtools
samtools sort -@ 16 -n  -o $transit_files/bam/"human_hisat2_sorted_1739.bam" $transit_files/sam/"human_hisat2_mapped_1739.sam"
rm -r $transit_files/sam/"human_hisat2_mapped_1739.sam"

samtools sort -@ 16 -n  -o $transit_files/bam/"mouse_hisat2_sorted_1739.bam" $transit_files/sam/"mouse_hisat2_mapped_1739.sam"
rm -r $transit_files/sam/"mouse_hisat2_mapped_1739.sam"
conda deactivate


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate disambiguate
ngs_disambiguate -s hisat2_DIS_1739  -o $sorted_files -a hisat2 $transit_files/bam/"human_hisat2_sorted_1739.bam" $transit_files/bam/"mouse_hisat2_sorted_1739.bam"
conda deactivate


