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
library(dplyr)

####### Fusion info #######
df<- read.xlsx("Master_Table.xlsx")

############ identify unique fusion  ###############
df <- df %>%
  group_by(Fusion_name) %>%
  mutate(UNIQFUS = paste0("unique", cur_group_id())) %>%
  ungroup() %>%
  dplyr::select(UNIQFUS, everything())

length(unique(df$UNIQFUS))
############# select only those values ###########
filtered_df <- df %>%
  distinct_at(vars(1:3), .keep_all = TRUE)





####### Fusion info #######
df <- filtered_df 

list=c(1795,1979,1754,1823,1913,2129,1932,2035,1792,462,2050,655,1925,529,1957,498,2264,1739,1826,585,668)

# Count the occurrences
df <- df %>% 
  group_by(Sample, Tool) %>%
  summarise(count = n())

df<- df %>% rename("Method"=2)

#######
mean_scores <- aggregate(count ~ Method, data = df, FUN = mean)
mean_scores <- mean_scores[order(mean_scores$count, decreasing = TRUE), ]  
df$Method <- factor(df$Method, levels = mean_scores$Method)
##########


df <- df %>% 
  mutate(Method = fct_relevel(Method, "Unsorted"))

# Create the box plot
plot1 <- ggplot(df, aes(x=Method, y=count)) +
  geom_boxplot() + 
  geom_point(aes(color = Sample))+
  #geom_jitter(position = position_jitter(width = 0.1), size = 0.2, alpha = 0.2) + 
  labs(y = "No of Fusion", x = "Protocols") +
  #theme(legend.position = "bottom") +
  theme_classic()+
  theme(axis.text.x = element_text(angle = 65, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 1))+
  scale_y_continuous(limits = c(0, 85), breaks = seq(0, 100, by = 10))+
  theme(legend.position = "") +
  theme(
    # LABELS APPEARANCE
    plot.title = element_text(size=14, face= "bold", colour= "black" ),
    axis.title.x = element_text(size=14, face="bold", colour = "black"),    
    axis.title.y = element_text(size=14, face="bold", colour = "black"),    
    axis.text.x = element_text(size=16, face="bold", colour = "black"), 
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
cv_data <- df %>%
  group_by(Method) %>%
  summarise(
    mean_count = mean(count), # Calculate mean
    std_dev = sd(count), # Calculate standard deviation
    cv = (std_dev / mean_count) * 100 # Calculate Coefficient of Variation as a percentage
  )

# Create the line graph
plot4<-ggplot(cv_data, aes(x = Method, y = cv, group=1)) +  
  geom_line() +
  labs(y = "CV", x = "") +
  theme_classic() +
  theme(axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),# Remove x-axis labels
        axis.line = element_line(color = "grey"),
        panel.border = element_rect(color = "grey", fill = NA, size = 1))+
  theme(legend.position = "top")


library(gridExtra)
grid.arrange(plot4, plot1, ncol = 1, heights = c(0.1,0.9))



################## sorted vs uncorted ########################

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
library(dplyr)
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
library(tidyverse)
library(ggpubr)
library(rstatix)


####### Fusion info #######
df <- filtered_df 
# Count the occurrences
df <- df %>% group_by(Sample, Tool) %>%summarise(count = n())
df<- df %>% rename("Method"=2)
df1 <- df %>% mutate(Protocols = case_when(Method == "Unsorted" ~ "Unsorted", TRUE~"Sorted"))
df1 <- df1 %>% mutate(Protocols = fct_relevel(Protocols, "Unsorted"))
df1 <- df1 %>% group_by(Sample, Protocols ) %>%summarise(Mean = mean(count)) %>%ungroup()

stat.test <- df1  %>% t_test(Mean ~ Protocols, paired = TRUE,detailed = TRUE) %>% add_significance()
stat.test



plot1<- ggplot(df1, aes(Protocols, Mean)) + 
  geom_boxplot()+ 
  #geom_line(aes(group = Sample), linetype=2, size=1.0)+ 
  #geom_point(aes(fill=Sample,group=Sample),size=5,shape=21)+
  geom_point(aes(fill=Sample,group=Sample),size=5,shape=21, position = position_jitter(width = 0.1), alpha = 0.5)+
  labs(y = "Number of Gene Fusion", x = "Protocols") +
  scale_y_continuous(limits = c(0, 75), breaks = seq(0, 70, by = 5))+
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
  stat_pvalue_manual(stat.test, tip.length = 0, y.position = c(75)) +
  labs(subtitle = get_test_label(stat.test, detailed= T))

plot1



################ corrrelation plots ########


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
df1 <- filtered_df 

# Get unique values from the "Fusion" and "Sample" columns
unique_fusion <- unique(df1$UNIQFUS)
unique_sample <- unique(df1$Sample)

length(unique_fusion)
# Replicate each unique sample value by the number of unique fusion values
sample_replicated <- rep(unique_sample, each = length(unique_fusion))

# Create df2 with unique values from the "Fusion" column
df2 <- data.frame(Fusion_Unique = rep(unique_fusion, length(unique_sample)))

# Add empty columns in df2 using unique values from "Tool" column
unique_tool <- unique(df1$Tool)
df2 <- cbind(df2, setNames(data.frame(matrix(NA, nrow = nrow(df2), ncol = length(unique_tool))), unique_tool))

# Add "Sample" column to df2
df2 <- cbind(df2, Sample = sample_replicated)

############### now fill 1 and 0 ###################


# Create a function to fill the empty columns in df2 based on criteria
fill_tool_columns <- function(df1, df2) {
  for (i in 1:nrow(df2)) {
    fusion_value <- df2$Fusion_Unique[i]
    for (tool in colnames(df2)[2:(ncol(df2) - 1)]) {
      sample_value <- df2$Sample[i]
      # Check if the combination of tool, fusion, and sample exists in df1
      if (any(df1$Tool == tool & df1$UNIQFUS == fusion_value & df1$Sample == sample_value)) {
        df2[i, tool] <- "1"  # If present, fill 1
      } else {
        df2[i, tool] <- "0"  # If absent, fill 0
      }
    }
  }
  return(df2)
}

# Fill the empty columns in df2
df_matrix <- fill_tool_columns(df1, df2)

###reorder###
df_matrixx <- df_matrix %>%
  dplyr::select (10,
                 2, 5, 9, 
                 3,4, 
                 8,11,
                 6,7)


library(proxy)
dfff<- proxy::dist(df_matrixx, by_rows = T, method = "Jaccard")
similarity <- 1-as.matrix(dfff)  

similarity<- similarity %>%
  as.matrix()      

##########
# Assuming correlation_matrix contains your correlation matrix
library(gplots)
# Plot heatmap
heatmap.2(similarity,
          Rowv = NA, Colv = NA,  # Don't display row and column dendrograms
          col = colorRampPalette(c("blue", "white", "red"))(100),  # Define color palette
          scale = "none",  # Don't scale the values
          main = "Pairwise Correlation between different methods",  # Set main title
          xlab = "Methods", ylab = "Methods",  # Set axis labels
          trace = "none",  # Don't add trace lines
          key = TRUE, keysize = 0.5, key.title = NA,  # Add color key
          symkey = FALSE, density.info = "none",  # Adjust key appearance
          cexCol = 1, cexRow = 1,  # Adjust text size
          margins = c(10, 10),  # Adjust margins
          cellnote = round(similarity, 3),  # Add correlation values
          notecol = "black",  # Set color of correlation values
          notecex = 0.8  # Adjust size of correlation values
)




