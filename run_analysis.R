library(dplyr)
filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Merge the training and the test sets to create one data set.
feat <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
acti <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
s_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
s_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
S <- rbind(s_train, s_test)
d_f <- cbind(S, Y, X)
# Extracts only the measurements on the mean and standard deviation for each measurement. 
d_f2 <- d_f %>% select(subject, code, contains("mean"), contains("std"))

# Uses descriptive activity names to name the activities in the data set
d_f2$code <- activities[d_f2$code,2]

# Appropriately labels the data set with descriptive variable names. 
names(d_f2)[2] = "activity"
names(d_f2)<-gsub("Acc", "Accelerometer", names(d_f2))
names(d_f2)<-gsub("Gyro", "Gyroscope", names(d_f2))
names(d_f2)<-gsub("BodyBody", "Body", names(d_f2))
names(d_f2)<-gsub("Mag", "Magnitude", names(d_f2))
names(d_f2)<-gsub("^t", "Time", names(d_f2))
names(d_f2)<-gsub("^f", "Frequency", names(d_f2))
names(d_f2)<-gsub("tBody", "TimeBody", names(d_f2))
names(d_f2)<-gsub("-mean()", "Mean", names(d_f2), ignore.case = TRUE)
names(d_f2)<-gsub("-std()", "STD", names(d_f2), ignore.case = TRUE)
names(d_f2)<-gsub("-freq()", "Frequency", names(d_f2), ignore.case = TRUE)
names(d_f2)<-gsub("angle", "Angle", names(d_f2))
names(d_f2)<-gsub("gravity", "Gravity", names(d_f2))



# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

FinalData <- d_f2 %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)