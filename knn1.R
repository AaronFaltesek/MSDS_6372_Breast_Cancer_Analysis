#https://www.r-bloggers.com/k-nearest-neighbor-step-by-step-tutorial/

set.seed(12345)

library(caret)
library(e1071)
library(ROCR)

# Read in Data
train <-read.csv("data/breast_cancer_training.csv", header = TRUE)
validation <- read.csv("data/breast_cancer_testing.csv", header = TRUE)

train <- train[,2:11]
train_outcome <- sapply(train$Outcome, function(x) if (x > 3) {"M"} else {"B"})
train <- cbind(train, train_outcome)
train <- train[,-10]
validation <- validation[,2:11]
validation_outcome <- sapply(validation$Outcome, function(x) if (x > 3) {"M"} else {"B"})
validation <- cbind(validation, validation_outcome)
validation <- validation[,-10]

dim(train)
dim(validation)
names(train)
head(train)
head(validation)

trc = trainControl(method = "repeatedcv",
                 number = 10, # k-fold
                 repeats = 3,
                 classProbs = TRUE,
                 summaryFunction = twoClassSummary)

model1 <- train(train_outcome~. , data = train, method = "knn",
                trControl = trc,
                metric = "ROC",
                tuneLength = 10)

model1
plot(model1)

# Validation
valid_pred <- predict(model1, validation, type = "prob")
valid_pred2 <- predict(model1, newdata=validation)


#Storing Model Performance Scores using library ROCR
predicted_values <-prediction(valid_pred[,2],validation$validation_outcome)

# AUC
perf_val <- performance(predicted_values, "auc")
perf_val

# Plot AUC 
perf_val <- performance(predicted_values, "tpr", "fpr")
plot(perf_val, col = "green", lwd = 1.5)

#Confusion Matrix
confusionMatrix(valid_pred2, validation$validation_outcome)
