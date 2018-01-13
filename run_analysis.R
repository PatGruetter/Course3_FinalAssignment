library(plyr)

setwd("C:/Users/Patrick/Documents/Coursera/DataScience/Assignments/Course3/FinalAssignment")


# Load all relevant data
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test<- read.table("test/subject_test.txt")


# Check dimensions and other characteristics of the data
dim(X_train)
dim(y_train)
dim(subject_train)

dim(X_test)
dim(y_test)
dim(subject_test)

table(subject_train)
table(subject_test)


# (1) Merge train and test for all applicable data, and give column names
subject <- rbind(subject_train, subject_test)
names(subject) <- "subject"

y <- rbind(y_train, y_test)
names(y) <- "activity_id"

X <- rbind(X_train, X_test)
names(X) <- as.character(features$V2)


# (2) Extract only the measurements on the mean and standard deviation for each measurement
X_red <- X[,sort(c(grep("mean\\()", names(X)), grep("std\\()", names(X))))]


# Merge all data to one data set
data <- cbind(subject, y, X_red)

names(data) # check if all columns are named meaningful


# (3) Give descriptive activity names to name the activities in the data set
names(activity_labels) <- c("id","activity")
data_labled <- merge(data, activity_labels, by.x = "activity_id", by.y = "id", all = FALSE)
data_labled <- data_labled[,-1] # get rid off the activity ID "activity_id"


# (4) Appropriate labels were given in each step


# (5) Creating a second, independent tidy data set averaging each variable for each activity AND subject
data_tidy <- aggregate(. ~ subject + activity, data_labled, mean)


write.table(data_tidy, file = "data_tidy.txt", row.names = FALSE)
