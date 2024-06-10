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
library(tidyverse)
library(ggpubr)
library(rstatix)

####### mutation info #######
df1<- read.table("mutation_combined_file.txt", header = TRUE)

####### mutation info #######
df2<- read.table("AF_combined_file.txt", header=T)
df2<-df2 %>%
  rename("GL"=12, "PDX"=13) %>%
  dplyr::select(1, 2, 3,4, 12, 13) 


extract_AF <- function(pdx_value) {
  pdx_parts <- str_split(pdx_value, ":")[[1]]
  af_value <- as.numeric(pdx_parts[3])
  return(af_value)
}

df2 <- df2 %>%mutate(AF = sapply(PDX, extract_AF))
df2 <- df2 %>%mutate(Germline_AF = sapply(GL, extract_AF))

######## combine df1 and df2 #########
dff<- cbind(df1,df2)
dff<-dff%>%dplyr::select(-15, -16, -17, -18, -19, -20) 
dff <- dff %>% filter(Func.refGene == "exonic")

######### now plot ##############
dff <- dff %>%
  group_by(Start, End, Ref, Alt) %>%
  mutate(UNIQMUT = paste0("unique", cur_group_id())) %>%
  ungroup() %>%
  dplyr::select(UNIQMUT, everything())

length(unique(dff$UNIQMUT))

############# select only those values ###########
dff <- dff %>%distinct_at(vars(1:3), .keep_all = TRUE)
#### use this df for everything downstream ######
# Count the occurrences
dff$Sample <-paste0(dff$Sample, "_PDX")
dff <- dff %>%data.frame()
all_genes <- dff %>%dplyr::select(1,2,3,16)


########################
unosorted_only <- all_genes %>%
  group_by(UNIQMUT) %>%
  filter(all(Tool == "unsorted" & n_distinct(Tool) == 1))

unosorted_only <- unosorted_only %>% mutate(Protocol = "Unsorted")

sorted <- all_genes %>% filter(!Tool == "unsorted")
sorted <- sorted %>% mutate(Protocol = "sorted")

finaldf <- rbind(unosorted_only, sorted)

#############
finaldf <- finaldf %>%
  group_by(Sample, Protocol, UNIQMUT) %>%
  mutate(AF_mean = mean(AF)) %>%
  ungroup()

############
finaldf <- finaldf %>% distinct(UNIQMUT, Protocol, Sample,AF_mean)
finaldf <- finaldf %>% mutate(Protocol = fct_relevel(Protocol, "Unsorted"))


mean_scores <- aggregate(AF_mean ~ Sample, data = finaldf, FUN = mean)
mean_scores <- mean_scores[order(mean_scores$AF_mean, decreasing = F), ]  
finaldf$Sample <- factor(finaldf$Sample , levels = mean_scores$Sample)




# Create the box plot
plot1 <- ggplot(finaldf, aes(x=Sample, y=AF_mean, fill=Protocol)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_point(position = position_jitterdodge(), alpha=0.5, size=0.8)+
  labs(y = "VAF", x = "PDX") +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.1))+
  stat_compare_means(aes(group = Protocol), label = "p.signif", label.y = 1, size = 5)+
  theme_classic()+
  theme(axis.text.x = element_text(angle = 70, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 1))+
  theme(legend.position = "bottom") +
  guides(color=guide_legend(title="Protocol"))+
  theme(
    # LABELS APPEARANCE
    plot.title = element_text(size=14, face= "bold", colour= "black" ),
    axis.title.x = element_text(size=18, face="bold", colour = "black"),    
    axis.title.y = element_text(size=18, face="bold", colour = "black"),    
    axis.text.x = element_text(size=16, face="bold", colour = "black"), 
    axis.text.y = element_text(size=16, face="bold", colour = "black"), # bold
    strip.text.x = element_text(size = 10, face="bold", colour = "black" ),
    strip.text.y = element_text(size = 10, face="bold", colour = "black"),
    axis.line.x = element_line(color="black", size = 0.3),
    axis.line.y = element_line(color="black", size = 0.3),
    panel.border = element_rect(colour = "black", fill=NA, size=0.9)
  )+
  theme(legend.text=element_text(size=18, face ="bold"))

plot1 



