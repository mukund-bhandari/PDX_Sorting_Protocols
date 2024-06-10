#!/bin/bash
#SBATCH --job-name CNV-retest
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 16
#SBATCH --partition=hpc
#SBATCH --time 3-23:59:59
#SBATCH --output /shared/home/bhandarim/ERROR/DNA/%j.out
#SBATCH --mail-user bhandarim@uthscsa.edu



CNV_REF=/shared/home/bhandarim/F_CNV_rerun/CNV_REF


TUMOR0=/shared/home/bhandarim/F_CNV_rerun/TUMOR/unsorted
TUMOR1=/shared/home/bhandarim/F_CNV_rerun/TUMOR/xengsort
TUMOR2=/shared/home/bhandarim/F_CNV_rerun/TUMOR/disambiguate
TUMOR3=/shared/home/bhandarim/F_CNV_rerun/TUMOR/bbmap
TUMOR4=/shared/home/bhandarim/F_CNV_rerun/TUMOR/bamcmp
TUMOR5=/shared/home/bhandarim/F_CNV_rerun/TUMOR/xenofilteR
TUMOR6=/shared/home/bhandarim/F_CNV_rerun/TUMOR/xenome

RESULT0=/shared/home/bhandarim/F_CNV_rerun/RESULT/unsorted
RESULT1=/shared/home/bhandarim/F_CNV_rerun/RESULT/xengsort
RESULT2=/shared/home/bhandarim/F_CNV_rerun/RESULT/disambiguate
RESULT3=/shared/home/bhandarim/F_CNV_rerun/RESULT/bbmap
RESULT4=/shared/home/bhandarim/F_CNV_rerun/RESULT/bamcmp
RESULT5=/shared/home/bhandarim/F_CNV_rerun/RESULT/xenofilteR
RESULT6=/shared/home/bhandarim/F_CNV_rerun/RESULT/xenome


source /shared/home/bhandarim/miniconda3/etc/profile.d/conda.sh;
conda activate cnvkit

cnvkit.py batch $TUMOR0/*bam -r $CNV_REF/my_ref -p 16 --scatter --diagram -d $RESULT0
cnvkit.py batch $TUMOR1/*bam -r $CNV_REF/my_ref -p 16 --scatter --diagram -d $RESULT1
cnvkit.py batch $TUMOR2/*bam -r $CNV_REF/my_ref -p 16 --scatter --diagram -d $RESULT2
cnvkit.py batch $TUMOR3/*bam -r $CNV_REF/my_ref -p 16 --scatter --diagram -d $RESULT3
cnvkit.py batch $TUMOR4/*bam -r $CNV_REF/my_ref -p 16 --scatter --diagram -d $RESULT4
cnvkit.py batch $TUMOR5/*bam -r $CNV_REF/my_ref -p 16 --scatter --diagram -d $RESULT5
cnvkit.py batch $TUMOR6/*bam -r $CNV_REF/my_ref -p 16 --scatter --diagram -d $RESULT6



namunas="1754 1792 1795 1823 1826 1913 1932 1957 2050 2264"

for i in $namunas;
do
cnvkit.py call $RESULT0/${i}_PDX_WES.dedupped.cnr -y -m clonal -o $RESULT0/${i}.call.cnr
cnvkit.py call $RESULT1/${i}_PDX_WES.dedupped.cnr -y -m clonal -o $RESULT1/${i}.call.cnr
cnvkit.py call $RESULT2/${i}_PDX_WES.dedupped.cnr -y -m clonal -o $RESULT2/${i}.call.cnr
cnvkit.py call $RESULT3/${i}_PDX_WES.dedupped.cnr -y -m clonal -o $RESULT3/${i}.call.cnr
cnvkit.py call $RESULT4/${i}_PDX_WES.dedupped.cnr -y -m clonal -o $RESULT4/${i}.call.cnr
cnvkit.py call $RESULT5/${i}_PDX_WES.dedupped.cnr -y -m clonal -o $RESULT5/${i}.call.cnr
cnvkit.py call $RESULT6/${i}_PDX_WES.dedupped.cnr -y -m clonal -o $RESULT6/${i}.call.cnr



############# to get segment file #####################
cnvkit.py segment $RESULT0/${i}_PDX_WES.dedupped.cnr -o $RESULT0/${i}_cnr.seg   -p 16
cnvkit.py segment $RESULT0/${i}.call.cnr -o $RESULT0/${i}_call.seg   -p 16

cnvkit.py segment $RESULT1/${i}_PDX_WES.dedupped.cnr -o $RESULT1/${i}_cnr.seg   -p 16
cnvkit.py segment $RESULT1/${i}.call.cnr -o $RESULT1/${i}_call.seg   -p 16

cnvkit.py segment $RESULT2/${i}_PDX_WES.dedupped.cnr -o $RESULT2/${i}_cnr.seg   -p 16
cnvkit.py segment $RESULT2/${i}.call.cnr -o $RESULT2/${i}_call.seg   -p 16

cnvkit.py segment $RESULT3/${i}_PDX_WES.dedupped.cnr -o $RESULT3/${i}_cnr.seg   -p 16
cnvkit.py segment $RESULT3/${i}.call.cnr -o $RESULT3/${i}_call.seg   -p 16

cnvkit.py segment $RESULT4/${i}_PDX_WES.dedupped.cnr -o $RESULT4/${i}_cnr.seg   -p 16
cnvkit.py segment $RESULT4/${i}.call.cnr -o $RESULT4/${i}_call.seg   -p 16

cnvkit.py segment $RESULT5/${i}_PDX_WES.dedupped.cnr -o $RESULT5/${i}_cnr.seg   -p 16
cnvkit.py segment $RESULT5/${i}.call.cnr -o $RESULT5/${i}_call.seg   -p 16

cnvkit.py segment $RESULT6/${i}_PDX_WES.dedupped.cnr -o $RESULT6/${i}_cnr.seg   -p 16
cnvkit.py segment $RESULT6/${i}.call.cnr -o $RESULT6/${i}_call.seg   -p 16


done

conda deactivate