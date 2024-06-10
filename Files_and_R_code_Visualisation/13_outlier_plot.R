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


data<- read_xlsx("Genes_in_tpm_all_samples.xlsx", sheet = 4) 

r=sum(data$Dis_hisat)/sum(data$NO_sorting)   #slope of the line
data$NO_sorting = log10(data$NO_sorting)
data$Dis_hisat = log10(data$Dis_hisat)
P3 = ggscatter(data, x="NO_sorting", y="Dis_hisat",
               size =3,color = "black", alpha=0.3,add="reg.line",
               add.params = list(color = "green",fill="grey",size=0.2), # Customize reg. line
               conf.int = TRUE )+
  ggpubr::stat_regline_equation()

P3

data_df<- data %>% mutate(line_cord = -0.061+ NO_sorting) %>% 
  mutate (residual = line_cord - Dis_hisat) 
deviation= sd(data_df$residual)

data_df<- data_df %>% 
  mutate (SD = case_when(residual >= (sd(residual)*2) ~ "genes(+SD_residual)", 
                         residual <= - (sd(residual)*2) ~ "genes(+SD_residual)", 
                         residual < (sd(residual)*2) & residual > -(sd(residual)*2) ~ "genes(remaining)"))

count2 = 0+2*deviation
count1= -count2


P4 = ggscatter(data_df, x="NO_sorting", y="Dis_hisat",size =1.5,color = "black",
               alpha=0.5, 
               add="reg.line",
               add.params = list(color = "cyan",fill="grey",size=0.4), # Customize reg. line
               cor.coef = TRUE, cor.coeff.args = list(method = "pearson", label.x = -5, label.sep = "\n"),
               conf.int = TRUE) + # Add confidence interval
  ggpubr::stat_regline_equation() +
  geom_abline(intercept=0,slope=r,col='red', linetype=1 )+
  geom_abline(intercept=count1,slope=r,col='blue',linetype=5)+
  geom_abline(intercept=count2,slope=r,col='blue',linetype=5)+
  #geom_text_repel(data = subset(data_df, SD ==  "genes(+SD_residual)"), aes(label = gene), size = 1 )+
  #geom_point(aes(color = SD)) + scale_color_manual(values = c("red", "grey"))
  #ggtitle("scatter plot of genes that are 2sd from mean residual (1795) ")+
  xlab("log10(TPM) No Protocol")+
  ylab("log10(TPM) Disambiguate-Hisat2 Protocol")+
  theme_prism(border=T)+
  theme(legend.position="bottom",
        axis.text.x = element_text(angle = 0, vjust = 1, size=12))

P4