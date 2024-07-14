# Loading necessary libraries
library(ggplot2)
library(dplyr)
library(fastDummies)
library(cluster)
library(factoextra)
library(plotly)
library(pheatmap)
library(igraph)
library(mclust)
library(dbscan)

# -------------------------------------------------- 1. Pre-processing of data ----------------------------------------------------------------

# Define column names
columns <- c("age", "workclass", "fnlwgt", "education", "education_num", "marital_status", 
             "occupation", "relationship", "race", "sex", "capital_gain", "capital_loss", 
             "hours_per_week", "native_country", "income")

# Load and process the dataset
adult_data <- read.table("~/Documents/uni/411/Assignment/adult/adult.data", sep = ",", header = FALSE, col.names = columns, na.strings = " ?") %>%
  filter(complete.cases(.))

# Define numeric and categorical columns
numeric_cols <- c("age", "fnlwgt", "education_num", "capital_gain", "capital_loss", "hours_per_week")
categorical_cols <- c("workclass", "education", "marital_status", "occupation", "relationship", "race", "sex", "native_country")

# One-hot encoding categorical variables
categorical_encoded <- dummy_cols(adult_data[categorical_cols], remove_first_dummy = TRUE, remove_selected_columns = TRUE)

# Combine numerical and encoded categorical data
data <- adult_data %>%
  select(all_of(numeric_cols)) %>%
  bind_cols(categorical_encoded)

# Scale numerical features
data <- data %>%
  mutate(across(all_of(numeric_cols), scale))

# Remove constant columns
data <- data %>%
  select(where(~ var(.) != 0))

# View the preprocessed data
View(data)

# -------------------------------------------------- 2. Clustering of data --------------------------------------------------------------------

# 2.1 Using K-Means

set.seed(123)
sub_data <- data %>% sample_n(5000)

# Remove constant columns again if they exist in the subset
non_constant_columns_sub <- sapply(sub_data, function(col) var(col, na.rm = TRUE) != 0)
sub_data <- sub_data[, non_constant_columns_sub]

# Determine number of clusters using Gap Statistic Method
fviz_nbclust(sub_data, kmeans, method = "gap_stat", nstart = 25, iter.max = 100)

# Determine number of clusters using Elbow Method
fviz_nbclust(sub_data, kmeans, method = "wss", nstart = 25, iter.max = 100) # k = 3 or k = 4

# Determine number of clusters using Silhouette Method
fviz_nbclust(sub_data, kmeans, method = "silhouette", nstart = 25, iter.max = 100) # k = 6

# From the analysis above, let's consider k = 3 is the optimal number of clusters
k <- 3

# Applying K-Means clustering with the optimal number of clusters
kmeans_output <- kmeans(sub_data, centers = k, nstart = 25, iter.max = 100)
clusters <- kmeans_output$cluster
centers <- kmeans_output$centers

# Visualize clusters
fviz_cluster(kmeans_output, geom = "point", data = sub_data, ellipse.type = "norm")

# Calculate silhouette score
silhouette_score <- silhouette(kmeans_output$cluster, dist(sub_data))
summary(silhouette_score)
fviz_silhouette(silhouette_score, main = 'Silhouette plot', palette = "jco")

# 2.2 - DBSCAN Clustering

dbscan_result <- dbscan(sub_data, eps = 0.5, minPts = 5)
fviz_cluster(dbscan_result, data = sub_data, stand = FALSE, geom = "point")

# 2.3 - Hierarchical Cluster

dist_matrix <- dist(sub_data)
hc <- hclust(dist_matrix, method = "ward.D2")

# Plot dendrogram
plot(hc, cex = 0.6, hang = -1)
clusters <- cutree(hc, k = 5)
fviz_cluster(list(data = sub_data, cluster = clusters))

# 2.4  - Statistical Model
fit_m<-Mclust(sub_data)
plot(fit_m)
