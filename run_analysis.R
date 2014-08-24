## Please make sure you have the "stringr" package installed
## Loading in libraries
library(stringr)

## Reading in Datasets First

## Features and activities



features <- read.table("./features.txt")
activities <- read.table("./activity_labels.txt")
colnames(activities)[1]<-"Activity"

## Test Data Sets

testX <- read.table("./test/X_test.txt")
testY <- read.table("./test/Y_test.txt")
testS <- read.table("./test/subject_test.txt")

## Train Data Sets

trainX <- read.table("./train/X_train.txt")
trainY <- read.table("./train/Y_train.txt")
trainS <- read.table("./train/subject_train.txt")

## Merging Datasets

## Merge test and train data sets (rbind)

mergeX <- rbind(testX, trainX)
mergeY <- rbind(testY, trainY)
mergeS <- rbind(testS, trainS)

## Rename Columns in Merged Tables

colnames(mergeX)<-features[,2]
colnames(mergeY)<-"Activity"
colnames(mergeS)<-"Subject"

## Rename rows in activities tables to merge

## Locate mean and std columns within features

meanc <- str_detect(features[,2], "mean")
stdc <- str_detect(features[,2], "std")                

meanTRUE <- which(meanc==TRUE)
stdTRUE <- which(stdc==TRUE)

meanstd <- c(meanTRUE, stdTRUE)
meanstd <- sort(meanstd)

## Create Clean features (X) table

cleanX <- mergeX[meanstd]

## Merge into one combo set (cbind)

combo <- cbind(mergeS,mergeY,cleanX)
cleancombo <- merge(combo,activities)