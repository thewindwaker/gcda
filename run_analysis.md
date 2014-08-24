---
title: "Run Analysis"
author: "Salman Ahmed"
date: "Sunday, August 24, 2014"
output: html_document
---

## Introduction

This Package manipulate data collected from a Samsung Smart Phone. It is a learning exercise for the Getting and Cleaning Class on Coursera. The five questions I was asked to complete are:

 - Merges the training and the test sets to create one data set.

 - Extracts only the measurements on the mean and standard deviation for each measurement. 

 - Uses descriptive activity names to name the activities in the data set

 - Appropriately labels the data set with descriptive variable names. 

 - Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

Please make sure you have the "stringr" package installed.

The following Code has section headings in it that explain what's going on.

#### Loading in libraries

library(stringr)

### Reading in Datasets and Features First

features <- read.table("./features.txt")
activities <- read.table("./activity_labels.txt")

#### Test Data Sets

testX <- read.table("./test/X_test.txt")
testY <- read.table("./test/Y_test.txt")
testS <- read.table("./test/subject_test.txt")

#### Train Data Sets

trainX <- read.table("./train/X_train.txt")
trainY <- read.table("./train/Y_train.txt")
trainS <- read.table("./train/subject_train.txt")

### Merging Datasets

#### Merge test and train data sets (rbind)

mergeX <- rbind(testX, trainX)
mergeY <- rbind(testY, trainY)
mergeS <- rbind(testS, trainS)

#### The training and test files have been combined into one file each for X, Y, and S. S are the subjects, Y are the activities, and X are the individual measurements.

### Renaming

### Rename Columns in Merged Tables

colnames(mergeX)<-features[,2]

#### This function renames the column headings in the x table with the actual attributes found in the features dataset.

colnames(mergeS)<-"Subject"

#### This function renames the column headings in the subjects file to "subject"

#### Rename rows in activities tables to merge

order<-1:10299
mergeY["order"]<-order
mergedY <- merge(mergeY,activities)
sortedY <- mergedY[order(mergedY[,"order"]),]
cleanY <- data.frame(Activity=character(),stringsAsFactors=FALSE)
cleanY <- sortedY[,3]

#### There is a lot going on in here. I've created an order so we can sort the table back into its correct order. the Merge function "joins" the activity key with the actual activities. The CleanY datatable is in the correct order with the full training activities in its place.


### Locate mean and std columns within features

meanc <- str_detect(features[,2], "mean")
stdc <- str_detect(features[,2], "std")                

meanTRUE <- which(meanc==TRUE)
stdTRUE <- which(stdc==TRUE)

meanstd <- c(meanTRUE, stdTRUE)
meanstd <- sort(meanstd)

cleanX <- mergeX[meanstd]

#### the str_detect funcion returns a boolean true or false everytime "mean" or "std" is found. the meanstd dataset includes all the columns where mean and std are found.

### Merge into one combo set (cbind)

combo <- cbind(mergeS,cleanY,cleanX)
colnames(combo)[2]<-"Activity"

### Writes the table as .txt file

write.table(combo, file = "test.txt",row.name=FALSE)
