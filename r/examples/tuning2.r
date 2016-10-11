library(mlbench) 
data(Sonar)  # 208 obs. of 61 vars 
# 60 predictors, 1 binary outcome, class: 'Mine' or 'Rock')

library(caret)  
set.seed(998)
inTraining <- createDataPartition(Sonar$Class, p = .75, list = FALSE)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]

# resampling can be any method shown before
fitControl <- trainControl(## 10-fold CV
                            method = "repeatedcv",
                            number = 10,
                            ## repeated ten times
                            repeats = 10,
                            ## Estimate class probabilities
                            classProbs = TRUE,
                            ## func to compute the sensitivity, specificity 
                            ## and area under the ROC curve
                            summaryFunction = twoClassSummary)

set.seed(825)
gbmTuned <- train(Class ~ ., data = training, 
                  # gradient boosting machine (ensemble tree learner)
                  method = "gbm",
                  trControl = fitControl,
                  preProcess = c("center", "scale"),
                  tuneLength = 5,  # five values per param
                  ## Specify which metric to optimize
                  metric = "ROC",
                  verbose = FALSE)
gbmTuned
