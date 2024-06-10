library(readxl)
library(writexl)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(ggrepel)
library(ggpubr)
library(openxlsx)
library(tidyr)
library(ggprism)


#############################################
df <- read_xlsx(path= "Master_Table.xlsx", sheet=13)

df<- df %>%rename("Protocols" = 3)
unique(df$Protocols)

df <- df %>% mutate(Protocols = factor(Protocols,  
                                       levels = c(  
                                         "Xengsort","Xenome",  "Bbsplit", 
                                         "Disambiguate_star", "bamcmp_star","XenofilteR_star",
                                         "Disambiguate_hisat","bamcmp_hisat","XenofilteR_hisat")))


outlier_plot<- ggplot(df, aes(x=Protocols, y=Outlier_Genes)) +
  geom_boxplot(outlier.shape = NA) + # Suppress automatic outliers
  geom_jitter(position=position_jitter(width=0.2), size=2, alpha=0.5, aes(color= Sample)) + 
  labs(y="Number of protein coding outlier_genes(2SD)", x="Protocols") +
  #theme_minimal() +
  #theme(legend.position="right")+
  theme_prism(border = TRUE)+
  scale_y_continuous(breaks = seq(0,500, by =50))+
  theme(legend.position="bottom",
        axis.text.x = element_text(angle = 90, vjust = 0.5, size=12))+
  theme(legend.position = "none")

outlier_plot


######################

#df$Outlier_Genes <- as.numeric(df$Outlier_Genes)

# Calculate standard deviation and mean for each Sample
cv_data <- df %>%
  group_by(Protocols) %>%
  summarise(
    mean_count = mean(Outlier_Genes), # Calculate mean
    std_dev = sd(Outlier_Genes), # Calculate standard deviation
    cv = (std_dev / mean_count) * 100 # Calculate Coefficient of Variation as a percentage
  )



cv_data <- cv_data %>% mutate(Protocols = factor(Protocols,  
                                                 levels = c(  
                                                   "Xengsort","Xenome",  "Bbsplit", 
                                                   "Disambiguate_star", "bamcmp_star","XenofilteR_star",
                                                   "Disambiguate_hisat","bamcmp_hisat","XenofilteR_hisat")))

# Create the line graph
plot4<-ggplot(cv_data, aes(x = Protocols, y = cv, group=1)) +  
  geom_line() +
  labs(y = "CV", x = "") +
  theme_classic() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),# Remove x-axis labels
        axis.line = element_line(color = "grey"),
        panel.border = element_rect(color = "grey", fill = NA, size = 1))+
  theme(legend.position = "top")

###
library(gridExtra)
grid.arrange(plot4, outlier_plot, ncol = 1, heights = c(0.10,0.90))