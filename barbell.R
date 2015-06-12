# barbell.R
# Coursera Practical Machine Learning - Course Project
# 2015-06-11 

## The data for this project come from this source: http://groupware.les.inf.puc-rio.br/har.


# General options and libraries
setwd('/Users/r2/MOOC/DSS/8. Practical Machine Learning')

option(scipen =999)

library(caret)
library(knitr)

# Read in data from working directory
training <- read.csv('pml-training.csv')
testing <- read.csv('pml-testing.csv')

# Exploratory Data Analysis




# Model Building