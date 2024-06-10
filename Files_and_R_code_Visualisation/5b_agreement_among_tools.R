library(readxl)
library(ggplot2)
library(Hmisc)
library(tidyverse)
library(viridis)
library(ggplot2)
library(dplyr)
library(readxl)
library(ggprism)
library(tidyr)
library(ComplexHeatmap)
library(gridExtra)
library(rstatix)
library(ggpubr)


df<-read_xlsx(path= "Master_Table.xlsx", sheet=14)



df$Sample <- paste0(df$Sample, "_PDX")
df$Tools <- as.factor(df$Tool_combination)
df$Genome <- as.factor(df$Genome)

df$Sample<- factor(df$Sample,  levels= c("1979_PDX", "655_PDX","462_PDX", "668_PDX","1932_PDX", 
                                         "2050_PDX","1792_PDX","2035_PDX",
                                         "529_PDX","498_PDX", "585_PDX","1754_PDX", "1957_PDX", 
                                         "1795_PDX","1823_PDX","2129_PDX",
                                         "2264_PDX","1925_PDX","1913_PDX","1739_PDX", "1826_PDX"))

###################### all in 1 ###############
plot1 <- ggplot(df, aes(Sample, Percentage, color=Tool_combination))+
  geom_point(size = 4)+
  facet_wrap("Genome")+
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust= 1))+
  xlab("PDX Sample") + ylab("Percentage of unique read ID identified as human")+
  scale_y_continuous(breaks = c(0,5,10,85, 90, 95, 100))+
  theme(axis.line = element_line(colour = "black"))+
  theme(axis.text.x = element_text(angle = 75, vjust = 1, hjust= 1, size = 12, face = "bold"),  # Adjust size and face
        axis.text.y = element_text(size = 12, face = "bold"),  # Adjust size and face
        axis.title = element_text(size = 14, face = "bold"))




###################### all tools ############

df1 <- df %>%
  mutate (Methods = case_when(Genome == "RNA" & Tool_combination == "In_9_tools" ~ "All_methods",
                              Genome == "WES" & Tool_combination == "In_6_tools" ~ "All_methods",
                              Genome == "WGS" & Tool_combination == "In_6_tools" ~ "All_methods"))

df1<- df1 %>%
  filter (Methods == "All_methods")

###################### plot 2 ############
plot2 <- ggplot(df1, aes(Sample, Percentage))+
  geom_point(size = 3, aes(color = Genome))+
  geom_boxplot()+
  theme_classic() +
  theme(axis.text.x = element_text(angle = 75, vjust = 1, hjust= 1))+
  xlab("PDX Sample") + ylab("Percentage of sorted human reads confimred in all tools")+
  scale_y_continuous(breaks = c(0,5,10,85, 90, 95, 100))+
  theme(axis.line = element_line(colour = "black"))+
  theme(axis.text.x = element_text(angle = 75, vjust = 1, hjust= 1, size = 12, face = "bold"),  # Adjust size and face
        axis.text.y = element_text(size = 12, face = "bold"),  # Adjust size and face
        axis.title = element_text(size = 14, face = "bold"))



###################### plot 3 ############
df1$Genome <- factor(df1$Genome, 
                     levels = c("WES", "WGS", "RNA"))

plot3 <- ggplot(df1, aes(Genome, Percentage))+
  geom_point(size = 3, aes(fill = Sample, color= Sample))+
  geom_boxplot()+
  theme_classic() +
  theme(axis.text.x = element_text(angle = 75, vjust = 1, hjust= 1))+
  xlab("PDX Sample") + ylab("Percentage of sorted human reads confimred in all tools")+
  #scale_y_continuous(breaks = c(0,5,10,85, 90, 95, 100))+
  scale_y_continuous(limits = c(80, 100), breaks = seq(80, 100, by = 5))+
  theme(axis.line = element_line(colour = "black"))






############## bigger and bolder ############
library(ggplot2)


df1$Genome <- factor(df1$Genome, 
                     levels = c("WES", "WGS", "RNA"))

plot3 <- ggplot(df1, aes(Genome, Percentage))+
  #geom_point(size = 5, aes(fill = Sample, color= Sample))+
  #geom_boxplot()+
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size=5, alpha=0.8, color = "black")+
  theme_classic() +
  ggprism::theme_prism(border=T)+
  theme(axis.text.x = element_text(angle = 75, vjust = 1, hjust= 1, size = 12, face = "bold"),  # Adjust size and face
        axis.text.y = element_text(size = 12, face = "bold"),  # Adjust size and face
        axis.title = element_text(size = 14, face = "bold")) +  # Adjust size and face for axis titles
  xlab("PDX Sample") + ylab("Percentage of sorted human reads confimred in all tools")+
  scale_y_continuous(limits = c(80, 100), breaks = seq(80, 100, by = 5))+
  theme(axis.line = element_line(colour = "black"))+
  theme(axis.text.x = element_text(size=15),axis.title=element_text(size=18,face="bold"),
        axis.text.y = element_text(size=15))

plot3











############## with stat ############################
library(ggplot2)


df1$Genome <- factor(df1$Genome, 
                     levels = c("WES", "WGS", "RNA"))


res.aov <- df1 %>% anova_test(Percentage ~ Genome)
res.aov

pwc <- df1 %>%
  pairwise_t_test(Percentage ~ Genome, p.adjust.method = "bonferroni", paired = T)
pwc



plot3 <- ggplot(df1, aes(Genome, Percentage))+
  #geom_point(size = 5, aes(fill = Sample, color= Sample))+
  #geom_boxplot()+
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size=5, alpha=0.8, color = "black")+
  theme_classic() +
  ggprism::theme_prism(border=T)+
  theme(axis.text.x = element_text(angle = 75, vjust = 1, hjust= 1, size = 12, face = "bold"),  # Adjust size and face
        axis.text.y = element_text(size = 12, face = "bold"),  # Adjust size and face
        axis.title = element_text(size = 14, face = "bold")) +  # Adjust size and face for axis titles
  xlab("Sequencing") + ylab("Percentage of sorted human reads confimred in all tools")+
  scale_y_continuous(limits = c(80, 100), breaks = seq(80, 100, by = 5))+
  theme(axis.line = element_line(colour = "black"))+
  theme(axis.text.x = element_text(size=15),axis.title=element_text(size=18,face="bold"),
        axis.text.y = element_text(size=15)) +
  stat_pvalue_manual(pwc, label = "p.adj", tip.length = 0, step.increase = 0.1,
                     y.position = c(99, 96 , 92)) +
  labs(
    subtitle = get_test_label(res.aov, detailed = F),
    caption = get_pwc_label(pwc)
  )


plot3



mean(df1$Percentage[df1$Genome == "WES"])