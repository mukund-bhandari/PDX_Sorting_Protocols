#!/bin/bash
#SBATCH --job-name star-fusion-xengsort
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 0-01:59:59
#SBATCH --output /shared/home/bhandarim/0_TIMEERR/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu

fq=/shared/home/bhandarim/5_sorted/1_RNA/1_xengsort/1_Combined
fusion_out=/shared/home/bhandarim/C_fusion_analysis/1_xengsort/Sample_1739_PDX


module load /shared/apps2/modules/modulefiles/singularity/

singularity exec -e -B `pwd` -B /shared/home/bhandarim/3_reference_genomes/CTAT/GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir \
        /shared/home/bhandarim/star-fusion.v1.13.0.simg \
        STAR-Fusion \
        --left_fq $fq/1739_PDX_RNAseq.R1.fq \
        --right_fq $fq/1739_PDX_RNAseq.R2.fq \
        --genome_lib_dir /shared/home/bhandarim/3_reference_genomes/CTAT/GRCh38_gencode_v37_CTAT_lib_Mar012021.plug-n-play/ctat_genome_lib_build_dir \
        -O $fusion_out \
        --FusionInspector validate \
        --examine_coding_effect --CPU 16