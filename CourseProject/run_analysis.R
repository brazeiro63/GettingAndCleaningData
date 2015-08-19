library(dplyr)
library(data.table)

##Getting variable names for the train and test raw data
feat_df <- tbl_df(fread("UCI HAR Dataset/features.txt"))

## Reading and preparing the train and test data frame 
#tran_df <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt", colClasses = "numeric", col.names = feat_df$V2))
#test_df <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt",   colClasses = "numeric", col.names = feat_df$V2))

tran_df <- read.table("UCI HAR Dataset/train/X_train.txt", colClasses = "numeric", col.names = feat_df$V2)
test_df <- read.table("UCI HAR Dataset/test/X_test.txt",   colClasses = "numeric", col.names = feat_df$V2)

# Subsetting train and test data with mean and standard deviation columns
tran_df_ss <-  select(tran_df, contains("mean.."), contains("std.."))
test_df_ss <-  select(test_df, contains("mean.."), contains("std.."))

## getting subject and activity data for train and test
tran_sbjc <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject") 
tran_actv <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity")
test_sbjc <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject") 
test_actv <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity")


## Adding subject, activity, and observationType columns to table data frames
tran_dft_ss <- tbl_df(cbind(tran_sbjc, tran_actv, tran_df_ss))
tran_dft_ss <- mutate(tran_dft_ss, obsType = "train")
test_dft_ss <- tbl_df(cbind(test_sbjc, test_actv, test_df_ss))
test_dft_ss <- mutate(test_dft_ss, obsType = "test")

## Merging the two table data frames together
full_dft <- full_join(tran_dft_ss, test_dft_ss) 

