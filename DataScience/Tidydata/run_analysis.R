##  1. Obtain data and merge the training and test set to creat one database. 
##    Download file and save to local directory and then unzip file.
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "~/DataScience/Tidy&Cleaning/HARdataset.zip", mode = "wb")
unzip("HARdataset.zip", exdir = getwd())

## UCI HAR Dataset - read the Test data (X, Y and Subject Tests)
xTest <- read.table("UCI HAR Dataset/test/X_test.txt")
yTest <- read.table("UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

## UCI HAR Dataset - read the Train data (X, Y and Subject Training)
xTrain <- read.table("UCI HAR Dataset/train/X_train.txt")
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subjectTrain <-read.table("UCI HAR Dataset/train/subject_train.txt")

## UCI HAR Dataset - read the activity labels and features
activity<-read.table("UCI HAR Dataset/activity_labels.txt")
features<-read.table("UCI HAR Dataset/features.txt")


## the function rbind is used to merge the xtest and xtrain data to in one dataset,
## the ytest and ytrain in to another and then the subjecttest and subject train 
## into another set, creating three sets of data.
x <- rbind(xTest, xTrain)
y <- rbind(yTest, yTrain)
Subject <- rbind(subjectTest, subjectTrain)

## 2. Extract only the measurements on the mean and standard deviation for each 
##    measurement.

## obtaining the indices for the features which contains only the mean and standard deviation
featuresindices <- grep("mean\\(\\)|std\\(\\)", features[,2])
length(featuresindices)
 x <- x[,featuresindices]
 dim(x)
 
## 3. Use descriptive activity names to name the activities in the data set
## the function below, replaces the values in y with the lookup value from the activity.txt 
 y[,1]<-activity[y[,1],2] 
head(y) 

## 4. Appropriately label he data set with descriptive variable names.
## to get the names the functions was used below which also updating colNames for new dataset.
names<-features[featuresindices,2]

names(x) <- names
names(Subject) <- "subject"
names(y) <- "activity"

## we combine all three data sets to make one data set
finalData <- cbind(Subject, y, x)


## to see the data this function was used
head(finalData[,c(1:4)])

## 5. Create a second, independent tidy data set with the 
## averages of each variable for each activity and each subject from the data set in 4.

finalData<-data.table(finalData)

## features variable averaged by Subject and by activity
final2Data <- finalData[, lapply(.SD, mean), by = 'subject,activity']
dim(final2Data)

write.table(final2Data, file = "Readydata.txt", row.names = FALSE)

head(final2Data[order(subject)][,c(1:4), with = FALSE],12)
