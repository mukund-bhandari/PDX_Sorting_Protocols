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
df<- read.table("mutation_combined_file.txt", header = TRUE)


df <- df %>%
  group_by(Start, End, Ref, Alt) %>%
  mutate(UNIQMUT = paste0("unique", cur_group_id())) %>%
  ungroup() %>%
  dplyr::select(UNIQMUT, everything())

length(unique(df$UNIQMUT))

############# select only those values ###########
df <- df %>%
  distinct_at(vars(1:3), .keep_all = TRUE)
#### use this df for everything downstream ######
# Count the occurrences
df$Sample <-paste0(df$Sample, "_PDX")

df <- df %>%
  data.frame()


############################
df1 <- df %>% 
  filter(Func.refGene == "exonic") %>%
  group_by(Sample, Tool ) %>%
  summarise(count = n())

df1 <- df1 %>%
  mutate(Sample = factor(Sample,  
                         levels = c("1932_PDX",  "1754_PDX",  "2264_PDX","1795_PDX",
                                    "1826_PDX","2050_PDX", "1913_PDX",
                                    "1823_PDX", "1957_PDX", "1792_PDX")))
df1 <- df1 %>% 
  mutate(Tool = fct_relevel(Tool, "unsorted"))

# Load necessary libraries
library(ggplot2)
library(ggpubr)
# Create a box plot
p <- ggplot(df1, aes(x = Tool, y = count)) +
  geom_boxplot(outlier.shape = NA) +  # Create box plots
  theme_minimal() +  # Set plot theme
  geom_point(aes(color = Sample),position = position_jitter(width = 0.2), alpha = 0.8, size = 3)+
  #geom_jitter(position = position_jitter(width = 0.1), size = 0.2, alpha = 0.2) + 
  labs(y = "No of exonic mutations", x = "Protocol") +
  theme_classic()+
  theme(axis.text.x = element_text(angle = 65, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 1))+
  theme(legend.position = "none") +
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
  theme(legend.text=element_text(size=10, face ="bold"))+
  # Add pairwise comparison annotations
  stat_compare_means(
    comparisons = list(c("unsorted", "bamcmp"), c("unsorted", "bbmap"),c("unsorted", "bbmap"), c("unsorted", "disambiguate"), c("unsorted", "xengsort"), c("unsorted", "xenofilteR"),c("unsorted", "xenome")),
    label = "p.signif", #"p.format",
    method = "t.test",  # Use t-test for comparisons
    paired = FALSE,     # Perform independent t-tests
    hide.ns = TRUE, # Hide non-significant comparisons
    label.x.npc = "right",
    step.increase = 0.04,
    size = 3
  ) +
  scale_y_log10()


# Display the plot
print(p)



# Calculate standard deviation and mean for each Sample
cv_data <- df1 %>%
  group_by(Tool) %>%
  summarise(
    mean_count = mean(count), # Calculate mean
    std_dev = sd(count), # Calculate standard deviation
    cv = (std_dev / mean_count) * 100 # Calculate Coefficient of Variation as a percentage
  )

##############

cv_data  <- cv_data  %>% 
  mutate(Tool = fct_relevel(Tool, "unsorted"))

# Create the line graph
plot4<-ggplot(cv_data, aes(x = Tool, y = cv, group=1)) +  
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
grid.arrange(plot4, p, ncol = 1, heights = c(0.10,0.90))





mean(df1$count[df1$Tool == "unsorted"])
median(df1$count[df1$Tool == "unsorted"])



############ sorted vs unsorted ############################
############################ unsorted vs sorted #########################
######### with stat ########

df1 <- df %>% 
  filter(Func.refGene == "exonic") %>%
  group_by(Sample, Tool ) %>%
  summarise(count = n())

df1 <- df1 %>% mutate(Protocols = case_when(Tool == "unsorted" ~ "Unsorted",
                                            TRUE~"Sorted"))


df1 <- df1 %>% mutate(Protocols = fct_relevel(Protocols, "Sorted"))
df1 <- df1 %>% group_by(Sample, Protocols ) %>%summarise(Mean = mean(count))%>%ungroup()


stat.test <- df1  %>% t_test(Mean ~ Protocols, paired = TRUE,detailed = TRUE) %>% add_significance()
stat.test



plot1<- ggplot(df1, aes(Protocols, Mean)) + 
  geom_boxplot()+ 
  geom_line(aes(group = Sample), linetype=2, size=1.0)+ 
  geom_point(aes(fill=Sample,group=Sample),size=5,shape=21)+
  #geom_point(aes(fill=Sample,group=Sample),size=5,shape=21, position = position_jitter(width = 0.2), alpha = 0.8)+
  #geom_jitter(position = position_jitter(width = 0.5), size = 0.2, alpha = 0.5) + 
  labs(y = "Number of Exonic Mutations ", x = "Protocols") +
  #scale_y_log10(limits = c(20, 4200), breaks = seq(20, 4200, by = 480))+
  scale_y_log10()+
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
  stat_pvalue_manual(stat.test, tip.length = 0, y.position = c(4)) +
  labs(subtitle = get_test_label(stat.test, detailed= T))


plot1





mean(df1$Mean[df1$Protocols == "Sorted"])
median(df1$Mean[df1$Protocols == "Sorted"])


