# Cancer data: Tumor Classification and Clustering Analysis
### Dataset Overview
The dataset consists of cancer-related data, where the goal is to classify tumors as either Malignant or Benign. The features provided include various physical characteristics of the tumors, such as area, perimeter, smoothness, and others.

### Modeling Methods
- Logistic Regression:
A statistical model used to predict whether a tumor is Malignant or Benign based on its physical features.
- Random Forest:
A machine learning method that uses an ensemble of decision trees to classify the tumors into benign or malignant categories.

### Model Performance Evaluation
- ROC Curve:
Visualized the trade-off between sensitivity (true positive rate) and specificity (true negative rate) for both models.
- AUC (Area Under the Curve):
Both models performed well with high AUC values, suggesting they are good at distinguishing between benign and malignant tumors.
- Accuracy:
Both models showed high accuracy, confirming that they are effective at predicting the correct diagnosis based on the tumor's physical features.

### Model Performance table

|Model               | Accuracy| Precision| Sensitivity| Specificity| F1_Score|       AUC|
|:-------------------|--------:|---------:|-----------:|-----------:|--------:|---------:|
|Random Forest       |   0.9524| 0.9827586|   0.9193548|   0.9905660|    0.950| 0.9891966|
|Logistic Regression |   0.9583| 0.9365079|   0.9516129|   0.9622642|    0.944| 0.9569385|


### PCA (Principal Component Analysis)
Before applying machine learning models, PCA was used to reduce the complexity of the data by compressing multiple features into fewer components (2 components in this case). This makes it easier to analyze and visualize the data:

- PCA Result: The data was reduced to two main components (PC1 and PC2), which simplified the visualization.
PCA Visualization: The plot showed an overlap between the benign and malignant groups, suggesting that these two categories aren't perfectly separable in the original feature space.
- K-means Clustering
After applying PCA, K-means clustering was used to divide the patients into two groups based on similarities in the data. The goal was to see if K-means could identify natural clusters of patients, which might correspond to the benign and malignant groups.

- Clustering Outcome: K-means effectively separated the patients into two distinct clusters.
- Cluster Interpretation: The clusters may correspond to benign and malignant tumors.

### Classifying Patients Based on PCA and K-means
- PCA helped simplify and visualize the data, showing some overlap between benign and malignant tumors.
- K-means Clustering separated the patients into two groups. These groups could be interpreted as the predicted classes of patients, similar to benign vs. malignant labels.

### Clustering Evaluation and Optimal Configuration
- Silhouette Width:
The silhouette width helped determine the quality of the clusters. Based on this, 2 clusters provided the best separation, with Cluster 2 showing a higher silhouette width.
- 3 Clusters:
Adding a third cluster might improve the grouping by capturing borderline cases or distinguishing between different tumor subtypes. These clusters could represent uncertain or borderline cases.

### Conclusion
- PCA simplified the dataset by reducing the number of dimensions, making it easier to visualize and analyze.
- K-means clustering grouped the patients into two clusters, which seem to correspond to the benign and malignant diagnoses. The model performed well in this unsupervised classification task.
- Clustering and Model Comparison: Based on silhouette widths, 2 clusters worked best, but 3 clusters might uncover more meaningful groups, like borderline cases.
- By combining PCA and K-means clustering, we achieved a better understanding of how the tumors can be categorized, providing a foundation for further exploration and refinement of the clustering process.












