library(readxl)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggrepel)
library(readxl)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggrepel)
library(ggpubr)
library(ggpubr)
library(circlize)
library(ComplexHeatmap)

# Read data tables
df <- readxl::read_xlsx(path= "Master_Table.xlsx", sheet=11)
df$Sample <-paste0(df$Sample, "_PDX")


ha1 = HeatmapAnnotation(df = df %>% select(- Sample),
                        col = list(Gender = c("Male" = "#00BFC4", "Female" =  "maroon"),    
                                   Age = colorRamp2(c(0, 20), c("white", "red")),
                                   Race = c("AA" = "#00BFC4", "White" = "#00A9FF", "Other"= "cadetblue4" ,    
                                            "Black or AA" =  "darkslategrey", "NaN" = "aquamarine4"),
                                   Primary_Metastatic = c("primary"= "#00BFC4", "metastatic" ="#F8766D"),   
                                   Ethnicity = c("Hispanic" = "lightslateblue" , "Non-Hispanic" = "coral1",
                                                 "Hispanic or Latino" = "mediumorchid",
                                                 "Not Hispanic or Latino"="indianred3"),
                                   Tumor= c("Clear Cell Sarcoma" = "blueviolet", "Germ Cell Tumor"  = "brown",   
                                            "Hepatoblastoma" = "chocolate2", "Medulloblastoma" = "#00FF92FF",       
                                            "Neuroblastoma"  = "darkgreen", "Osteosarcoma" = "#4900FFFF",
                                            "Wilms Tumor" = "cyan3", "Other Tumor" = "bisque4")))



zero_row_mat = matrix(nrow = 0, ncol = 21)
colnames(zero_row_mat) = df$Sample
set.seed(123)
h1= Heatmap(zero_row_mat, top_annotation = ha1, height = nrow(zero_row_mat)*unit(20, "mm"), 
            heatmap_legend_param = list (df$Tumor,df$Primary_Metastatic, df$Age ,df$Race, df$Ethnicity, df$Gender ))
draw(h1, annotation_legend_side = "bottom")