Getting and Cleaning Data

Data Details

The script that was made "run_analysis.R" was created to clean, tidy and create one dataset, steps as follows:

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can 
be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 
1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes 
the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md 
in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and 
Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected 
from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

	http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

	https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip




The script used to execute the process to obtain the tidy and clean data set.


##  1. Obtain data and merge the training and test set to creatE one database. 

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

## Obtaining the indices for the features which contains only the mean and standard deviation
	featuresindices <- grep("mean\\(\\)|std\\(\\)", features[,2])
	length(featuresindices)
	x <- x[,featuresindices]
	dim(x)

 
## 3. Use descriptive activity names to name the activities in the data set.

## The function below, replaces the values in y with the lookup value from the activity.txt 
 
	y[,1]<-activity[y[,1],2] 
		 

## 4. Appropriately label he data set with descriptive variable names.
## to get the names the functions was used below which also updating colNames for new dataset.
	names<-features[featuresindices,2]
	names(x) <- names
	names(Subject) <- "subject"
	names(y) <- "activity"

## We combine all three data sets to make one data set,
	finalData <- cbind(Subject, y, x)

## To see the data this function was used,
	head(finalData[,c(1:4)])


## 5. Create a second, independent tidy data set with the averages of each variable for each activity and each subject from the data set in 4.
	install.packages("data.table")
	library(data.table)

	finalData<-data.table(finalData)

## features variable averaged by Subject and by activity
	final2Data <- finalData[, lapply(.SD, mean), by = 'subject,activity']
	dim(final2Data)

	write.table(final2Data, file = "Readydata.txt", row.names = FALSE)

	head(final2Data[order(subject)][,c(1:4), with = FALSE],12)



All steps have to be followed as each step is dependent on the previous step being carried out correctly and successfully. 

Careme Carty
