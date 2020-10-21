#Getting and Cleaning Data Course Project - JHU - ALVARO LOZANO ALONSO

library(dplyr)

URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
setwd("~/Documentos Offline/Data Science with R - Johns Hopkins University/JUH_Getting_and_Cleaning_Data_Project")
if(!file.exists("Dataset.zip")) download.file(url = URL, destfile = "Dataset.zip")
if(!file.exists("./UCI_HAR_Dataset")) unzip("Dataset.zip")

dateDownloaded <- date()

setwd('./UCI HAR Dataset')

activityLabels <- read.table("activity_labels.txt", col.names = c("n", "activityLabel"))

features <- read.table("features.txt", col.names = c("n", "features"))

y_train <- read.table("./train/y_train.txt", col.names = "label")
x_train <- read.table("./train/X_train.txt", col.names = features$features)
subject_train <- read.table("./train/subject_train.txt", col.names = "subject")

y_test <- read.table("./test/y_test.txt", col.names = "label")
x_test <- read.table("./test/X_test.txt", col.names = features$features)
subject_test <- read.table("./test/subject_test.txt", col.names = "subject")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)

subject <- rbind(subject_train, subject_test)

rm(subject_test, subject_train)
rm(x_test, x_train, y_test, y_train)

global_df <- cbind(X, Y)
global_df <- cbind(global_df, subject)
global_df$label <- activityLabels[global_df$label, "activityLabel"]

subsetMeanSD <- global_df %>% select(label, subject, contains("mean"), contains("std"))

names(subsetMeanSD) <- gsub("Acc", "Accelerometer", names(subsetMeanSD))
names(subsetMeanSD) <- gsub("Gyro", "Gyroscope", names(subsetMeanSD))
names(subsetMeanSD) <- gsub("BodyBody", "Body", names(subsetMeanSD))
names(subsetMeanSD) <- gsub("Mag", "Magnitude", names(subsetMeanSD))
names(subsetMeanSD) <- gsub("^t", "Time", names(subsetMeanSD))
names(subsetMeanSD) <- gsub("^f", "Frequency", names(subsetMeanSD))
names(subsetMeanSD) <- gsub("tBody", "TimeBody", names(subsetMeanSD))
names(subsetMeanSD) <- gsub("-mean()", "Mean", names(subsetMeanSD), ignore.case = TRUE)
names(subsetMeanSD) <- gsub("-std()", "STD", names(subsetMeanSD), ignore.case = TRUE)
names(subsetMeanSD) <- gsub("-freq()", "Frequency", names(subsetMeanSD), ignore.case = TRUE)
names(subsetMeanSD) <- gsub("angle", "Angle", names(subsetMeanSD))
names(subsetMeanSD) <- gsub("gravity", "Gravity", names(subsetMeanSD))
names(subsetMeanSD) <- gsub("Freq", "Frequency", names(subsetMeanSD))
names(subsetMeanSD) <- gsub("std", "StandardDeviation", names(subsetMeanSD))

Final_DataFrame <- subsetMeanSD %>% 
                   group_by(subject, label) %>% 
                   summarise_all(list(mean))

