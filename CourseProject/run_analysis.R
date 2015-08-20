library(dplyr)
library(data.table)
library(tidyr)

## Uncompressing file in the working directory
unzip("getdata-projectfiles-UCI HAR Dataset.zip")

## Defining file names to get data
feat_fn <-  "UCI HAR Dataset/features.txt"
train_fn <-  "UCI HAR Dataset/train/X_train.txt"
train_sbjc_fn <-  "UCI HAR Dataset/train/subject_train.txt"
train_actv_fn <-  "UCI HAR Dataset/train/y_train.txt"
test_fn <-  "UCI HAR Dataset/test/X_test.txt"
test_sbjc_fn <-  "UCI HAR Dataset/test/subject_test.txt"
test_actv_fn <-  "UCI HAR Dataset/test/y_test.txt"
actv_labl_fn <-  "UCI HAR Dataset/activity_labels.txt"

##Getting variable names for the train and test raw data
feat_df <- tbl_df(fread(feat_fn))

## Reading and preparing the train and test data
tran_df   <- read.table(train_fn, colClasses = "numeric", col.names = feat_df$V2)
tran_sbjc <- read.table(train_sbjc_fn, col.names = "subjectID")
tran_actv <- read.table(train_actv_fn, col.names = "activityID")
test_df   <- read.table(test_fn,  colClasses = "numeric", col.names = feat_df$V2)
test_sbjc <- read.table(test_sbjc_fn,  col.names = "subjectID")
test_actv <- read.table(test_actv_fn,  col.names = "activityID")
actv_labl <- read.table(actv_labl_fn, col.names = c("id", "name"))

## Merging train and test tables, including subject and activity data
step1 <- cbind(rbind(tran_sbjc, test_sbjc),
               rbind(tran_actv, test_actv),
               rbind(tran_df, test_df))

## Subsetting mean and standard deviation columns
## Changing activityID by activityName (step3)
step2 <- step1 %>%
    select(subjectID, activityID, contains("mean.."), contains("std.."),
           -starts_with("angle")) %>%
    mutate(activityName = actv_labl$name[activityID])


## Changing column names to other more descriptive
step4 <- copy(step2)
names(step4) <- gsub("\\.","_",gsub("\\.\\.","",names(step2)))
tmp1 <-names(step4)
tmp <- sapply(tmp1[3:68],function(x){x<-sub("t","time",x)})
tmp <- sapply(tmp,function(x){x<-sub("f","frequency",x)})
tmp <- sapply(tmp,function(x){x<-sub("Acc","Accelaration",x)})
tmp <- sapply(tmp,function(x){x<-sub("_mean","Mean",x)})
tmp <- sapply(tmp,function(x){x<-sub("_std","StandardDeviation",x)})
tmp <- sapply(tmp,function(x){x<-sub("_stimed","StandardDeviation",x)})
tmp <- sapply(tmp,function(x){x<-sub("BodyBody","Body",x)})
tmp1[3:68]<-tmp
names(step4) <- tmp1

## Tidying data
step5 <- step4 %>%
  select(subjectID, activityName,
         timeBodyAccelarationMean_X:frequencyBodyGyroJerkMagStandardDeviation) %>%
  gather(measureDomain, value,
         timeBodyAccelarationMean_X:frequencyBodyGyroJerkMagStandardDeviation)%>%
  group_by(subjectID, activityName, measureDomain) %>%
  summarise(averageValue = mean(value))

## Writing resulting file
write.table(step5, file = "step5ResultFile.txt", row.names = FALSE)
