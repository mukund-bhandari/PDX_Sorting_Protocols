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
library(dplyr)
library(stringr)
library(tidyr)
library(readr)
library(readxl)
library(survey)
library(reshape2)
library(ggplot2)
library(sandwich)
library(naniar)
library(smd)
library(ggprism)
library(ggstatsplot)
library(patchwork)
library(gganimate)
library(broom)
library(tidyverse)
library(multcomp)
library(openxlsx)
library(openxlsx)
library(dplyr)
library(tidyr)
library(ggplot2)
library(ggprism)
library(tidyverse)
library(ggpubr)
library(rstatix)

df1<- read.table("CIN_combined_cnr.seg", header = TRUE) 
df1$Sample <-paste0(df1$Sample, "_PDX")

df1<- df1 %>% 
  dplyr::select(1:6) %>%
  rename("log2seg" =6) %>%
  mutate(AMP_DEL = case_when(log2seg > 0.2 ~ "Amp",
                             log2seg < -0.2   ~ "Del",
                             TRUE ~ "Normal"
  )) %>%
  mutate(length = end- start)



df1 <- df1 %>% 
  group_by(Sample, Tool, chromosome ) %>%
  mutate(chr_seg_len = sum(length)) %>%
  ungroup 


df1 <- df1 %>% 
  group_by(Sample, Tool, chromosome, AMP_DEL ) %>%
  mutate(AMP_DEL_seg_len = sum(length)) %>%
  ungroup 


df1 <- df1 %>% distinct(Sample, Tool, chromosome,  AMP_DEL, AMP_DEL_seg_len, chr_seg_len)

df1 <- df1 %>% rename ("Protocol"=2) %>%
  filter(!AMP_DEL == "Normal")


df1 <- df1 %>% 
  group_by(Sample, Protocol, chromosome) %>%
  mutate(AMP_DEL_seg_len_total = sum(AMP_DEL_seg_len)) %>%
  ungroup 


df1 <- df1 %>% distinct(Sample, Protocol, chromosome, AMP_DEL_seg_len_total, chr_seg_len)


df1 <- df1 %>%filter(!str_detect(chromosome, "_alt"))


df1 <- df1 %>% 
  group_by(Sample, Protocol) %>%
  mutate(CIN = sum(AMP_DEL_seg_len_total)*100/sum(chr_seg_len)) %>%
  ungroup 


df1 <- df1 %>% distinct(Sample, Protocol, CIN)

# Calculate mean stromal score for each protocol
mean_scores <- aggregate(CIN ~ Protocol, data = df1, FUN = mean)
mean_scores <- mean_scores[order(mean_scores$CIN, decreasing = TRUE), ]  # Order by decreasing mean

# Reorder Protocols factor levels based on mean stromal score
df1$Protocol <- factor(df1$Protocol, levels = mean_scores$Protocol)
df1 <- df1 %>% mutate(Protocol = fct_relevel(Protocol, "unsorted"))

# Create the box plot
plot1 <- ggplot(df1, aes(x=Protocol, y=CIN)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_point( alpha = 0.8, size=4)+ #aes(color = Sample),
  #geom_point(aes(color = Sample),position = position_jitter(width = 0.2), alpha = 0.8)+
  #geom_jitter(position = position_jitter(width = 0.1), size = 0.2, alpha = 0.2) + 
  labs(y = "chromosome instability (CIN) index", x = "Protocols") +
  #theme(legend.position = "bottom") +
  scale_y_continuous(limits = c(0, 100), breaks = seq(0, 100, by = 10))+
  # scale_y_log10()+ annotation_logticks(sides = 'l')+
  #scale_y_log10(limits = c(5, 750), breaks = seq(5, 750, by = 95))+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 70, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 1))+
  theme(legend.position = "") +
  guides(color=guide_legend(title="Sample"))+
  theme(
    # LABELS APPEARANCE
    plot.title = element_text(size=14, face= "bold", colour= "black" ),
    axis.title.x = element_text(size=18, face="bold", colour = "black"),    
    axis.title.y = element_text(size=18, face="bold", colour = "black"),    
    axis.text.x = element_text(size=14, face="bold", colour = "black"), 
    # axis.text.y = element_text(size=12,  colour = "black"), # unbold
    axis.text.y = element_text(size=14, face="bold", colour = "black"), # bold
    strip.text.x = element_text(size = 10, face="bold", colour = "black" ),
    strip.text.y = element_text(size = 10, face="bold", colour = "black"),
    axis.line.x = element_line(color="black", size = 0.3),
    axis.line.y = element_line(color="black", size = 0.3),
    panel.border = element_rect(colour = "black", fill=NA, size=0.9)
  )+
  theme(legend.text=element_text(size=10, face ="bold"))

plot1 




# Calculate standard deviation and mean for each Sample
cv_data <- df1 %>%
  group_by(Protocol) %>%
  summarise(
    mean_CIN = mean(CIN), # Calculate mean
    std_dev = sd(CIN), # Calculate standard deviation
    cv = (std_dev / mean_CIN) * 100 # Calculate Coefficient of Variation as a percentage
  )

##############
# Calculate mean stromal score for each protocol
mean_scores <- aggregate(mean_CIN ~ Protocol, data = cv_data, FUN = mean)
mean_scores <- mean_scores[order(mean_scores$mean_CIN, decreasing = TRUE), ]  # Order by decreasing mean

# Reorder Protocols factor levels based on mean stromal score
cv_data$Protocol <- factor(cv_data$Protocol, levels = mean_scores$Protocol)
cv_data <- cv_data %>% mutate(Protocol = fct_relevel(Protocol, "unsorted"))

# Create the line graph
plot4<-ggplot(cv_data, aes(x = Protocol, y = cv, group=1)) +  
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
grid.arrange(plot4, plot1 , ncol = 1, heights = c(0.10,0.90))


