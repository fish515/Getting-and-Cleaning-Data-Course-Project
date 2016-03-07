library(datasets)
library(reshape2)

x_train<-read.table("train/X_train.txt")
y_train<-read.table("train/y_train.txt")
subject_train<-read.table("train/subject_train.txt")
x_test<-read.table("test/X_test.txt")
y_test<-read.table("test/y_test.txt")
subject_test<-read.table("test/subject_test.txt")


x_data<-rbind(x_train,x_test)
ydata<-rbind(y_train,y_test)
subdata<-rbind(subject_train,subject_test)

##2Extracts only the measurements on the mean and standared deviation for each measurement.
feature<-read.table("features.txt")
##get the column needed for the mean and deviation
col_mean_dev<-grep("-(mean|std)", feature[, 2])
featurename<-feature[col_mean_dev,2]
##apply the column to x datasets
xdata<-x_data[,col_mean_dev]
all_data<-cbind(subdata,ydata,xdata)

##3.Uses descriptive activity names to name the activities in the data set
activity_label<-read.table("activity_labels.txt")
## extract the activity number and transfer it to the name 
ydata[, 2] <- activity_label[ydata[, 1], 2]
##4. Appropriately labels the data set with descriptive variable names.

colnames(all_data)<-c("subject","activity",featurename)
##5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Turn activity and subject into factors
all_data$activity<-factor(all_data$activity,levels=activity_label[,1],labels=activity_label[,2])
all_data$subject<-as.factor(all_data$subject)
alldatamelt <- melt(all_data, id = c("subject", "activity"))
tidydata<-dcast(alldatamelt,subject+activity~variable,mean)
write.table(tidydata,"tidyData.txt",row.names = FALSE)
