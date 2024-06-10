library(readxl)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggrepel)
library(cowplot)
library(tidyr)
library(ComplexHeatmap)
library(gridExtra)
library(rstatix)
library(ggpubr)
####################### total contamination levels in RNAseq vs WES vs WGS ####################
set.seed(8)
df <-read_xlsx(path= "Master_Table.xlsx", sheet=7, col_names = T, skip = 0)
df<- df %>% select(1:4)

df$PDX <- paste0(df$PDX, "_PDX")
df <- df %>%pivot_longer(cols = -c(PDX), names_to = "Sequencing", values_to = "HumanPercentage")
df <- df %>% mutate(Sequencing= factor(Sequencing,  
                                       levels = c("WGS", "RNA", "WES")))


res.aov <- df %>% anova_test(HumanPercentage ~ Sequencing)
res.aov

pwc <- df %>%
  pairwise_t_test(HumanPercentage ~ Sequencing, p.adjust.method = "bonferroni", paired = T)
pwc



plot4 <- ggplot(df, aes(x=Sequencing, y=HumanPercentage)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size=5, alpha=0.5 )+ #aes(color = PDX)
  labs(y = "Average Human_reads(%) from all protocols", x = "Sequencing") +
  scale_y_continuous(limits = c(60, 110), breaks = seq(60, 100, by = 5))+
  ggprism::theme_prism(border=F)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 3))+
  theme(legend.position = "none") +
  stat_pvalue_manual(pwc, label = "p.adj", tip.length = 0, step.increase = 0.1, size=5,face ="bold",
                     y.position = c(99, 100 , 101)) +
  labs(
    subtitle = get_test_label(res.aov, detailed = F),
    caption = get_pwc_label(pwc)
  )


plot4






plot5<- plot4+
  ggprism::theme_prism(border=T)+
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 3))+
  theme(
    # LABELS APPEARANCE
    plot.title = element_text(size=20, face= "bold", colour= "black" ),
    axis.title.x = element_text(size=20, face="bold", colour = "black"),    
    axis.title.y = element_text(size=20, face="bold", colour = "black"),    
    axis.text.x = element_text(size=20, face="bold", colour = "black"), 
    # axis.text.y = element_text(size=12,  colour = "black"), # unbold
    axis.text.y = element_text(size=12, face="bold", colour = "black"), # bold
    strip.text.x = element_text(size = 10, face="bold", colour = "black" ),
    strip.text.y = element_text(size = 10, face="bold", colour = "black"),
    axis.line.x = element_line(color="black", size = 0.3),
    axis.line.y = element_line(color="black", size = 0.3),
    panel.border = element_rect(colour = "black", fill=NA, size=0.9)
  )+
  theme(legend.text=element_text(size=20, face ="bold"))+
  theme(legend.position = "none") 



plot5