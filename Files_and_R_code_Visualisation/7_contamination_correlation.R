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


df <-read_xlsx(path= "Master_Table.xlsx", sheet=7, col_names = T, skip = 0)
df<- data.frame(df) %>%
  select(1:4)

#########################################################


a<- ggscatter(df, x = "WES" , y = "WGS",  add = "reg.line", conf.int = TRUE,size=4, 
              cor.coef = TRUE, cor.method = "pearson", label = "PDX", repel = TRUE,
              xlab = "estimated human % (WES)", ylab = "estimated human % (WGS)", font.label = c(14, "plain"),cor.coef.size = 8) +
  theme_classic()+
  theme(axis.text.x = element_text(size=15),axis.title=element_text(size=18,face="bold"),
        axis.text.y = element_text(size=15))

a
#########################################################
df1<- df %>%
  filter(!PDX %in% c("1795", 
                     "1826"))

df_anno <- df %>% filter(PDX %in% c("1795", 
                                    "1826"))

b<- ggscatter(df1, x = "RNA" , y = "WES",  add = "reg.line", conf.int = TRUE, size=4, 
              cor.coef = TRUE, cor.method = "pearson", label = "PDX", repel = TRUE,
              xlab = "estimated human % (RNA)", ylab = "estimated human % (WES)", font.label = c(14, "plain"),cor.coef.size = 8) 
b<- b+ geom_point(data = df_anno, aes(x = RNA, y = WES), 
                  color = "red",size=4)+
  geom_text(data = df_anno, aes(x = RNA, y = WES, 
                                label = PDX), color = "red", vjust = -0.5, hjust = 0.5,size=5)+
  theme_classic()+
  theme(axis.text.x = element_text(size=15),axis.title=element_text(size=18,face="bold"),
        axis.text.y = element_text(size=15))

b             
#########################################################
df1<- df %>%
  filter(!PDX %in% c("1795", 
                     "1826"))
df_anno <- df %>% filter(PDX %in% c("1795",  
                                    "1826"))

c<- ggscatter(df1, x = "RNA" , y = "WGS",  add = "reg.line", conf.int = TRUE, size=4, 
              cor.coef = TRUE, cor.method = "pearson", label = "PDX", repel = TRUE,
              xlab = "estimated human % (RNA)", ylab = "estimated human % (WGS)",font.label = c(14, "plain"),cor.coef.size = 8)

c<- c +geom_point(data = df_anno, aes(x = RNA, y = WGS), 
                  color = "red",size=4)+
  geom_text(data = df_anno, aes(x = RNA, y = WGS, 
                                label = PDX), color = "red", vjust = -0.5, hjust = 0.5,size=5)+
  theme_classic()+
  theme(axis.text.x = element_text(size=15),axis.title=element_text(size=18,face="bold"),
        axis.text.y = element_text(size=15))
c

library(gridExtra)
grid.arrange(a, b, c, ncol = 3)

