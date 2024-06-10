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
df1 <- df %>% 
  filter(Func.refGene == "exonic") %>%
  filter(!Tool == "unsorted")

# Get unique values from the "Fusion" and "Sample" columns
unique_mutation <- unique(df1$UNIQMUT)
unique_sample <- unique(df1$Sample)

length(unique_mutation)
# Replicate each unique sample value by the number of unique fusion values
sample_replicated <- rep(unique_sample, each = length(unique_mutation))

# Create df2 with unique values from the "Fusion" column
df2 <- data.frame(Mutation_Unique = rep(unique_mutation, length(unique_sample)))

# Add empty columns in df2 using unique values from "Tool" column
unique_tool <- unique(df1$Tool)
df2 <- cbind(df2, setNames(data.frame(matrix(NA, nrow = nrow(df2), ncol = length(unique_tool))), unique_tool))

# Add "Sample" column to df2
df2 <- cbind(df2, Sample = sample_replicated)

############### now fill 1 and 0 ###################
# Create a function to fill the empty columns in df2 based on criteria
fill_tool_columns <- function(df1, df2) {
  for (i in 1:nrow(df2)) {
    mutation_value <- df2$Mutation_Unique[i]
    for (tool in colnames(df2)[2:(ncol(df2) - 1)]) {
      sample_value <- df2$Sample[i]
      # Check if the combination of tool, fusion, and sample exists in df1
      if (any(df1$Tool == tool & df1$UNIQMUT == mutation_value & df1$Sample == sample_value)) {
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


df_matrixx <- df_matrix %>%
  dplyr::select (1,3,5,7,
                 2,4,6,
                 8)


df_matrixx <- df_matrixx [, -c(1,8)]  


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
          col= blues9,
          #col = colorRampPalette(c("blue", "white", "red"))(100),  # Define color palette
          scale = "none",  # Don't scale the values
          # main = "Jaccard similarity between methods using exonic mutations",  # Set main title
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
