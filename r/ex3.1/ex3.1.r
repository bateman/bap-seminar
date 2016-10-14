library(caret) # for param tuning
library(pROC) # for AUC

# creates current output directory for current execution
output_dir <- "../output"
if(!dir.exists(output_dir))
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE, mode = "0777")

# read dfm
SO <- read.csv("../input/so-1k.csv", header = TRUE, sep=",")
# exclude possible rows with Na, NaN and Inf (missing values)
SO <- na.omit(SO)
# first check whether there are leading and trailing apostrophes around the date_time field
SO$date_time <- gsub("'", '', SO$date_time)
# then convert timestamps into POSIX std time values, then to equivalent numbers
SO$date_time <- as.numeric(as.POSIXct(strptime(SO$date_time, "%Y-%m-%d %H:%M:%S")))
SO <- SO[, -2] # drop answer_id column, not a predictor

# read dfm
dwolla <- read.csv("../input/dwolla.csv", header = TRUE, sep=";")
# exclude possible rows with Na, NaN and Inf (missing values)
dwolla <- na.omit(dwolla)
# first check whether there are leading and trailing apostrophes around the date_time field
dwolla$date_time <- gsub("'", '', dwolla$date_time)
# then convert timestamps into POSIX std time values, then to equivalent numbers
dwolla$date_time <- as.numeric(as.POSIXct(strptime(dwolla$date_time, "%d/%m/%Y %H:%M")))
dwolla <- dwolla[, -2] # drop answer_id column, not a predictor

outcome <- "solution"
# list of predicting features
predictors <- names(SO)[names(SO) != outcome]
training <- SO
testing <- dwolla

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

colors = rainbow(1)
line_types = 1:1

modelFit <- caret::train(solution~., 
                         data = training,
                         method = "gbm",
                         trControl = fitControl,
                         metric = "ROC",
                         preProcess = c("center", "scale"),
                         tuneLength = 5 # five values per param
)

modelFit
getTrainPerf(modelFit)

predictions = predict(modelFit, testing[, predictors])
confusionMatrix(predictions, testing$solution, positive = "True")

probs = predict(modelFit, testing[, predictors], type = "prob")
roc.result <- roc(response = testing$solution, 
                  predictor = probs$True,
                  levels = c("True", "False"))
roc.result$auc

#plot(roc.result, add=TRUE, add=ifelse(i==1,FALSE,TRUE), type = line_types[i],
#     main="ROC plot", legacy.axes = TRUE, xlab="FPR", ylab="TPR", col=colors[i])
# smooth
plot(smooth(roc.result), lty = line_types[1],
     main="ROC plot", legacy.axes = TRUE, xlab="FPR", ylab="TPR", col=colors[1])
#png(filename = "roc.png") # only saves the files on disk
dev.copy(png, filename="roc.png")  # shows both the window and saves the file
dev.off()
