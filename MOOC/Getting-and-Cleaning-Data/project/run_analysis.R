

##################################################################
# 1. Merges the training and the test sets to create one data set.
##################################################################

# read training data
train_data <- read.table('./UCI HAR Dataset/train/X_train.txt')
train_label <- read.table('./UCI HAR Dataset/train/y_train.txt')
train_subject <- read.table('./UCI HAR Dataset/train/subject_train.txt')

# read test data
test_data <- read.table('./UCI HAR Dataset/test/X_test.txt')
test_label <- read.table('./UCI HAR Dataset/test/y_test.txt')
test_subject <- read.table('./UCI HAR Dataset/test/subject_test.txt')

# read headers: feature and activity label
feature <- read.table('./UCI HAR Dataset/features.txt')
activity <- read.table('./UCI HAR Dataset/activity_labels.txt')

# assign proper column names
colnames(train_data) <- feature[,2]
colnames(train_label) <- 'activity_id'
colnames(train_subject) <- 'subject_id'
colnames(test_data) <- feature[,2]
colnames(test_label) <- 'activity_id'
colnames(test_subject) <- 'subject_id'
colnames(activity) <- c('activity_id', 'activity_name')

# merge train_data, train_label, and train_subject to create train_set
train_set <- cbind(train_label, train_subject, train_data)

# merge test_data, test_label, and test_subject to create test_set
test_set <- cbind(test_label, test_subject, test_data)

# merge train_set and test_data to create all_data
train_test_data <- rbind(train_set, test_set)

##################################################################
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##################################################################

# keep activity_id, subject_id, mean, and sd
all_data <- train_test_data[c('activity_id', 'subject_id')]
all_data <- cbind(all_data, train_test_data[grep('mean\\(\\)|std\\(\\)', colnames(train_test_data))])

##################################################################
# 3. Uses descriptive activity names to name the activities in the data set
##################################################################

# add activity_name column to name the activities in the data set
all_data <- merge(all_data, activity, by = 'activity_id', all.x = T)

##################################################################
# 4. Appropriately labels the data set with descriptive variable names. 
##################################################################

# Done in Step 1: Assign proper column names

##################################################################
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
##################################################################

# convert subject_id into a factor
all_data$subject_id <- as.factor(all_data$subject_id)

# aggregate by activity and subject
tidy_data <- aggregate(all_data, by = list(activity = all_data$activity_name, subject = all_data$subject_id), mean)

# remove redundant subject_id and activity_name columns
tidy_data <- subset(tidy_data, select = -c(subject_id, activity_name))
View(tidy_data)

# export the data as csv
write.csv(tidy_data, file="tidy_data.csv" )
