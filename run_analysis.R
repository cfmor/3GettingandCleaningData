# One of the most exciting areas in all of data science right now is wearable 
# computing - see for example this article . Companies like Fitbit, Nike, and 
# Jawbone Up are racing to develop the most advanced algorithms to attract new 
# users. The data linked to from the course website represent data collected from 
# the accelerometers from the Samsung Galaxy S smartphone. A full description is 
# available at the site where the data was obtained:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
# 
# Here are the data for the project:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
# 
# Packages.
library(dplyr)
library(reshape2)

# You should create one R script called run_analysis.R that does the following: 

#### Merges the training and the test sets to create one data set. ####
# Loads the variable names and the activity names. Filtering the needed means and
# standard deviation for the needed variable names.
activities <- data.table::fread("UCI HAR Dataset/activity_labels.txt", 
                                col.names=c("id", "activity"))
varNames <- data.table::fread("UCI HAR Dataset/features.txt", 
                              col.names=c("index", "featureNames"))

#### Extracts only the measurements on the mean and standard deviation for each measurement. ####
neededVars <- grep("(mean|std)\\(\\)", varNames[,featureNames])
records <- varNames[neededVars, featureNames]
records <- gsub("[()]", "", records)

# Retrieves the train data.
train_data <- data.table::fread("UCI HAR Dataset/train/X_train.txt")[, neededVars, 
                                                                     with=FALSE]
data.table::setnames(train_data, colnames(train_data), records)
activity <- data.table::fread("UCI HAR Dataset/train/y_train.txt", 
                              col.names="activity")
subject <- data.table::fread("UCI HAR Dataset/train/subject_train.txt", 
                             col.names="subject")
train_data <- cbind(subject, activity, train_data)

# Retrieves the test data.
test_data <- data.table::fread("UCI HAR Dataset/test/X_test.txt")[, neededVars, 
                                                                  with=FALSE]
data.table::setnames(test_data, colnames(test_data), records)
activity <- data.table::fread("UCI HAR Dataset/test/y_test.txt", 
                              col.names="activity")
subject <- data.table::fread("UCI HAR Dataset/test/subject_test.txt", 
                             col.names="subject")
test_data <- cbind(subject, activity, test_data)

dataset <- rbind(train_data, test_data)

#### Uses descriptive activity names to name the activities in the data set. ####
dataset[["activity"]] <- factor(dataset[, activity], 
                                levels=activities[["id"]],
                                labels=activities[["activity"]])

#### Appropriately labels the data set with descriptive variable names. ####
dataset[["subject"]] <- as.factor(dataset[, subject])

# From the data set in step 4, creates a second, independent tidy data set with 
#### the average of each variable for each activity and each subject.####
# Calculate the average of each subject-activity group.
tidy_dataset <- reshape2::melt(data=dataset, 
                               id=c("subject", "activity"))
tidy_dataset <- reshape2::dcast(data=tidy_dataset, 
                                subject + activity ~ variable, 
                                fun.aggregate=mean)

# Store resulting data set into a readable file.
data.table::fwrite(tidy_dataset, "tidy_dataset.txt", quote=FALSE)
