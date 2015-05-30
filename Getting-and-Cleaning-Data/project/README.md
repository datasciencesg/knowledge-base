Getting-and-Cleaning-Data
=========================

Introduction
------------
Git Repository for "Getting and Cleaning Data" course project.  It includes the R script, run_analysis.R, that merges data from the Human Activity Recognition Using Smartphones Data Set project to create a csv of average readings for each activity and user.

About the raw data
------------------
There are two data sets: training set and testing set.  

Both data sets contain the following files:
- actual data: X_train.txt / X_test.txt
- data labels: y_train.txt / y_test.txt
- subject ids: subject_train.txt / subject_test.txt

In addition, feature names are found in features.txt while activity id and names are found in activity_labels.txt. 

Using the script
----------------
Before using the script, please extract the UCI HAR Dataset in your working directory.

The script does the following: 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

About the Code Book
-------------------
The CodeBook.md file explains the transformations performed and the resulting data and variables.
