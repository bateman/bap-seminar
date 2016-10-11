library(mlbench) 
data(Sonar)  # 208 obs. of 61 vars 
# 60 predictors, 1 binary outcome, class: 'Mine' or 'Rock')

library(caret)  
set.seed(998)
inTraining <- createDataPartition(Sonar$Class, p = .75, list = FALSE)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]

fitControl <- trainControl(## 10-fold CV
  method = "none",
  ## Estimate class probabilities
  classProbs = TRUE,
  ## func to compute the sensitivity, specificity 
  ## and area under the ROC curve
  summaryFunction = twoClassSummary)

set.seed(825)

gbmGrid <- data.frame(interaction.depth = 5,
                    n.trees = 150,
                    shrinkage = .1,
                    n.minobsinnode = 10)
gbmTuned <- train(Class ~ ., data = training, 
                  # gradient boosting machine (ensemble tree learner)
                  method = "gbm",
                  trControl = fitControl,
                  preProcess = c("center", "scale"),
                  tuneGrid = gbmGrid,  # tuned params 
                  ## Specify which metric to optimize
                  metric = "ROC",
                  verbose = FALSE)
predictions = predict(gbmTuned, testing)
probabilities = predict(gbmTuned, testing, type = "prob")
confusionMatrix(predictions, testing$Class)

svmGrid <- data.frame(sigma = 0.01323516, C = 4)
svmTuned <- train(Class ~ ., data = training, 
                  # gradient boosting machine (ensemble tree learner)
                  method = "svmRadial",
                  trControl = fitControl,
                  preProcess = c("center", "scale"),
                  tuneGrid = svmGrid,  # tuned params 
                  ## Specify which metric to optimize
                  metric = "ROC",
                  verbose = FALSE)
predictions = predict(svmTuned, testing)
probabilities = predict(svmTuned, testing, type = "prob")
confusionMatrix(predictions, testing$Class)

rdaGrid <- data.frame(gamma = 0.5, lambda = 0.5)
rdaTuned <- train(Class ~ ., data = training, 
                  # gradient boosting machine (ensemble tree learner)
                  method = "rda",
                  trControl = fitControl,
                  preProcess = c("center", "scale"),
                  tuneGrid = rdaGrid,  # tuned params 
                  ## Specify which metric to optimize
                  metric = "ROC",
                  verbose = FALSE)
predictions = predict(rdaTuned, testing)
probabilities = predict(rdaTuned, testing, type = "prob")
confusionMatrix(predictions, testing$Class)

