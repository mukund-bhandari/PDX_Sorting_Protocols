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

df1<- read.table("all_segment_count.cns", header = TRUE) %>%
  dplyr::select(1, 2) 

df1$Sample <-paste0(df1$Sample, "_PDX")

df1 <- df1 %>% 
  group_by(Sample, Tool ) %>%
  summarise(count = n())
df1 <- df1 %>% rename ("Protocol"=2)


# Calculate mean stromal score for each protocol
mean_scores <- aggregate(count ~ Protocol, data = df1, FUN = mean)
mean_scores <- mean_scores[order(mean_scores$count, decreasing = TRUE), ]  # Order by decreasing mean

# Reorder Protocols factor levels based on mean stromal score
df1$Protocol <- factor(df1$Protocol, levels = mean_scores$Protocol)


# Create the box plot
plot1 <- ggplot(df1, aes(x=Protocol, y=count)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_point(aes(color = Sample),position = position_jitter(width = 0.2), alpha = 0.8)+
  #geom_jitter(position = position_jitter(width = 0.1), size = 0.2, alpha = 0.2) + 
  labs(y = "No of segemnts", x = "Protocols") +
  #theme(legend.position = "bottom") +
  #scale_y_continuous(limits = c(0, 4500), breaks = seq(0, 4500, by = 500))+
  # scale_y_log10()+ annotation_logticks(sides = 'l')+
  #scale_y_log10(limits = c(5, 750), breaks = seq(5, 750, by = 95))+
  scale_y_log10()+
  annotation_logticks(sides = 'l')+
  #theme_bw()+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 1))+
  theme(legend.position = "bottom") +
  guides(color=guide_legend(title="Sample"))+
  theme(
    # LABELS APPEARANCE
    plot.title = element_text(size=14, face= "bold", colour= "black" ),
    axis.title.x = element_text(size=14, face="bold", colour = "black"),    
    axis.title.y = element_text(size=14, face="bold", colour = "black"),    
    axis.text.x = element_text(size=12, face="bold", colour = "black"), 
    # axis.text.y = element_text(size=12,  colour = "black"), # unbold
    axis.text.y = element_text(size=12, face="bold", colour = "black"), # bold
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
    mean_count = mean(count), # Calculate mean
    std_dev = sd(count), # Calculate standard deviation
    cv = (std_dev / mean_count) * 100 # Calculate Coefficient of Variation as a percentage
  )

##############

# Reorder Protocols factor levels based on mean stromal score
cv_data$Protocol <- factor(cv_data$Protocol, levels = mean_scores$Protocol)

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










####################### sorted vs unsorted #####################
library(openxlsx)
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

####### Fusion info #######
df1<- read.table("all_segment_count.cns", header = TRUE) %>%
  dplyr::select(1, 2) 


df1 <- df1 %>% 
  group_by(Sample, Tool ) %>%
  summarise(count = n())

df1 <- df1 %>% mutate(Protocols = case_when(Tool == "unsorted" ~ "Unsorted",
                                            TRUE~"Sorted"))

df1$Sample <-paste0(df1$Sample, "_PDX")



df1 <- df1 %>% 
  group_by(Sample, Protocols ) %>%
  summarise(Mean = mean(count))


plot1<- ggplot(df1, aes(Protocols,Mean, fill=Protocols)) + 
  geom_boxplot()+ 
  geom_line(aes(group = Sample), linetype=2, size=1.0)+ 
  geom_point(aes(fill=Sample,group=Sample),size=5,shape=21)+
  labs(y = "Average Number of Segments", x = "Protocols") +
  scale_y_log10(limits = c(50, 750), breaks = seq(50, 750, by = 50))+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 0, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 1))+
  theme(legend.position = "bottom") +  theme(
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
  guides(color=guide_legend(title="Samples"))

plot1 







library(tidyverse)
library(ggpubr)
library(rstatix)


######### with stat ########
df1<- read.table("all_segment_count.cns", header = TRUE) %>%dplyr::select(1, 2) 
df1 <- df1 %>% group_by(Sample, Tool ) %>%summarise(count = n()) %>%ungroup()
df1 <- df1 %>% mutate(Protocols = case_when(Tool == "unsorted" ~ "Unsorted", TRUE~"Sorted"))
df1$Sample <-paste0(df1$Sample, "_PDX")
df1 <- df1 %>% group_by(Sample, Protocols ) %>%summarise(Mean = mean(count))%>%ungroup()


stat.test <- df1  %>% t_test(Mean ~ Protocols, paired = TRUE,detailed = TRUE) %>% add_significance()
stat.test



plot1<- ggplot(df1, aes(Protocols, Mean)) + 
  geom_boxplot()+ 
  geom_line(aes(group = Sample), linetype=2, size=1.0)+ 
  geom_point(aes(fill=Sample,group=Sample),size=5,shape=21)+
  labs(y = "Average Number of Segments", x = "Protocols") +
  scale_y_log10(limits = c(50, 750), breaks = seq(50, 750, by = 50))+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 0, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 1))+
  ggprism::theme_prism(border=F)+
  theme(legend.position = "bottom") +  
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





mean(df1$Mean[df1$Protocols == "Sorted"])
mean(df1$Mean[df1$Protocols == "Unsorted"])



