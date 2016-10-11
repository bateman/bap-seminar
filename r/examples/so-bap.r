library(caret) # for param tuning
library(pROC) # for AUC

# creates current output directory for current execution
output_dir <- "../output"
if(!dir.exists(output_dir))
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE, mode = "0777")

# read dfm
csv_file <- "../input/so-500.csv"
SO <- read.csv(csv_file, header = TRUE, sep=",")

outcome <- "solution"
# list of 21 predicting features
predictors <- names(SO)[names(SO) != outcome]

# exclude possible rows with Na, NaN and Inf (missing values)
SO <- na.omit(SO)
# first check whether there are leading and trailing apostrophes around the date_time field
SO$date_time <- gsub("'", '', SO$date_time)
# then convert timestamps into POSIX std time values, then to equivalent numbers
SO$date_time <- as.numeric(as.POSIXct(strptime(SO$date_time, "%Y-%m-%d %H:%M:%S")))

set.seed(567)
# create stratified training and test sets from SO dataset
splitIndex <- createDataPartition(SO[,outcome], p = .70, list = FALSE)
training <- SO[splitIndex, ]
testing <- SO[-splitIndex, ]

set.seed(825)
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

model <- caret::train(solution~., 
                      data = training,
                      method = "gbm",
                      trControl = fitControl,
                      metric = "ROC",
                      preProcess = c("center", "scale"),
                      tuneLength = 5 # five values per param
               )
                      
model
getTrainPerf(model)

predictions = predict(model, testing[, predictors])
confusionMatrix(predictions, testing$solution, positive = "True")

probs = predict(model, testing[, predictors], type = "prob")
roc.result <- roc(response = testing$solution, 
                  predictor = probs$True,
                  levels = c("True", "False"))
roc.result$auc
plot(roc.result, print.auc=TRUE,
     main="ROC plot", legacy.axes = TRUE, xlab="FPR", ylab="TPR", col=rainbow(1))
# smooth
plot(smooth(roc.result), print.auc=TRUE,
     main="ROC plot", legacy.axes = TRUE, xlab="FPR", ylab="TPR", col=rainbow(1))
