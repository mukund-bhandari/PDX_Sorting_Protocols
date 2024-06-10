#!/bin/bash

namunas="1754 1792 1795 1823 1826 1913 1932 1957 2050 2264"

for i in $namunas;do


perl /shared/home/bhandarim/Tools/annovar/table_annovar.pl \
/shared/home/bhandarim/E_MUTECT/all_vcfs/xengsort/${i}.mutect.vcf \
/shared/home/bhandarim/Tools/annovar/humandb/ \
-buildver hg38 \
-out /shared/home/bhandarim/E_MUTECT_ANNO/xengsort/xengsort_${i}.anno \
-remove -protocol refGene,cytoBand,exac03,avsnp147,dbnsfp30a \
-operation gx,r,f,f,f \
-nastring . -vcfinput -polish \
-xref /shared/home/bhandarim/Tools/annovar/example/gene_xref.txt

done