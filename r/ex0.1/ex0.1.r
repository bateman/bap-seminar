library(caret)

library(C50) # decision trees classifier
data(churn)

# dataframes already available for training and test
str(churnTrain)
str(churnTest)
# merges tables by columns
allData <- rbind(churnTrain, churnTest)

# churn is the binary outcome that we want to predict
# the remaining 19 are the predictors
predictors <- names(allData)[names(allData) != "churn"]

# make sure to set seed before any data splitting 
# makes the splitting deterministic and repeatable
set.seed(1)
# 80/20 percentage split on the outcome binary factor
# random sampling is stratified preserves the overall class distribution of the data
# data.frame allData sliced by column name, retains all rows
# list = FALSE means data returned as matrix, instead
# split indices are returned in a list of integer vectors
splitIndices <- createDataPartition(allData$churn, p = .80, list = FALSE) 
trainingSet <- allData[splitIndices, ]  # retains rows by index 
testSet <- allData[-splitIndices, ]  # retains the other rows by index

# standardize training data
preprocessParams <- preProcess(trainingSet, method=c("center", "scale"))
# summarize transform parameters
print(preprocessParams)
# transform the dataset using the parameters
stdTrainingSet <- predict(preprocessParams, trainingSet)
# compare the transformed dataset
summary(trainingSet)
summary(stdTrainingSet)

##### data split
# train a C5.0 decision tree model
modelDS <- C5.0(churn~., data=stdTrainingSet)
# make predictions
predictions <- predict(modelDS, testSet[, predictors])
# summarize results
confusionMatrix(predictions, testSet[, "churn"])  # same as stdTrainingSet$churn

#### boostrap
# define training control with N iterations
train_control_boot <- trainControl(method="boot", number=5)
# train the model
modelBoot <- train(churn~., data=stdTrainingSet, trControl=train_control_boot, method="C5.0")
# make predictions
predictions <- predict(modelBoot, testSet[, predictors])
# summarize results
confusionMatrix(predictions, testSet[, "churn"])  # same as stdTrainingSet$churn

### k-fold
train_control_cv <- trainControl(method="cv", number=10)
# train the model
modelCV <- train(churn~., data=stdTrainingSet, trControl=train_control_cv, method="C5.0")
# make predictions
predictions <- predict(modelCV, testSet[, predictors])
# summarize results
confusionMatrix(predictions, testSet[, "churn"])  # same as stdTrainingSet$churn

### repeated k-fold
train_control_rcv <- trainControl(method="repeatedcv", number=10, repeats = 5)
# train the model
modelRCV <- train(churn~., data=stdTrainingSet, trControl=train_control_rcv, method="C5.0")
# make predictions
predictions <- predict(modelRCV, testSet[, predictors])
# summarize results
confusionMatrix(predictions, testSet[, "churn"])  # same as stdTrainingSet$churn

