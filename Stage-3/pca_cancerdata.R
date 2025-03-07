#################### Load libraries----

library(tidyverse)
library(ggplot2)
library(caret)
library(factoextra)
library(cluster)
library(fpc)

#################### Import dataset-----
url_cancer <- "https://raw.githubusercontent.com/PacktPublishing/Machine-Learning-in-Biotechnology-and-Life-Sciences/refs/heads/main/datasets/dataset_wisc_sd.csv"
cancer.data <- read.csv(url_cancer, header = T, sep = ",", row.names=1, check.names = FALSE)



#################### Scale and preprocess the data-----
str(cancer.data)

# Replace spaces with underscores
colnames(cancer.data) <- gsub(" ", "_", colnames(cancer.data))

# `concave_points_worst` has numeric values but the dataset shows it is character.
# remove non numeric characters
cancer.data$concave_points_worst <- gsub("[^0-9.]", "", cancer.data$concave_points_worst)
cancer.data$concave_points_worst <- as.numeric(cancer.data$`concave_points_worst`)

#check for missing values
table(is.na(cancer.data))
cancer.data.clean <- na.omit(cancer.data)
table(is.na(cancer.data.clean))

########## features and target variables
features <- select(cancer.data.clean, -diagnosis)
target <- cancer.data.clean$diagnosis

##scaling to standardize data
scaled.cancer.data <- scale(features)
rownames(scaled.cancer.data) <- NULL



##################### Perform PCA and visualize the results.------
# We use prcomp to perform PCA
pca_cancer <- prcomp(scaled.cancer.data, center = TRUE, scale. = TRUE)
summary(pca_cancer)

#screeplot(pca_cancer, type = "lines", main = "Scree Plot")

# Visualize the PCA result using factoextra
pca.plot <- fviz_pca_ind(pca_cancer, 
             col.ind = target,
             palette = c("green", "red"),  
             addEllipses = TRUE,                      
             legend.title = "Diagnosis",              
             title = "PCA Plot - Individuals Colored by Diagnosis",
             label = "none")

ggsave("PCA_plot.png", plot = pca.plot, width = 8, height = 6, dpi = 300)


################# Perform K-means clustering----- 
# Determining the optimal number of clusters
# Elbow/WSS method 
fviz_nbclust(pca_cancer$x[, 1:2], kmeans, method = "wss")

# Silhouette method 
fviz_nbclust(pca_cancer$x[, 1:2], kmeans, method = "silhouette")


################## perform clustering k means-----
#clusters = 2
set.seed(123)  
kmeans_result <- kmeans(pca_cancer$x[, 1:2], centers = 2)
kmeans_result$cluster

# Visualize clusters from K-means on PCA data
kmeans_cluster2_plot <- fviz_cluster(kmeans_result, data = pca_cancer$x[, 1:2], 
                              geom = "point",  
                              stand = FALSE,   # no scaling the data again 
                              addEllipses = TRUE, 
                              ggtheme = theme_minimal(), 
                              main = "K-means clustering on PCA data")

ggsave("kmeans-2clustering-pca.png", plot = kmeans_cluster_plot, width = 8, height = 6, dpi = 300)

# clusters = 3
set.seed(123)  
kmeans_result_3 <- kmeans(pca_cancer$x[, 1:2], centers = 3)
kmeans_result_3$cluster

# Visualize clusters(3) from K-means on PCA data
kmeans_cluster3_plot <- fviz_cluster(kmeans_result_3, data = pca_cancer$x[, 1:2], 
                                    geom = "point",  
                                    stand = FALSE,   # no scaling the data again 
                                    addEllipses = TRUE, 
                                    ggtheme = theme_minimal(), 
                                    main = "K-means clustering on PCA data")

ggsave("kmeans-3clustering-pca.png", plot = kmeans_cluster_plot, width = 8, height = 6, dpi = 300)



##############################################################################
# Validate the clustering with additional metrics like the Dunn Index 
#### higher Dunn index : better clustering

install.packages("fpc")
library(fpc)
# label the clusters
cluster_labels <- kmeans_result$cluster

# calculate statistics that measure the quality of clustering results: Dunn Index
clustering_stats <- cluster.stats(dist(pca_cancer$x[, 1:2]), cluster_labels)

# Dunn index is stored in the clustering_stats list
dunn_index <- clustering_stats$dunn
#print(paste("Dunn Index: ", dunn_index))

# for 2 clusters (as obtained from Silhouette and gap-stat methods)
kmeans_2 <- kmeans(pca_cancer$x[, 1:2], centers = 2)
cluster_labels_2 <- kmeans_2$cluster
dunn_index_2 <- cluster.stats(dist(pca_cancer$x[, 1:2]), cluster_labels_2)$dunn


# for 3 clusters (as from wss/elbow method)
kmeans_3 <- kmeans(pca_cancer$x[, 1:2], centers = 3)
cluster_labels_3 <- kmeans_3$cluster
dunn_index_3 <- cluster.stats(dist(pca_cancer$x[, 1:2]), cluster_labels_3)$dunn


# for 4 clusters
kmeans_4 <- kmeans(pca_cancer$x[, 1:2], centers = 4)
cluster_labels_4 <- kmeans_4$cluster
dunn_index_4 <- cluster.stats(dist(pca_cancer$x[, 1:2]), cluster_labels_4)$dunn



print(paste("Dunn Index for 3 clusters: ", dunn_index_3))
print(paste("Dunn Index for 2 clusters: ", dunn_index_2))
print(paste("Dunn Index for 4 clusters: ", dunn_index_4))

## dunn index is highest for 2 clusters

#### silhouette width
silhouette_result_2 <- silhouette(cluster_labels_2, dist(pca_cancer$x[, 1:2]))

# Plot the silhouette width
fviz_silhouette(silhouette_result_2)

silhouette_result_3 <- silhouette(cluster_labels_3, dist(pca_cancer$x[, 1:2]))
# Plot the silhouette width
fviz_silhouette(silhouette_result_3)




