library(dplyr)
library(data.table)
library(tidyr)

##Getting variable names for the train and test raw data
feat_df <- tbl_df(fread("UCI HAR Dataset/features.txt"))

## Reading and preparing the train and test data frame 
tran_df <- read.table("UCI HAR Dataset/train/X_train.txt", colClasses = "numeric", col.names = feat_df$V2)
test_df <- read.table("UCI HAR Dataset/test/X_test.txt",   colClasses = "numeric", col.names = feat_df$V2)

# Subsetting train and test data with mean and standard deviation columns
tran_df_ss <-  select(tran_df, contains("mean.."), contains("std.."), -starts_with("angle"))
test_df_ss <-  select(test_df, contains("mean.."), contains("std.."), -starts_with("angle"))

## getting subjectID and activityID data for train and test
tran_sbjc <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subjectID") 
tran_actv <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activityID")
test_sbjc <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subjectID") 
test_actv <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activityID")


## Adding subjectID, activityID, and observationType columns 
## to both train and test table data frames
tran_dft_ss <- tbl_df(cbind(tran_sbjc, 
                            tran_actv, 
                            tran_df_ss)) %>% 
               mutate(observationType = "train")

test_dft_ss <- tbl_df(cbind(test_sbjc, 
                            test_actv, 
                            test_df_ss)) %>% 
               mutate(observationType = "test")

## Joining the two table data frames together
full_dft <- tbl_df(rbind(tran_dft_ss, test_dft_ss) )

## Cleaning collumn names
names(full_dft) <- gsub("\\.","_",gsub("\\.\\.","",names(full_dft)))

## Tiding the first part of the data frame
## collumns that has three parts names
part_1 <- full_dft %>% 
	select(subjectID, activityID, observationType, ends_with("X"), ends_with("Y"), ends_with("Z")) %>%
	gather( measureDomain, value, tBodyAcc_mean_X:fBodyGyro_std_Z)%>%
	separate(measureDomain, c("measureDomainName", "measureType", "axis")) %>%
	mutate(measureType = paste(measureType, axis, sep="-"), axis = NULL)

## Tiding the second part of the data frame
## collumns that has two parts names
part_2 <- full_dft %>% 
	select(subjectID, activityID, observationType, ends_with("mean"), ends_with("std")) %>%
	gather( measureDomain, value, tBodyAccMag_mean:fBodyBodyGyroJerkMag_std) %>%
	separate(measureDomain, c("measureDomainName", "measureType"))

## Joining the final result and sorting the rows
full_final <- rbind(part_1,part_2) %>% 
	arrange(subjectID, activityID, observationType, measureDomainName, measureType)

## Writing the result txt file
write.table(full_final, "result.txt")

## Sampling the result to console
full_final
tail(full_final, 10)

