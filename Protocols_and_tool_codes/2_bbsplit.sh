############################################################################################################## 
################################################  2.bbsplit ################################################ 
############################################################################################################## 

########################  create bbsplit index ######################## 
#!/bin/bash
#SBATCH --job-name bbsplit-index
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 0-23:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


MouseRef=/shared/home/bhandarim/3_reference_genomes/genecode/GRCm39.primary_assembly.genome.fa
HumanRef=/shared/home/bhandarim/3_reference_genomes/genecode/GRCh38.primary_assembly.genome.fa

source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bbmap

bbsplit.sh \
        threads=16\
        path=/shared/home/bhandarim/4_tools_index/bbmap \
        build=1 \
        ref_Mouse=$MouseRef \
        ref_Human=$HumanRef

conda deactivate

########################  sort using bbsplit ############################
#!/bin/bash
#SBATCH --job-name bbsplit-1739
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 0-09:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu


fq1=/shared/home/bhandarim/2_PDX_files/1_RNA/Sample_1739_PDX
sorted_files=/shared/home/bhandarim/5_sorted/1_RNA/3_bbmap/Sample_1739_PDX


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate bbmap

bbsplit.sh \
        threads=16 \
        path=/shared/home/bhandarim/4_tools_index/bbmap \
        build=1 \
        in=$fq1/1739_PDX_R1.fastq \
        in2=$fq1/1739_PDX_R2.fastq \
        basename=$sorted_files/1739_%_RNAseq_#.fq \
        outu1=$sorted_files/1739.clean1.fq outu2=$sorted_files/1739.clean2.fq \
        ambig2=split \
        scafstats=$sorted_files/1739_read_mapped.txt \
        refstats=$sorted_files/1739_read_assigned.txt

conda deactivate