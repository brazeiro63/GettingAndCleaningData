library(dplyr)
library(data.table)

##Getting variable names for the train and test raw data
feat_dft <- tbl_df(fread("UCI HAR Dataset/features.txt"))

## Reading and preparing the train data frame table
tran_dft <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))

# setting the column names
colnames(tran_dft) <- paste(feat_dft$V1, feat_dft$V2)

# Selecting the mean and standard deviation columns
tran_dft <-  select(tran_dft, contains("mean()"), contains("std()"))

## getting subject and activity data
tran_sbjc <- read.table("UCI HAR Dataset/train/subject_train.txt", 
				col.names = "subject") 
tran_actv <- read.table("UCI HAR Dataset/train/y_train.txt", 
				col.names = "activity")
#colnames(tran_sbjc) <- "Subject"
#colnames(tran_actv) <- "Activity"

## Adding subject and activity columns to table data frame
tran_dft <- cbind(tran_sbjc, tran_actv, tran_dft)



fTest <- "UCI HAR Dataset/test/X_test.txt"
test_dft <- tbl_df(read.table(fTest))
colnames(test_dft) <- paste(feat_dft$V1, feat_dft$V2)
test_dft <-  select(test_dft, contains("mean()"), contains("std()"))

m <- rbind(tran_dft, test_dft)