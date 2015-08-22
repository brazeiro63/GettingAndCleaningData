---
title: "Codebook template"
author: "Paulo Ricardo Brazeiro de Carvalho"
date: "Aug,21 2015"
output:
  html_document:
    keep_md: yes
---

## Project Description
This project has the objective of asses the knowledge acquired along the Getting and Cleaning Data discipline of the Data Science, Specialization Course. Aim to apply the concepts learned in the discipline on how to get data, from various sources, cleaning it, arrange it in the best form given an objective of analysis. In this case, data collected from accelerometer and gyroscope embedded in the smartphone devices were used to calculate a series of variables representing movements made by a group of thirty subjects, while doing a set of regular daily activities. The result must give the average of the measurements for each subject at each activity.

##Study design and data processing
"The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data." 

"The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain."

###Collection of the raw data
For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:

- 'README.txt'
- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent.   

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.   
- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.  
- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration.   
- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

###Notes on the original (raw) data 
- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.

##Creating the tidy datafile

###Guide to create the tidy data file
1. download the data file, from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]
2. save the .zip file in the R working directory
3. load in the R environmentthe script run_analysis.R from [https://github.com/brazeiro63/GettingAndCleaningData/blob/master/CourseProject/run_analysis.R]
4. run the script `source(run_analysis.R)`
5. the script will generate the tidy data doing the following: 
  + unzip the compressed data files,  
  + load data from text files: 
    + activity_labels.txt
    + X_train.txt
    + y_train.txt
    + subject_train.txt
    + X_test.txt
    + y_test.txt
    + subject_test.txt
  + merge subject_train and subject_test, y_train and y_test, X_train and X_test, to form a single data set.
  + name the columns accordingly;
  + select the columns with means and standard deviations; 
  + gather the measurement columns in a single column named measurement_domain;

###Cleaning of the data
The cleaning process is just summarize the observations into the average for each subject and activity. Further detail available in the [README.md](https://github.com/brazeiro63/GettingAndCleaningData/blob/master/CourseProject/README.md)


##Description of the variables in the step5ResultFile.txt file

General description of the file including: 

- Dimensions of the dataset  
- Summary of the data  
- Variables present in the dataset  
 
(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)

###Variable 1 (repeat this section for all variables in the dataset)
Short description of what the variable describes.

Some information on the variable including:
 - Class of the variable
 - Unique values/levels of the variable
 - Unit of measurement (if no unit of measurement list this as well)
 - In case names follow some schema, describe how entries were constructed (for example time-body-gyroscope-z has 4 levels of descriptors. Describe these 4 levels). 

(you can easily use Rcode for this, just load the dataset and provide the information directly form the tidy data file)

####Notes on variable 1:
If available, some additional notes on the variable not covered elsewehere. If no notes are present leave this section out.

##Sources
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

##Annex
If you used any code in the codebook that had the echo=FALSE attribute post this here (make sure you set the results parameter to 'hide' as you do not want the results to show again)