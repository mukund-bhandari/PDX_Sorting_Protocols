library(readxl)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggrepel)
library(cowplot)
library(tidyr)
library(ComplexHeatmap)
library(gridExtra)

set.seed(8)
df <-read_xlsx(path= "Master_Table.xlsx", sheet=6, col_names = T, skip = 0)
df <- df %>%rename_with(~ paste0(., "_PDX"), matches("^\\d+$"))
df <- df %>%pivot_longer(cols = -c(Tools, Sequencing, Aligment, Aligner), names_to = "PDX", values_to = "HumanPercentage")
df<- df %>%rename("Protocols" =1)
##########################################################################################################
df <- df %>% mutate(Protocols= factor(Protocols,  
                                      levels = c("Xenome","Bbsplit", "Xengsort" ,
                                                 "Disambiguate_HISAT2" , "Disambiguate_STAR" ,  
                                                 "XenofilteR_HISAT2",    "XenofilteR_STAR"    , 
                                                 "bamcmp_HISAT2"     ,   "bamcmp_STAR",
                                                 "XenofilteR_bwamem2" , "Disambiguate_bwamem2",
                                                 "bamcmp_bwamem2" )))
# Create the box plot
df1<- df %>%filter(Sequencing == "RNA")

plot1 <- ggplot(df1, aes(x=Protocols, y=HumanPercentage)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size=5, alpha=0.5, color = "black")+
  labs(y = "Human_reads(%)", x = "Protocols") +
  scale_y_continuous(limits = c(75, 100), breaks = seq(75, 100, by = 5))+
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
  theme(legend.text=element_text(size=20, face ="bold"))


plot1

################################################################
##############################################################

# Create the box plot
df1<- df %>%filter(Sequencing == "WES")

plot2 <- ggplot(df1, aes(x=Protocols, y=HumanPercentage)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size=5, alpha=0.5, color = "black")+
  labs(y = "Human_reads(%)", x = "Protocols") +
  scale_y_continuous(limits = c(90, 100), breaks = seq(90, 100, by = 5))+
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
  theme(legend.text=element_text(size=20, face ="bold"))


plot2


################################################################
##############################################################

# Create the box plot
df1<- df %>%filter(Sequencing == "WGS")

plot3 <- ggplot(df1, aes(x=Protocols, y=HumanPercentage)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size=5, alpha=0.5, color = "black")+
  labs(y = "Human_reads(%)", x = "Protocols") +
  scale_y_continuous(limits = c(60, 100), breaks = seq(60, 100, by = 5))+
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
  theme(legend.text=element_text(size=20, face ="bold"))


plot3

# grid.arrange(plot2, plot3, plot4, ncol = 3)