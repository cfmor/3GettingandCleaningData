# 3GettingandCleaningData
This is the repository for the third course of coursera's Data Science Specialization.

It has the following related files:
-run_analysis.R (File containing the script to process the raw data and get the tidy data.)
-tidy_dataset.txt (File containing the resulting tidy dataset.)
-CodeBook.md (File explaining the different variables in the datasets.)

The run_analysis runs only with provided data from the UCI repository (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) is in the same working directory.
This scripts does the following tasks:
1. Retrieves the variable names, subject and activity names; loads the train and test data sets.
2. Merges together the names, subject and activity names in both a train and a test data sets.
3. Merges together the train and test data sets.
4. Names activity names with a label.
5. Gets only the variables of interest (mean and standard deviation).
6. Groups the data by subject and activity and calculates the average values for each group.
7. Writes in a file the resulting data set (tidy_dataset.txt).