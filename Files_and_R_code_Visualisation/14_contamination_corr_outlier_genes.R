library(readxl)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggrepel)
library(cowplot)
library(tidyr)
library(ComplexHeatmap)
library(readxl)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggrepel)
library(cowplot)
library(tidyr)
library(ggpubr)

########### df #############
df<-read_xlsx(path= "Master_Table.xlsx", sheet=15)
############ red color outlier ###########

df2<- df %>%filter(!Sample %in% c("1795_PDX"))
df_anno <- df %>% filter(Sample %in% c("1795_PDX"))

a<- ggscatter(df2, y = "Average" , x = "Other",  size=2,
              add = "reg.line", conf.int = TRUE, 
              cor.coef = TRUE, cor.method = "pearson", 
              cor.coeff.args = list(method = "pearson", label.x = 20, 
                                    label.sep = "\n"
              ),
              label = "Sample", font.label = c(10, "bold", "black") , repel = TRUE,
              ylab = "Number of outlier genes in PDX", 
              xlab = "estimated non-human genome(mouse+ambigious)% in PDX(RNA-seq)",
              font.tickslab = c(14, "bold", "black"),
              font.legend = c(14, "bold", "black"),
              font.x = c(14, "bold", "black"),
              font.y = c(14, "bold", "black")) +
  ggprism::theme_prism(border=T)

a 

a<- a+ geom_point(data = df_anno, aes(y = Average, x = Other), 
                  color = "red")+
  geom_text(data = df_anno, aes(y = Average, x = Other, 
                                label = Sample), color = "red", vjust = -0.5, hjust = 0.5)


a



################################# ################################# 
################################# ################################# 
################################# corr mouse only ######################
df<-read_xlsx(path= "Master_Table.xlsx", sheet=15)
df2<- df %>%filter(!Sample %in% c("1795_PDX"))
df_anno <- df %>% filter(Sample %in% c("1795_PDX"))

a<- ggscatter(df2, y = "Average" , x = "Mouse_Percentage",  size=2,
              add = "reg.line", conf.int = TRUE, 
              cor.coef = TRUE, cor.method = "pearson", 
              cor.coeff.args = list(method = "pearson", label.x = 20, 
                                    label.sep = "\n"
              ),
              label = "Sample", font.label = c(10, "bold", "black") , repel = TRUE,
              ylab = "Number of outlier genes in PDX", 
              xlab = "estimated average mouse reads% in PDX(RNA-seq)",
              font.tickslab = c(14, "bold", "black"),
              font.legend = c(18, "bold", "black"),
              font.x = c(14, "bold", "black"),
              font.y = c(14, "bold", "black")) +
  ggprism::theme_prism(border=T)

a 

a<- a+ geom_point(data = df_anno, aes(y = Average, x = Mouse_Percentage), 
                  color = "red")+
  geom_text(data = df_anno, aes(y = Average, x = Mouse_Percentage, 
                                label = Sample), color = "red", vjust = -0.5, hjust = 0.5)


a

