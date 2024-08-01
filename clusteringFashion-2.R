library(tidyverse)
library(ggplot2)
library(kableExtra)
library(factoextra)
library(cluster)
library(tidyr)
library(dplyr)


df = read.csv("clean_data_new_columns.csv")

# filter out "unknown" dummy var (added in during previous cleaning/ column creation)
categorical_columns <- c("product_type", "style", "pattern", "material", "product_color", "tags")
df <-df %>%
  filter(across(all_of(categorical_columns), ~ . != "unknown"))


### HEIRARCHICAL CLUSTERING ###

selected_columns <- df %>%
  select(product_type, style, pattern, material, product_color, tags, retail_price, rating)

cleaned_df <- selected_columns %>%
  filter(across(everything(), ~ . != "unknown"))

# function to convert categorical columns to numeric and create mappings
convert_to_numeric_with_mapping <- function(df, column) {
  factor_col <- factor(df[[column]])
  df[[column]] <- as.numeric(factor_col)
  mapping <- data.frame(
    Original = levels(factor_col),
    Numeric = unique(df[[column]])
  )
  return(list(df = df, mapping = mapping))
}

conversion_results <- lapply(c("product_type", "style", "pattern", "material", "product_color", "tags"), 
                             function(col) convert_to_numeric_with_mapping(cleaned_df, col))

# extract numeric data and combine 
numeric_dfs <- lapply(conversion_results, function(res) res$df %>% select(all_of(names(res$mapping$Original))))
cleaned_df_numeric <- bind_cols(numeric_dfs) %>%
  bind_cols(cleaned_df %>% select(rating))

for (result in conversion_results) {
  print(result$mapping)
}
str(cleaned_df_numeric)

# scaling
scaled_data <- scale(cleaned_df_numeric %>% select(-rating))

# add back in rating data to scaled df
scaled_df <- as.data.frame(scaled_data)
scaled_df$rating <- cleaned_df_numeric$rating

#distance_matrix <- dist(scaled_df)
# heirarchical clustering
distances = round(dist(scaled_df,method = "euclidean"),2)
distances
clust = hclust(distances, method = "ward.D2")
plot(clust)

#hc <- hclust(distance_matrix, method = "ward.D2")

# dendrogram plot 
fviz_dend(clust, k = 4,  
          rect = TRUE, 
          rect_fill = TRUE, 
          rect_border = "jco",
          main = "Hierarchical Clustering Dendrogram")

clusters <- cutree(clust, k = 4)

# add new clusters to original df
df$cluster <- as.factor(clusters)

numeric_columns <- c("retail_price")
categorical_columns <- c("product_type", "style", "pattern", "material", "product_color", "tags")

# compute means for numeric columns
numeric_summary <- df %>%
  group_by(cluster) %>%
  summarise(across(all_of(numeric_columns), ~ mean(.x, na.rm = TRUE), .names = "mean_{.col}"))

# compute modes for categorical columns
mode_function <- function(x) {
  uniq_x <- unique(x)
  uniq_x[which.max(tabulate(match(x, uniq_x)))]
}

categorical_summary <- df %>%
  group_by(cluster) %>%
  summarise(across(all_of(categorical_columns), mode_function, .names = "mode_{.col}"))

# combine both summaries
cluster_summary <- left_join(numeric_summary, categorical_summary, by = "cluster")
print(cluster_summary)

# sil plot
silhouette_scores <- silhouette(clusters, dist(scaled_df))
plot(silhouette_scores)


numeric_summary_long <- numeric_summary %>%
  pivot_longer(cols = -cluster, names_to = "variable", values_to = "value") %>%
  mutate(value = as.character(value), type = "Numeric")

categorical_summary_long <- categorical_summary %>%
  pivot_longer(cols = -cluster, names_to = "variable", values_to = "value") %>%
  mutate(value = as.character(value), type = "Categorical")
combined_summary_long <- bind_rows(numeric_summary_long, categorical_summary_long)


# visualise distribution of key characteristics (average price,common product type) for each cluster.
ggplot(numeric_summary_long, aes(x = cluster, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Numeric Summary of Clusters")

ggplot(categorical_summary_long, aes(x = cluster, fill = value)) +
  geom_bar(position = "fill") +
  labs(title = "Categorical Summary of Clusters")


######



### RATINGS BASED CLUSTER ANALYSIS ###

cleaned_df <- df %>%
  filter(across(c(product_type, style, pattern, material, product_color, tags), ~ . != "unknown"))

# assign clusters based on ratings (for ratings 1 to 5)
cleaned_df$cluster <- as.factor(cleaned_df$rating)

numeric_columns <- c("retail_price")
categorical_columns <- c("product_type", "style", "pattern", "material", "product_color", "tags")

# compute means for numeric columns
numeric_summary <- cleaned_df %>%
  group_by(cluster) %>%
  summarise(across(all_of(numeric_columns), ~ mean(.x, na.rm = TRUE), .names = "mean_{.col}"))

# compute mode (most common value) for categorical columns
mode_function <- function(x) {
  uniq_x <- unique(x)
  uniq_x[which.max(tabulate(match(x, uniq_x)))]
}

categorical_summary <- cleaned_df %>%
  group_by(cluster) %>%
  summarise(across(all_of(categorical_columns), mode_function, .names = "mode_{.col}"))

cluster_summary <- left_join(numeric_summary, categorical_summary, by = "cluster")

print(cluster_summary)

style_distribution <- cleaned_df %>%
  count(cluster, style) %>%
  group_by(cluster) %>%
  mutate(prop = n / sum(n))

# pie chart of style distribution by cluster
ggplot(style_distribution, aes(x = "", y = prop, fill = style)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  facet_wrap(~cluster) +
  theme_void() +
  labs(title = "Style Distribution by Cluster",
       fill = "Style")


######