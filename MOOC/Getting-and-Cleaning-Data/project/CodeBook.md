Getting-and-Cleaning-Data Codebook
==================================

Data Source
-----------
This dataset is derived from the "Human Activity Recognition Using Smartphones Data Set" which was originally made avaiable here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The actual data for this project is available here in zip format: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

About the Data Set (based on the original README included with the data set)
------------------
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

About the run_analysis.R Script
-------------------------------
The run_analysis.R script tidies the data via the following procedures:

1. Read the training data, labels, and subjects as 'train_data', 'train_label', and 'train_subject'.

2. Read the test data, labels, and subjects as 'test_data', 'test_label', and 'test_subject'. 

3. Read the feature names, and activity id and names as 'feature' and 'activity'.

4. Column names are then assigned to the data sets.
	- 'train_data' and 'test_data' columns receive names based on 'feature'.  
	- 'train_label' and 'test_label' columns are renamed 'activity_id'.
	- 'train_subject' and 'test_subject' columns are renamed 'subject_id'.
	- 'activity' columns are renamed 'activity_id' and 'activity_name'.

5. Merge (via columnbind) 'train_data', 'train_label', and 'train_subject' to create a single data set for training data called 'train_set'.
6. Merge (via columnbind) 'test_data', 'test_label', 'test_subject' to create a single data set for test data called 'test_set'.
7. Merge (via rowbind) 'train_set' and 'test_set' to create the full data set called 'train_test_data'.

8. From 'train_test_data', create a new data set called 'all_data' that only contains columns for 'activity_id', 'subject_id', and measurements of mean and standard deviation.

9. Add 'activity_name' column from 'activity' to 'all_data' by merging on 'activity_id'.  

10. Transform 'subject_id' column from integer to factor.

11. Create 'tidy_data' by aggregating 'all_data' by 'activity_name' and 'subject_id' to derive mean values for each feature.  

12. Remove 'subject_id' and 'activity_name' columns (since they only show NA).

13. Write 'tidy_data' into a csv file 'tidy_data.csv'.





























