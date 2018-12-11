library(dplyr)
library(data.table)
setwd("C:/Users/Ari Ginsburg/Getting-and-Cleaning-Data-Course-Project")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "dataset.zip")
unzip("dataset.zip")

activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")

#read in test
test<-read.table("UCI HAR Dataset/test/x_test.txt")
test_labels<-read.table("UCI HAR Dataset/test/y_test.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
#variable names
names(test)<-features$V2

#4 use descriptiive activity names
test$subject<-subject_test$V1
test$activity<-test_labels$V1

#read in train
train<-read.table("UCI HAR Dataset/train/x_train.txt")
train_labels<-read.table("UCI HAR Dataset/train/y_train.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")

#4 use descriptiive activity names
names(train)<-features$V2
#train subject and activities
train$subject<-subject_train$V1
train$activity<-train_labels$V1

#1 merge training and test
joined <- rbind(test,train)

#2 extract only measurements on mean and standard deviaiton
joined<-joined[,c(grep("mean\\(\\)",names(joined),value=TRUE),grep("std\\(\\)",names(joined),value=TRUE),"subject","activity")]

#3 use descriptive activity names
joined<-joined %>% left_join(activity_labels, by=c("activity"="V1"))
joined$activity<-NULL
names(joined)[names(joined)=="V2"]<-"Activity"
joined$Activity <- as.character(joined$Activity)
joined <- as.data.table(joined)

#5 average for each variable by subject and activity
tidy<-aggregate(joined[,-c(67,68)],by=list(subject=joined$subject,Activity=joined$Activity),mean)

write.csv(tidy,"finished tidy data.csv",row.names=F)