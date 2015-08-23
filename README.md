### Intro



### Description of the scripts

# 1. Set up the environment
The following scripts create directory in the current working directory.

    getwd()
    dir.create("TidyProgAss")

The next part sets the new directory as the current working directory and downloads the files.

    setwd("TidyProgAss")
    sourceurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(sourceurl, "dataset.zip", method = "curl")
    unzip("dataset.zip")

# 2. Loading data
Before loading data the next rows set up variables for the files to use.

    testdb_measure <- "UCI HAR Dataset/test/X_test.txt"
    testdb_activity <- "UCI HAR Dataset/test/Y_test.txt"
    traindb_measure <- "UCI HAR Dataset/train/X_train.txt"
    traindb_activity <- "UCI HAR Dataset/train/Y_train.txt"
    features <- "UCI HAR Dataset/features.txt"
    activity <- "UCI HAR Dataset/activity_labels.txt"

Upload data into R.

    db_test <- read.table(testdb_measure)
    label_test <- read.table(testdb_activity)
    db_train <- read.table(traindb_measure)
    label_train <- read.table(traindb_activity)
    desc  <- read.table(activity)
    header  <- read.table(features)

Then I bind the tables together.
First, column bind the activity with the measures.
Then rowbind the two (test and train) into one merged table.

    db_test_full <- cbind(label_test, db_test)
    db_train_full <- cbind(label_train, db_train)
    db_merge <- rbind(db_test_full, db_train_full)

# 3. Creating header
To give useful names for the dataset here I create the column names.
First I create column names for the Activity type table (desc).

    colnames(desc) <- c("Activity", "Activity_name")

Then I create the column names for the merged table.

    h1 <- as.data.frame(cbind(0, "Activity"))
    h2 <- rbind(h1, header)
    v_header <- h2[,2]

I assign the column names to the merged table.

    colnames(db_merge)  <- v_header

Finally, I assign the Activity type table with the merged table.

    db <- merge(desc, db_merge)

# 3. Selecting the necessary columns for calculation
For easily selecting the necessary columns I load dplyr library.

    library(dplyr)
    data <- tbl_df(db)

Then I use select with contains to have the mean and standard deviation columns for all records.
I also use the Activity type name for later spliting.

    data_filtered <- select(data, Activity_name,contains("mean()"), contains("std()"))

# 4. Calculating and storing
At the end I use split and sapply to calculate the means of all variables by Activity type.

    result <- sapply(split(data_filtered, data_filtered$Activity_name), function(x) colMeans(data_filtered[,2:67]))
    
Then - as requested without row names - I write the result into a text file.

    write.table(result, "result.txt", row.names = FALSE)
