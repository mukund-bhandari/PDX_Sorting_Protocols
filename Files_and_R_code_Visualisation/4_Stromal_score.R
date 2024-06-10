library(dplyr)
library(stringr)
library(readr)
library(readxl)
library(survey)
library(reshape2)
library(ggplot2)
library(sandwich)
library(naniar)
library(smd)
library(ggstatsplot)
library(patchwork)
library(gganimate)
library(broom)
library(multcomp)
library(openxlsx)
library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)
library(ggprism)
library(dplyr)
library(tidyr)
library(tidyverse)
library(ggpubr)
library(rstatix)

######### with stat ########


df <- read.xlsx("Master_Table.xlsx", sheet=4)
df <- df %>% mutate(Method = fct_relevel(Method, "unsorted"))
df <- df %>% rename("Protocols"=3, "Sample"=1)
df1 <- df %>% group_by(Sample, Protocols ) %>%summarise(Mean = mean(stromalscore))%>%ungroup()

stat.test <- df1  %>% t_test(Mean ~ Protocols, paired = TRUE,detailed = TRUE) %>% add_significance()
stat.test

plot1<- ggplot(df1, aes(Protocols, Mean)) + 
  geom_violin(aes(colour = Protocols, fill = Protocols),trim = F)+
  geom_boxplot()+ 
  #geom_line(aes(group = Sample), linetype=2, size=1.0)+ 
  geom_point(aes(fill=Sample,group=Sample),size=5,shape=21, position = position_jitter(width = 0.2), alpha = 0.8)+
  #geom_jitter()+
  labs(y = "Stromal Score", x = "Protocols") +
  theme_classic()+
  theme(axis.text.x = element_text(angle = 0, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 1))+
  ggprism::theme_prism(border=F)+
  theme(legend.position = "none") +  
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
  theme(legend.text=element_text(size=10, face ="bold"))+
  theme(legend.title = element_text(size=20, face="bold"))+
  #guides(color=guide_legend(title="Samples"))+
  stat_pvalue_manual(stat.test, tip.length = 0, y.position = c(400)) +
  labs(subtitle = get_test_label(stat.test, detailed= T))


plot1


########### corr ###########
library(openxlsx)
library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)
library(ggprism)
library(openxlsx)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggprism)
library(stringr)

####### Fusion info #######
df1<- read.xlsx("Master_Table.xlsx", sheet=3) %>%
  filter (SCORE == "stromal") 


wide_df <- pivot_wider(data = df1, 
                       names_from = tool, 
                       values_from = value)


binary_data <- wide_df [, -c(1,2)]  
# Then, calculate pairwise correlations
correlation_matrix <- cor(binary_data, method='kendall')

##########
# Assuming correlation_matrix contains your correlation matrix
library(gplots)
# Plot heatmap
heatmap.2(correlation_matrix,
          Rowv = NA, Colv = NA,  # Don't display row and column dendrograms
          col = colorRampPalette(c("blue", "white", "red"))(100),  # Define color palette
          scale = "none",  # Don't scale the values
          main = "Pairwise Correlation of stromal score between different methods",  # Set main title
          xlab = "Methods", ylab = "Methods",  # Set axis labels
          trace = "none",  # Don't add trace lines
          key = TRUE, keysize = 0.5, key.title = NA,  # Add color key
          symkey = FALSE, density.info = "none",  # Adjust key appearance
          cexCol = 1, cexRow = 1,  # Adjust text size
          margins = c(10, 10),  # Adjust margins
          cellnote = round(correlation_matrix, 4),  # Add correlation values
          notecol = "black",  # Set color of correlation values
          notecex = 0.8  # Adjust size of correlation values
)
