#Install packages
install.packages(c("svglite", "tidyverse","ggplot2","ggthemes"))

#Load librarires
library(tidyverse)
library(ggthemes)
library(ggplot2)
library(svglite)

#import and copy your file
df <- as.data.frame(dataframe_1)

# Replace all NA with 0
df[is.na(df)] <- 0

# Keep the original order of Pathway as factors
df$Pathway <- factor(df$Pathway, levels = df$Pathway)

# Keep the original order of Pathway_Figure_Order as factors
df$Pathway_Figure_Order <- factor(df$Pathway_Figure_Order, levels = df$Pathway_Figure_Order)

# Extract order of timepoints based on NES_ columns
timepoint_order <- gsub("NES_", "", names(df)[grepl("^NES_", names(df))])

# The grepl() function is used to search for patterns in a character array and 
# returns a logical array (TRUE or FALSE) indicating whether the pattern was found in each element of the array.

# Here, we are selecting the columns from df whose names start with "NES_". 
# The result will be a vector with only the column names that meet this criterion.

# Now, the gsub() function is used to replace substrings within a string. 
# The command gsub("NES_", "", ...) will remove the substring "NES_" 
# from each column name that was previously selected.

# Transform the dataframe to long format
# This is the pipe operator (%>%) from the dplyr package, 
# which allows you to chain multiple operations in a readable and 
# fluid way. It passes the dataframe df to the next function, 
# which in this case is pivot_longer().

df_long <- df %>%
  pivot_longer( #"transform" data from wide format (with multiple columns for different variables) to long format (where each variable is in a single column).
    cols = matches("^(NES|FDR)_"), # The cols parameter specifies which columns of the dataframe df will be "recast" to long format.
    names_to = c(".value", "Timepoint"), # defines how the new columns will be called after the transformation.
    names_pattern = "(NES|FDR)_(.+)" # allows you to specify a regular expression pattern to capture the different parts of column names.
  )

# Filter the data
df_long <- df_long %>%
  filter(FDR <= 0.05)

# Reapply reverse order of Paper_Figure_Order column to Paper_figure_Order
df_long$Paper_Figure_Order <- factor(df_long$Paper_Figure_Order, levels = rev(df$Paper_Figure_Order))

# Set factor order for X-axis (timepoints)
df_long$Timepoint <- factor(df_long$Timepoint, levels = timepoint_order)

# ggplot2 to create a dot plot with the pathways ordered on the y-axis (Paper_Figure_Order) 
# and only a fixed value on the x-axis (x = 1) — this causes the points to be vertically aligned, 
# separated only by time facets (Timepoint). 
# Each point represents an enriched pathway, with size proportional to significance (-log10(FDR)) 
# and color proportional to effect (NES).
ggplot(df_long, aes(x = 1, y = Paper_Figure_Order)) +
  # Type of graph, size, color and level of transparency (alpha)
  geom_point(aes(size = -log10(FDR), color = NES), alpha = 0.8) +  # Use -log10(FDR) for size
  #Define colors gradient
  scale_color_gradient2(low = "#05B1F0", mid = "#f7f7f7", high = "#FF0B0B", 
                        midpoint = 0, limits = c(-2.7, 3.2)) +
  # Define size of dots
  scale_size_continuous(range = c(3, 7)) +
  # separate panels
  facet_wrap(~ Timepoint, nrow = 1, strip.position = "top") +
  # Graph appearance for ggthemes
  theme_calc() +
  #labels
  labs(
    title = " ",
    x = " ",
    y = " ",
    size = "-log10(FDR)",
    color = "NES"
  ) +
  theme(strip.background = element_rect(fill = "white", color = "black"), #background white for face wrap
        panel.border = element_rect(color = "black"), #black border
        strip.placement = "outside", # repositions panel names
        panel.spacing = unit(0, "lines"), #space of panels
        axis.text = element_text(size = 14),  # Size of axis labels
        strip.text = element_text(size = 16, face = "bold"), #Size and bold panel text
        axis.ticks.x = element_blank()) #remove marks in axix X

#save
ggsave("bubble.svg", plot = last_plot(), width = 8, height = 9, bg = "transparent")

#Other save
ggsave(
  filename = "bubble.png",
  plot = last_plot(),
  width = 8,
  height = 9,
  dpi = 300,
  bg = "transparent",
  type = "cairo")
