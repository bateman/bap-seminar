library(mlbench) 
data(Sonar)  # 208 obs. of 61 vars 
# 60 predictors, 1 binary outcome, class: 'Mine' or 'Rock')

library(caret)  
set.seed(998)
inTraining <- createDataPartition(Sonar$Class, p = .75, list = FALSE)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]

# tuned values already known
fitControl <- trainControl(
  method = "none",
  classProbs = TRUE,
  ## func to compute the sensitivity, specificity 
  ## and area under the ROC curve
  summaryFunction = twoClassSummary)

tuned <- data.frame(interaction.depth = 4,
                    n.trees = 100,
                    shrinkage = .1,
                    n.minobsinnode = 20)

set.seed(825)
gbmTuned <- train(Class ~ ., data = training, 
                  # gradient boosting machine (ensemble tree learner)
                  method = "gbm",
                  trControl = fitControl,
                  preProcess = c("center", "scale"),
                  tuneGrid = tuned, 
                  ## Specify which metric to optimize
                  metric = "ROC",
                  verbose = FALSE)

predictions = predict(gbmTuned, testing)
probabilities = predict(gbmTuned, testing, type = "prob")
confusionMatrix(predictions, testing$Class)