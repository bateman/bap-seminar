library(caret)
library(C50) # decision trees classifiers
library(mlbench) # for diabetes database
data(PimaIndiansDiabetes)
dim(PimaIndiansDiabetes)
allData <- PimaIndiansDiabetes

# diabetes is the binary outcome that we want to predict
# the remaining 8 are the predictors
predictors <- names(allData)[names(allData) != "diabetes"]

# make sure to set seed before any data splitting 
# makes the splitting deterministic and repeatable
set.seed(1)
# 70/30 percentage split on the outcome factor
# random sampling is stratified preserves the overall class distribution of the data
# data.frame allData sliced by column name, retains all rows
# list = FALSE means data returned as matrix, instead
# split indices are returned in a list of integer vectors
splitIndices <- createDataPartition(allData$diabetes, p = .70, list = FALSE) 
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
modelDS <- C5.0(diabetes~., data=stdTrainingSet)
# make predictions
predictions <- predict(modelDS, testSet[, predictors])
# summarize results
confusionMatrix(predictions, testSet[, "diabetes"], positive = "pos")  # same as testSet$diabetes

#### boostrap
# define training control with N iterations
train_control_boot <- trainControl(method="boot", number=2)
# train the model
modelBoot <- train(diabetes~., data=stdTrainingSet, trControl=train_control_boot, method="C5.0")
# make predictions
predictions <- predict(modelBoot, testSet[, predictors])
# summarize results
confusionMatrix(predictions, testSet[, "diabetes"], positive = "pos")  

### k-fold
train_control_cv <- trainControl(method="cv", number=5)
# train the model
modelCV <- train(diabetes~., data=stdTrainingSet, trControl=train_control_cv, method="C5.0")
# make predictions
predictions <- predict(modelCV, testSet[, predictors])
# summarize results
confusionMatrix(predictions, testSet[, "diabetes"], positive = "pos")

### repeated k-fold
train_control_rcv <- trainControl(method="repeatedcv", number=5, repeats = 3)
# train the model
modelRCV <- train(diabetes~., data=stdTrainingSet, trControl=train_control_rcv, method="C5.0")
# make predictions
predictions <- predict(modelRCV, testSet[, predictors])
# summarize results
confusionMatrix(predictions, testSet[, "diabetes"], positive = "pos")
