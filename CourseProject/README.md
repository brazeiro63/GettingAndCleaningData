---
title: "README.md"
author: "Paulo Ricardo Brazeiro de Carvalho"
date: "Aug,21 2015"
output: 
  html_document
  keep_md:TRUE
---


The purpose of this README file is to explain the steps performed by the automated processing of data using the script "run_analysis.R" available in this repository.

The entire execution of this script is automated and to run it simply load the file "run_analysis.R" for the R environment working directory, where it should be present Samsung's file (GetData-PROJECTFiles UCI-HAR Dataset.zip), and source it.  

```{r}
source('run_analysis.R')
```

-
The analysis begins with the environment setup. First, all libraries that are used are loaded into the R environment.  

```{r,echo=TRUE}
library(dplyr)
library(data.table)
library(tidyr)
```

As stated in the assignment, the premise is that the Samsung's file is present in the working directory. The next step is to unzip it and save the files using the original path in the structure of the compressed file. This path is a path relative to the working directory:  

```{r,echo=TRUE}
unzip("getdata-projectfiles-UCI HAR Dataset.zip")
```

Next, we create the variables that will keep the paths and names of data files that will be used in the analysis:  

```{r,echo=TRUE}
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

```{r,echo=TRUE}
##Getting variable names for the train and test raw data
feat_df <- tbl_df(fread(feat_fn))
```
The first step of the analysis is to merge the data of the train and test data. Each of this is composed by three data files. One has the subject identification (subject_id), other has the activity identification (activity_id) and the last helds the measurements for all other variables. 
To achieve the step goal, first load all the files into data tables. On loading, the colClasses was set to "numeric" to haldle appropriately the numeric content of the measurement data and the names of the columns were set too. As the column names to the measurement data were stored in "feat_df", the vector feat_df$V2 has it.

```{r,echo=TRUE}
## Reading and preparing the train and test data
tran_df   <- read.table(train_fn, colClasses = "numeric", col.names = feat_df$V2)
tran_sbjc <- read.table(train_sbjc_fn, col.names = "subject_id")
tran_actv <- read.table(train_actv_fn, col.names = "activity_id")
test_df   <- read.table(test_fn,  colClasses = "numeric", col.names = feat_df$V2)
test_sbjc <- read.table(test_sbjc_fn,  col.names = "subject_id")
test_actv <- read.table(test_actv_fn,  col.names = "activity_id")
actv_labl <- read.table(actv_labl_fn, col.names = c("id", "name"))
```
Then combine the files in this specific way: 
combine the corresponding files from train and test sets (train subject with test sugject, train activity with test activity and train measurements with test measurements) in this order, then combine the resulting data tables (all subjects, all activities and all measurements) in this order.
Doing this the step 1 is acomplished. The result is saved as "step1" variable.

```{r,echo=TRUE}
## Merging train and test tables, including subject and activity data
step1 <- cbind(rbind(tran_sbjc, test_sbjc),
               rbind(tran_actv, test_actv),
               rbind(tran_df, test_df))
```

The next step is to extract the subset of columns mean and standard deviation of the data resulting from the previous step.
To achieve this goal were considered "mean" and "standard deviation" columns whose name contains the words "mean()" or "std()".
Since the file containing the names of measures was read with the "fread ()" and non alphanumeric characters have been converted to points, the expression used to select the columns and considered that the terms used were "mean.." and "std..".
At this point has been recovered, also the names of the activities, that is to replace the number in the final result.

```{r,echo=TRUE}
## Subsetting mean and standard deviation columns
## Changing activity_id by activity_name (step3)
step2 <- step1 %>%
    select(subject_id, activity_id, contains("mean.."), contains("std.."),
           -starts_with("angle")) %>%
    mutate(activity_name = actv_labl$name[activity_id])
```
The task instructions specify that you need to assign more meaningful names for the columns. One way to read the data file would be without assigning names to the columns, which would result in the assignment of standardized names (V1 to Vn). However, reading the measurements file, they were assigned names to the columns based on the file "features.txt". Thus the column names already have meaning in the field of data. The meaning of each term used in the names of the columns is described in the code book.
The legibility and meaning of the column names was affected by the substitution of characters mentioned above. To fix the problem simply replace the dots (".") By other tabs more appropriate to read, to make it more enjoyable. In this case, underscores ("_").

```{r,echo=TRUE}
## Changing column names to other more descriptive
step4 <- copy(step2)
names(step4) <- gsub("\\.","_",gsub("\\.\\.","",names(step2)))
```
The final part of the task is to make the data tidy. For the tidying of data following procedures were performed: first the columns which must be part of the final result, which are subject_id, activity_name and the remaining columns (3 to 68) were selected. The columns 3 to 68 correspond to the domains of measurements which were performed in the experiment. Then the data were grouped by the subject_id, activity_name and measurementDomain and was calculated the average of the values for each group and the result was stored in the column average_value.
At this point the data was considered tidy, once each column represents one variable, and each row has an specific measurement. In the case, the average value of the measurements for each domain.
To do this were used the function of tidyr package as follows:

```{r,echo=TRUE}
## Tidying data
step5 <- step4 %>%
  select(subject_id, activity_name, 3:68) %>%
  gather(measure_domain, value, 3:68)%>%
  group_by(subject_id, activity_name, measure_domain) %>%
  summarise(average_value = mean(value))
```
Finaly the resulting file was write, without row names, as stated on the assignment.

```{R,echo=TRUE}
## Writing resulting file
write.table(step5, file = "step5ResultFile.txt", row.names = FALSE)
```
