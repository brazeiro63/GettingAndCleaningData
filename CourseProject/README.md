---
title: "README.md"
output: html_document
---
-

The objective of this README file is to explain the steps taken trhough the analysis automated by means of the script run_analysis.R, available at this repository.

The entire execution of this script is automated and to run it just load the file ***run_analysis.R*** to the working directory of the R environment, where should be present de Samsung file (getdata-projectfiles-UCI HAR Dataset.zip), and source it.
```{r}
source('run_analysis.R')
```

-
The Analysis starts with setting the environment up. At first all the libraries that will be used are loaded in R environment.
```{r}
library(dplyr)
library(data.table)
library(tidyr)
```

As stated in the assignment, the premisse is that the Samsung file is present in the working directory, the next step is uncompress it and save the files using the original path relative to the working directory:
```{r}
unzip("getdata-projectfiles-UCI HAR Dataset.zip")
```

Next, creates variables to hold the paths and file names of the files that will be used in the analysis:
```{r}
## Defining file names to get data
feat_fn <-  "UCI HAR Dataset/features.txt"
train_fn <-  "UCI HAR Dataset/train/X_train.txt"
train_sbjc_fn <-  "UCI HAR Dataset/train/subject_train.txt"
train_actv_fn <-  "UCI HAR Dataset/train/y_train.txt"
test_fn <-  "UCI HAR Dataset/test/X_test.txt"
test_sbjc_fn <-  "UCI HAR Dataset/test/subject_test.txt"
test_actv_fn <-  "UCI HAR Dataset/test/y_test.txt"
actv_labl_fn <-  "UCI HAR Dataset/activity_labels.txt"
```

As the variable names of the data set was stored in a separeted file, load that file and make the feature names available to use in the analysis:
```{r}
##Getting variable names for the train and test raw data
feat_df <- tbl_df(fread(feat_fn))
```
The first step of the analysis is to merge the data of the train and test data. Each of this is composed by three data files. One has the subject identification (subjectID), other has the activity identification (activityID) and the last helds the measurements for all other variables. 
To achieve the step goal, first load all the files into data tables. On loading, the colClasses was set to "numeric" to haldle appropriately the numeric content of the measurement data and the names of the columns were set too. As the column names to the measurement data were stored in "feat_df", the vector feat_df$V2 has it.
```{r}
## Reading and preparing the train and test data
tran_df   <- read.table(train_fn, colClasses = "numeric", col.names = feat_df$V2)
tran_sbjc <- read.table(train_sbjc_fn, col.names = "subjectID")
tran_actv <- read.table(train_actv_fn, col.names = "activityID")
test_df   <- read.table(test_fn,  colClasses = "numeric", col.names = feat_df$V2)
test_sbjc <- read.table(test_sbjc_fn,  col.names = "subjectID")
test_actv <- read.table(test_actv_fn,  col.names = "activityID")
actv_labl <- read.table(actv_labl_fn, col.names = c("id", "name"))
```
Then combine the files in this specific way: 
combine the corresponding files from train and test sets (train subject with test sugject, train activity with test activity and train measurements with test measurements) in this order, then combine the resulting data tables (all subjects, all activities and all measurements) in this order.
Doing this the step 1 is acomplished. The result is saved as "step1" variable.
```{r}
## Merging train and test tables, including subject and activity data
step1 <- cbind(rbind(tran_sbjc, test_sbjc),
               rbind(tran_actv, test_actv),
               rbind(tran_df, test_df))
```

The next step is to extract the subset of columns mean and standard deviation of the data resulting from the previous step.
To achieve this goal were considered "mean" and "standard deviation" columns whose name contains the words "mean()" or "std()".
Since the file containing the names of measures was read with the "fread ()" and non alphanumeric characters have been converted to points, the expression used to select the columns and considered that the terms used were "mean.." and "std..".
At this point has been recovered, also the names of the activities, that is to replace the number in the final result.
```{r}
## Subsetting mean and standard deviation columns
## Changing activityID by activityName (step3)
step2 <- step1 %>%
    select(subjectID, activityID, contains("mean.."), contains("std.."),
           -starts_with("angle")) %>%
    mutate(activityName = actv_labl$name[activityID])
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

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
