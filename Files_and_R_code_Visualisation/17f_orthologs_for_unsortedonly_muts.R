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

####### mutation info #######
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


############# which genes are mostly affected unsorted mutations occurs ###########
####### unsorted only mutations in #########
genes <- df %>% 
  filter(Func.refGene == "exonic") %>%
  group_by(UNIQMUT) %>%
  filter(all(Tool == "unsorted" & n_distinct(Tool) == 1))

df1 <- genes %>%
  group_by(Gene.refGene, Sample) %>%
  mutate(Gene_Uniq = paste0("Gene_Uniq", cur_group_id())) %>%
  ungroup() %>%
  dplyr::select(Gene_Uniq, 3, 4,10) %>%
  distinct(Gene_Uniq, .keep_all = TRUE)


df1 <- df1  %>%
  rename ("Human_Gene" =4)


########### read biomart genes #############
df2 <- read.table("mouse_homology.txt", sep = "\t", header = TRUE)
df2<- df2 %>% rename ("Human_Gene" =2) %>% distinct(Human_Gene, .keep_all = TRUE)



####### left join ######
data<- left_join(df1, df2, by ="Human_Gene")
############### analysis ###############
data <- data %>% select(1, 2,3, 4, 7:13 )

data <- data %>% 
  mutate(Ortholog = case_when( is.na(Mouse.gene.name) | Mouse.gene.name == "" ~ "No",  
                               TRUE ~ "Yes"))
#######
data1 <- data %>% select(1,2,12)
data1<- data1 %>% group_by(Sample,Ortholog ) %>%summarise(count = n())
##############
data1 <- data1 %>%group_by(Sample) %>%
  mutate(Percentage = count/sum(count))


# Plot using ggplot2
ggplot(data1, aes(x = Sample, y = Percentage, fill = Ortholog)) +
  geom_bar(stat = "identity", position = "stack", width = 0.7) +
  labs(x = "Sample", y = "Proportion", fill = "Mouse Ortholog") +
  scale_fill_manual(values = c("#F8766D", "#00BFC4"), labels = c("No", "Yes")) +  # Specify colors
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +  # Rotate x-axis labels for better readability
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, by = 0.10)) +
  theme_classic()+
  theme(axis.text.x = element_text(angle = 65, hjust = 1),
        panel.border = element_rect(color = "black", fill = NA, size = 1))+
  theme(legend.position = "bottom") +
  #guides(color=guide_legend(title="Methods"))+
  theme(
    # LABELS APPEARANCE
    plot.title = element_text(size=14, face= "bold", colour= "black" ),
    axis.title.x = element_text(size=18, face="bold", colour = "black"),    
    axis.title.y = element_text(size=18, face="bold", colour = "black"),    
    axis.text.x = element_text(size=16, face="bold", colour = "black"), 
    # axis.text.y = element_text(size=12,  colour = "black"), # unbold
    axis.text.y = element_text(size=16, face="bold", colour = "black"), # bold
    strip.text.x = element_text(size = 10, face="bold", colour = "black" ),
    strip.text.y = element_text(size = 10, face="bold", colour = "black"),
    axis.line.x = element_line(color="black", size = 0.3),
    axis.line.y = element_line(color="black", size = 0.3),
    panel.border = element_rect(colour = "black", fill=NA, size=0.9)
  )+
  theme(legend.text=element_text(size=10, face ="bold"))

