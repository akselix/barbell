# barbell.R
# Coursera Practical Machine Learning - Course Project
# 2015-06-11 

## The data for this project come from this source: http://groupware.les.inf.puc-rio.br/har.


# OPTIONS AND LIBRARIES
setwd('/Users/r2/MOOC/DSS/8. Practical Machine Learning')
options(scipen =999)


library(caret)
library(randomForest)
library(mlearning)
library(knitr)


# READ IN DATA
rawTraining <- read.csv('pml-training.csv', stringsAsFactors = F, na.strings = "")
rawTest <- read.csv('pml-testing.csv', stringsAsFactors = F, na.strings = "")


# PREPARE DATA FOR ANALYSIS

## Remove first 7 variables as they don't contain useful information for prediction
training <- rawTraining[, -(1:7)]
testing <- rawTest[, -(1:7)]

# Most variables don't have any missing values, but some have over 97% of values missing. Let's remove those.
training <- training[colSums(is.na(testing)) == 0]
testing <- testing[colSums(is.na(testing)) == 0]

## Remove variables with near zero variance
nzv <- nearZeroVar(training)
training <- training[-nzv]

nzv <- nearZeroVar(testing)
testing <- testing[-nzv]


# MODEL BUILDING

## Set outcome variable "classe" to factor
training$classe <- as.factor(training$classe)

## Create data partitions
set.seed(9875)

trainIndex <- createDataPartition(training$classe, list = F, p = 0.7)
train <- training[trainIndex, ]
validation <- training[- trainIndex, ]
dim(train); dim(validation)

## Train random forest model
rfModel <- randomForest(classe ~ .,
                        data = train,
                        mtry = 7,
                        ntree = 500,
                        proximity = F)

## Use the model to predict on teh validation set and create a confusion matrix of the results
rfPredict <- predict(rfModel, validation)
predictConfusion <- confusion(validation$classe, rfPredict)


# RESULTS

## Compare model estimates and prediction results and plot prediction confusion matrix
print(rfModel)
print(predictConfusion)
confusionBarplot(predictConfusion, col = 'white',  main = 'False Positives vs False Negatives')

## Plot the top ten prediction variables based on MeanDecreaseGini

varImpPlot(rfModel, n.var = 10, main = "Relative Importance of Top 10 Variables")


# SUBMIT SCRIPT FOR EVALUATION

## Use the model to predict on actual test data
finalTest <- predict(rfModel, testing)
answers <- as.character(unlist(finalTest))

## Write the submission files
pml_write_files = function(x){
    n = length(x)
    for(i in 1:n){
        filename = paste0("problem_id_",i,".txt")
        write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
    }
}
setwd("/Users/r2/MOOC/DSS/8. Practical Machine Learning/Project Answers")

pml_write_files(answers)

