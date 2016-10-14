library(caret) # for param tuning
library(pROC) # for AUC

# you can easily turn this into a function
save_plot <- function(models, roc.results, title, file_name) {
line_types = 1:length(models)
colors = rainbow(length(models))

i<- 0
png(filename=file_name)
for (roc.result in roc.results) {
  i <- i+1
  # smooth
  plot(smooth(roc.result), lty = line_types[i], add=ifelse(i==1, FALSE, TRUE),
       main=title, legacy.axes = TRUE, xlab="FPR", ylab="TPR", col=colors[i])
}
# add the legend to the plot
legend("topleft", # position
       title = "Models",
       legend = models, # text values
       fill = colors, # square colors
       bty = "n") # no borders
dev.off()
}

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

# read dfm
docusign <- read.csv("../input/docusign.csv", header = TRUE, sep=";")
# exclude possible rows with Na, NaN and Inf (missing values)
docusign <- na.omit(docusign)
# first check whether there are leading and trailing apostrophes around the date_time field
docusign$date_time <- gsub("'", '', docusign$date_time)
# then convert timestamps into POSIX std time values, then to equivalent numbers
docusign$date_time <- as.numeric(as.POSIXct(strptime(docusign$date_time, "%d/%m/%Y %H:%M:%S")))
docusign <- docusign[, -c(1, 2, 4, 21, 22, 25, 28, 32, 33)]

outcome <- "solution"
# list of predicting features
predictors <- names(SO)[names(SO) != outcome]
testingsets <- vector(mode="list", length=2)

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

# load all the classifiers to test
modelsfile <- "../models/models.txt"
models <- readLines(modelsfile)
line_types = 1:length(models)
colors = rainbow(length(models))

roc.results.docusign = vector(mode = "list", length = length(models))
roc.results.dwolla = vector(mode = "list", length = length(models))
for(i in 1:length(models)){
  modelFit <- caret::train(solution~., 
                           data = SO,
                           method = models[i],
                           trControl = fitControl,
                           metric = "ROC",
                           preProcess = c("center", "scale"),
                           tuneLength = 5 # five values per param
                          )
  modelFit
  ##### docusign
  probs = predict(modelFit, docusign[, predictors], type = "prob")
  roc.result <- roc(response = docusign$solution,
                    predictor = probs$True,
                    levels = c("True", "False"))
  roc.results.docusign[[i]] = roc.result
  
  #### dwolla
  probs = predict(modelFit, dwolla[, predictors], type = "prob")
  roc.result <- roc(response = dwolla$solution,
                    predictor = probs$True,
                    levels = c("True", "False"))
  roc.results.dwolla[[i]] = roc.result
}

save_plot(models, roc.results.docusign, title="ROC plot SO - Docusign", file_name="roc-docusign.png")
save_plot(models, roc.results.dwolla, title="ROC plot SO - Dwolla", file_name="roc-dwolla.png")
