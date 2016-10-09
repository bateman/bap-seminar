# packages required for R exercises

print("Checking the required packages... will be automatically installed if missing.")

# checks if multicore parallel package can be enabled
if(.Platform$OS.type == "unix") {
  if(!require("doMC", quietly = TRUE)){
    install.packages(c("doMC"), dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
  }
} else if (.Platform$OS.type == "windows") {
  if(!require("doParallel", quietly = TRUE)){
    install.packages(c("doParallel"), dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
  }
}

# diabetes dataset
if(!require("mlbench", quietly = TRUE)){
  install.packages(c("mlbench"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

# Scott-Knott clustering test
if(!require("ScottKnott", quietly = TRUE)){
  install.packages("ScottKnott", dependencies = c("Imports", "Depends"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

# caret package for automated parameter tuning
if(!require("caret", quietly = TRUE)){
  install.packages(c("caret", "car", "pbkrtest", "lme4"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

# Boruta package for wrapper-based feature sealection
if(!require("Boruta", quietly = TRUE)){
  install.packages(c("Boruta"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

# Naive Bayes
if(!require("klaR", quietly = TRUE)){
  install.packages(c("klaR"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

if(!require("e1071", quietly = TRUE)){
  install.packages(c("e1071"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

# C5.0 decision trees library
if(!require("C50", quietly = TRUE)){
  install.packages(c("C50"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}

# Random Forest
if(!require("randomForest", quietly = TRUE)){
  install.packages(c("randomForest"), repos = "http://cran.mirror.garr.it/mirrors/CRAN/")
}