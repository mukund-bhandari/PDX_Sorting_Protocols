library(openxlsx)
library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)
library(ggprism)


df<- read.xlsx("Master_Table.xlsx", sheet=2)
########################## time needed ############
# Filter out empty levels of TOOL for each Genome facet
df$TOOL <- factor(df$TOOL, levels = c("Xengsort", "Xenome", "Bbsplit", 
                                      "Disambiguate-HISAT", "Disambiguate-STAR",
                                      "XenofilteR-HISAT", "XenofilteR-STAR", 
                                      "BAMCMP-HISAT", "BAMCMP-STAR",
                                      "Disambiguate-BWAMEM", "XenofilteR-BWAMEM",
                                      "BAMCMP-BWAMEM"))

df$SAMPLE <- factor(df$SAMPLE, levels = c("PDX_1795","PDX_2035", "PDX_529", "PDX_668"))

df_filtered <- df %>%
  mutate(HOURS= (TIME/60)) 

# Create the box plot
plot2 <- ggplot(df_filtered, aes(x = TOOL, y = HOURS)) +
  geom_boxplot(outlier.shape = NA) + 
  geom_jitter(aes(color = SAMPLE), size =3, alpha=0.6)+
  #geom_jitter(position = position_jitter(width = 0.01), size = 1, alpha = 0.5) + 
  #geom_text(aes(label = SAMPLE), vjust = -1.5, hjust = 1, size = 1.5) +
  labs(y = "Time utilized (Hours)", x = "Protocols") +
  theme(legend.position = "right") +
  theme_prism(border= T) +
  theme(
    legend.position = "right",
    axis.text.x = element_text(angle = 89, vjust = 0.5)
  )+
  scale_y_continuous(limits = c(0, 10), breaks = seq(0, 10, by = 1))+
  facet_grid(~ Genome, scales = "free_x")+  # Use scales = "free_x" to display only non-empty TOOL levels
  guides(color=guide_legend(title="PDX Sample"))+
  theme(strip.text = element_text(size=18))+
  theme(axis.text.x = element_text(angle = 90, hjust = 1))+
  #theme(plot.title = element_text(hjust = 0.5, face = "italic", family = "serif"))+
  theme(axis.text.x = element_text(size=18),axis.title=element_text(size=18,face="bold"),
        axis.text.y = element_text(size=18),
  )+
  theme(legend.position = "none")

plot2



# Calculate mean of AmbiguousPercentage for rows where Sequencing is "RNA"
mean(df_filtered$HOURS[df_filtered$TOOL == "Xengsort"])
