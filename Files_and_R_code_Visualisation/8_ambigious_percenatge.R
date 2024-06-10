library(readxl)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(ggrepel)
library(cowplot)
library(tidyr)
library(ComplexHeatmap)



df <-read_xlsx(path= "Master_Table.xlsx", sheet=8, col_names = T, skip = 0)
df <- df %>%rename_with(~ paste0(., "_PDX"), matches("^\\d+$"))
df <- df %>%pivot_longer(cols = -c(Tools, Sequencing), names_to = "PDX", values_to = "AmbigiousPercentage")



df<- df %>%rename("Protocols" =1)
unique(df$Protocols)
##########################################################################################################
df <- df %>% mutate(Protocols= factor(Protocols,  
                                      levels = c("Xengsort" ,"Bbsplit", "Xenome",
                                                 "Disambiguate-Hisat2" , "Disambiguate-STAR" ,  
                                                 "Disambiguate-BWAMEM2"
                                      )))
# Create the box plot
df1<- df %>%filter(Sequencing == "RNA")

plot1 <- ggplot(df1, aes(x=Protocols, y=AmbigiousPercentage)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size=5, alpha=0.5, color = "black")+
  labs(y = "Ambigious_reads(%)", x = "Protocols") +
  scale_y_continuous(limits = c(0, 5), breaks = seq(0, 5, by = 1))+
  ggtitle("RNA")+
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

df <- df %>% mutate(Protocols= factor(Protocols,  
                                      levels = c("Xengsort" ,"Bbsplit", "Xenome",
                                                 "Disambiguate-Hisat2" , "Disambiguate-STAR" ,  
                                                 "Disambiguate-BWAMEM2"
                                      )))
# Create the box plot
df1<- df %>%filter(Sequencing == "WES")

plot2 <- ggplot(df1, aes(x=Protocols, y=AmbigiousPercentage)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size=5, alpha=0.5, color = "black")+
  labs(y = "Ambigious_reads(%)", x = "Protocols") +
  scale_y_continuous(limits = c(0, 5), breaks = seq(0, 5, by = 1))+
  ggtitle("WES")+
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

df <- df %>% mutate(Protocols= factor(Protocols,  
                                      levels = c("Xengsort" ,"Bbsplit", "Xenome",
                                                 "Disambiguate-Hisat2" , "Disambiguate-STAR" ,  
                                                 "Disambiguate-BWAMEM2"
                                      )))
# Create the box plot
df1<- df %>%filter(Sequencing == "WGS")

plot3 <- ggplot(df1, aes(x=Protocols, y=AmbigiousPercentage)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(size=5, alpha=0.5, color = "black")+
  labs(y = "Ambigious_reads(%)", x = "Protocols") +
  scale_y_continuous(limits = c(0, 5), breaks = seq(0, 5, by = 1))+
  ggtitle("WGS")+
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

grid.arrange( plot1,plot2, plot3, ncol = 3)