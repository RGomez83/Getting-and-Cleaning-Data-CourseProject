library(plyr)

## Download the data
#############################

filename <- "getdata.zip"

if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
    download.file(fileURL, filename, mode='wb')
} 

if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

## Merge the training and the test sets to create one data set
############################################################################

  ## Read the training and test sets
training_set <- read.table("UCI HAR Dataset/train/X_train.txt")
test_set <- read.table("UCI HAR Dataset/test/X_test.txt")

  ## Merge both sets by rows
training.test_set <- rbind(training_set,test_set)

  ## Add features as column names
features <- read.table("UCI HAR Dataset/features.txt")
names(training.test_set) <- features[,2]


## Extract only the measurements on the mean and standard deviation for each measurement
#############################################################################

training.test.mean.std_set<-training.test_set[ ,grep("mean|std",names(training.test_set))]


## Use descriptive activity names to name the activities in the data set
########################################################################

  ## Read and bind together by rows the training and test labels corresponding to activities
training_labels <- read.table("UCI HAR Dataset/train/y_train.txt")
test_labels <- read.table("UCI HAR Dataset/test/y_test.txt")
training.test_labels <- rbind(training_labels, test_labels)

  ## Assign activity labels 
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_training.test <- join(training.test_labels, activity_labels, match = "first")

  

## Appropriately label the data set with descriptive variable names
######################################################################

  ## Name and add the Activities column to the data set
names(activity_training.test) <- c("v1","Activity")
training.test.mean.std_set <- cbind(activity_training.test, training.test.mean.std_set)
training.test.mean.std_set <- training.test.mean.std_set[,-1]  

  ## Name and add the Subject column to the data set
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(subject_train, subject_test)
names(subject) <- "Subject"
training.test.mean.std_set <- cbind(subject, training.test.mean.std_set)


## From the previous data set, create a second, independent tidy data set with the average of each variable for each activity and each subject
######################################################################################################################################

tidy_data <- aggregate(training.test.mean.std_set[,3:81], by=list(Activity=training.test.mean.std_set$Activity, Subject=training.test.mean.std_set$Subject), mean)

  ## Save tidydata_set as a .txt file
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)


