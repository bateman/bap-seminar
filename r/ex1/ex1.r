library(mlbench) 
data(Sonar)  # 208 obs. of 61 vars 
# 60 predictors, 1 binary outcome, class: 'Mine' or 'Rock')

library(caret)  
set.seed(998)
inTraining <- createDataPartition(Sonar$Class, p = .75, list = FALSE)
training <- Sonar[ inTraining,]
testing  <- Sonar[-inTraining,]

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
xxxMethod1XxxxTuned <- train(Class ~ ., data = training, 
                  method = "xxxMethod1Xxxx",
                  trControl = fitControl,
                  preProcess = c("center", "scale"),
                  tuneLength = 5,  # five values per param 
                  ## Specify which metric to optimize
                  metric = "ROC",
                  verbose = FALSE)
xxxMethod1XxxxTuned

xxxMethod2XxxxTuned <- train(Class ~ ., data = training, 
                             method = "xxxMethod2Xxxx",
                             trControl = fitControl,
                             preProcess = c("center", "scale"),
                             tuneLength = 5,  # five values per param 
                             ## Specify which metric to optimize
                             metric = "ROC",
                             verbose = FALSE)
xxxMethod2xxxTuned

xxxMethod3XxxxTuned <- train(Class ~ ., data = training, 
                             method = "xxxMethod13xxx",
                             trControl = fitControl,
                             preProcess = c("center", "scale"),
                             tuneLength = 5,  # five values per param 
                             ## Specify which metric to optimize
                             metric = "ROC",
                             verbose = FALSE)
xxxMethod3XxxxTuned