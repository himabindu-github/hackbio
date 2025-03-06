#################### Load packages----
library(tidyverse)
library(ggplot2)
library(caret)
library(pROC)
library(knitr)

#################### Import dataset----
url_cancer <- "https://raw.githubusercontent.com/PacktPublishing/Machine-Learning-in-Biotechnology-and-Life-Sciences/refs/heads/main/datasets/dataset_wisc_sd.csv"
cancer.data <- read.csv(url_cancer, header = T, sep = ",", row.names=1, check.names = FALSE)


#################### Preprocessing-----
str(cancer.data)

# Replace spaces with underscores
colnames(cancer.data) <- gsub(" ", "_", colnames(cancer.data))

# `concave_points_worst` has numeric values but the datset shows it is character.
# remove non numeric characters
cancer.data$concave_points_worst <- gsub("[^0-9.]", "", cancer.data$concave_points_worst)
cancer.data$concave_points_worst <- as.numeric(cancer.data$`concave_points_worst`)


#check for missing values
table(is.na(cancer.data))
cancer.data.clean <- na.omit(cancer.data)
table(is.na(cancer.data.clean))


###target variable -> diagnosis
unique(cancer.data.clean$diagnosis)

# ML algorithms need numeric data to perform calculations.
# Convert 'diagnosis' to numeric; binary values: 1 for Malignant ("M") and 0 for Benign ("B")
# to make it suitable for logistic regression 
# ifelse checks if diagnosis value is M it assigns value 1 if not it assigns 0
# as.factor converts it into a factor
# 'diagnosis' is a categorical variable, and for classification tasks, 
# it's important to treat it as a factor so that R understands it's a categorical outcome.
cancer.data.clean$diagnosis <- as.factor(ifelse(cancer.data.clean$diagnosis == "M", 1, 0))


# Split the data into training and testing sets
set.seed(123)  # for reproducibility
train_index <- createDataPartition(cancer.data.clean$diagnosis, p = 0.7, list = FALSE)
train_data <- cancer.data.clean[train_index, ]
test_data <- cancer.data.clean[-train_index, ]


#################### Train : logistic regression----
lr_model <- train(diagnosis ~ ., data = train_data,
                  method = "glm",
                  family = "binomial",
                  trControl = trainControl(method = "cv", number = 5))  # 5-fold cross-validation
# Print model summary
summary(lr_model)


# prediction on test data
predictions <- predict(lr_model, newdata = test_data)


#evaluate performance confusion matrix
lr.confusion_matrix <- confusionMatrix(predictions, test_data$diagnosis)
  # compares the predicted and actual values to generate a confusion matrix
  # calculates key metrics such as accuracy, sensitivity, specificity, and precision.


# model performance metrics
roc_obj <- roc(test_data$diagnosis, as.numeric(predictions))
lr.auc <- auc(roc_obj)
# ROC Curve helps visualize the performance of a classifier across 
# different thresholds by plotting the specificity vs sensitivity.
# An AUC of 0.9569 suggests that the model performs very well and it can 
# effectively distinguish between benign and malignant cases. 
# This high AUC indicates that the model has low chances of misclassifying the two classes.



####################### Train : Random forest-----
rfmb_model <- train(diagnosis ~ ., data = train_data,
                    method = "rf",
                    trControl = trainControl(method = "cv", number = 5))
                    

# Print model summary
print(rfmb_model)

# make predictions using test data
predictions_rfmb <- predict(rfmb_model, newdata = test_data)


# performance evaluation : confusion matrix
rf.confusion_matrix <- confusionMatrix(predictions_rfmb, test_data$diagnosis)



# model performance metrics
predictions_rf <- predict(rfmb_model, newdata = test_data, type = "prob")
rf_probabilities <- predictions_rf[, 2] 
roc_obj <- roc(test_data$diagnosis, rf_probabilities)
rf.auc <-auc(roc_obj)



## plot ROC
#png("roc_curve.png", width = 1000, height = 800, res = 150)
par(pty = "s", cex.axis = 1.0)
plot.roc(test_data$diagnosis, 
         as.numeric(predictions), 
         col = "blue", main = "ROC Curve",
         legacy.axes = TRUE,
         lwd = 4,
         print.auc = TRUE,
         print.auc.y = 0.4)

plot.roc(test_data$diagnosis, 
         rf_probabilities, 
         col = "red", 
         main = "ROC Curve", 
         legacy.axes = "TRUE",
         lwd = 4,
         print.auc = TRUE,
         print.auc.y = 0.45,
         add = TRUE)
legend("bottomright", 
       legend = c("Logistic Regression", "Random Forest"),
       col = c("blue", "red"),
       lwd =4)

#dev.off()


#check variable importance
varImp(rfmb_model)


# Plot variable importance
importance_data <- varImp(rfmb_model)
ggplot(importance_data, aes(x = reorder(Overall, Overall), y = Overall)) + # orders features based on their importance scores
  geom_bar(stat = "identity") + # length of the bars corresponds to the importance score for each feature
  coord_flip() +
  labs(title = "Random Forest Variable Importance", x = "Feature", y = "Importance")


# Based on the importance scores, you can select the most important features 
# for the model. Feature selection means keeping the most important features, 
# like 'perimeter_worst' and 'concave_points_worst' etc., while removing 
# less important ones, such as 'texture_se' and 'perimeter_se', to make the 
# model more efficient. However, it's important to also consider 
# expert knowledge to ensure that valuable features aren't ignored, 
# even if they're not ranked as highly by the model.


#############################################################################