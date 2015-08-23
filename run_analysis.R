getwd()
dir.create("TidyProgAss")
setwd("TidyProgAss")
sourceurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(sourceurl, "dataset.zip", method = "curl")
unzip("dataset.zip")

testdb_measure <- "UCI HAR Dataset/test/X_test.txt"
testdb_activity <- "UCI HAR Dataset/test/Y_test.txt"
traindb_measure <- "UCI HAR Dataset/train/X_train.txt"
traindb_activity <- "UCI HAR Dataset/train/Y_train.txt"
features <- "UCI HAR Dataset/features.txt"
activity <- "UCI HAR Dataset/activity_labels.txt"

db_test <- read.table(testdb_measure)
label_test <- read.table(testdb_activity)
db_train <- read.table(traindb_measure)
label_train <- read.table(traindb_activity)

desc  <- read.table(activity)
colnames(desc) <- c("Activity", "Activity_name")

header  <- read.table(features)
h1 <- as.data.frame(cbind(0, "Activity"))
h2 <- rbind(h1, header)

db_test_full <- cbind(label_test, db_test)
db_train_full <- cbind(label_train, db_train)

db_merge <- rbind(db_test_full, db_train_full)
v_header <- h2[,2]
colnames(db_merge)  <- v_header

db <- merge(desc, db_merge)

library(dplyr)
data <- tbl_df(db)
data_filtered <- select(data, Activity_name,contains("mean()"), contains("std()"))

result <- sapply(split(data_filtered, data_filtered$Activity_name), function(x) colMeans(data_filtered[,2:67]))
write.table(result, "result.txt", row.names = FALSE)
