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

############# which genes are mostly affected unsorted mutations occurs ###########
####### unsorted only mutations in #########
###### Fusion info #######
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





genes <- df %>% 
  filter(Func.refGene == "exonic") %>%
  group_by(UNIQMUT) %>%
  filter(all(Tool == "unsorted" & n_distinct(Tool) == 1))

df1 <- genes %>%
  group_by(Gene.refGene, Sample) %>%
  mutate(Gene_Uniq = paste0("Gene_Uniq", cur_group_id())) %>%
  ungroup() %>%
  dplyr::select(Gene_Uniq, 3, 10) %>%
  distinct(Gene_Uniq, .keep_all = TRUE)

df1 <- df1 %>%
  rename ("Gene" =3)

# Get unique values from the "" and "Sample" columns
unique_gene <- unique(df1$Gene)
length(unique(df1$Gene))

unique_sample <- unique(df1$Sample)
length(unique(df1$Sample))

# Create df2 with unique values from the df1 columns
df2 <- data.frame(Gene = unique_gene)

# Add empty columns in df2 using unique values from "Sample" column
df2 <- cbind(df2, setNames(data.frame(matrix(NA, nrow = nrow(df2), ncol = length(unique_sample))), unique_sample))


###########
# Assuming df1 and df2 are your dataframes as described
fill_matrix <- matrix(0, nrow = nrow(df2), ncol = ncol(df2) - 1)
colnames(fill_matrix) <- colnames(df2)[-1]

# Iterate over each row in df2
for (i in 1:nrow(df2)) {
  # Get the gene from df2
  gene <- df2[i, "Gene"]
  
  # Iterate over each column name in df2 (excluding the first column "Gene")
  for (j in 2:ncol(df2)) {
    # Get the sample name
    sample_name <- colnames(df2)[j]
    
    # Check if the combination of gene and sample exists in df1
    if (any(df1$Gene == gene & df1$Sample == sample_name)) {
      # If yes, set the corresponding cell in fill_matrix to 1
      fill_matrix[i, j - 1] <- "1"
    }
  }
}

# Add the fill matrix to df2 (excluding the first column "Gene")
df2[, -1] <- fill_matrix

##############reorder###
df_matrixx <- df2 %>%
  dplyr::select (2:11)


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
          #col = colorRampPalette(c("blue", "white", "red"))(100),  # Define color palette
          col= blues9,
          scale = "none",  # Don't scale the values
          #main = "Jaccard similarity between samples using unique mutations only in unsorted cases",  # Set main title
          #xlab = "Methods", ylab = "Methods",  # Set axis labels
          trace = "none",  # Don't add trace lines
          key = TRUE, keysize = 0.5, key.title = NA,  # Add color key
          symkey = FALSE, density.info = "none",  # Adjust key appearance
          cexCol = 1, cexRow = 1,  # Adjust text size
          margins = c(10, 10),  # Adjust margins
          cellnote = round(similarity, 3),  # Add correlation values
          notecol = "black",  # Set color of correlation values
          notecex = 0.8  # Adjust size of correlation values
)
