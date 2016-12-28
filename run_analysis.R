#This file gets the data from the web, merges only the relevant information and gets all the means into one table

#Gets the data and unzipped it:
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "GettingAndCleaning.zip")
unzip("GettingAndCleaning.zip")

#Reads the activity and features data:
Activity <- read.table("UCI HAR Dataset/activity_labels.txt")
Activity[,2] <- as.character(Activity[,2])
Features <- read.table("UCI HAR Dataset/features.txt")
Features[,2] <- as.character(Features[,2])

#Filters only the relevant features, mean and std, and changes their names so they will be more tidy:
TempFeatures1 <- grep(".*mean.*|.*std.*", Features[,2])
TempFeatures2 <- grep(".*meanFreq.*", Features[,2], invert = TRUE)      #Removes cases with the word mean which are not the the mean
RelevantFeaturesLocations <- intersect(TempFeatures1, TempFeatures2)
RelevantFeatures <- Features[RelevantFeaturesLocations,2]
RelevantFeatures <- gsub('-mean', 'Mean', RelevantFeatures)
RelevantFeatures <- gsub('-std', 'Std', RelevantFeatures)
RelevantFeatures <- gsub('[-()]', '', RelevantFeatures)

#Gathers the training data and filters only the relevant coloumns:
XTraining <- read.table("UCI HAR Dataset/train/X_train.txt")[RelevantFeaturesLocations]
YTraining <- read.table("UCI HAR Dataset/train/Y_train.txt")
SubjectsTraining <- read.table("UCI HAR Dataset/train/subject_train.txt")
DTraining <- cbind(SubjectsTraining, YTraining, XTraining)
#Gathers the test data and filters only the relevant coloumns:
XTest <- read.table("UCI HAR Dataset/test/X_test.txt")[RelevantFeaturesLocations]
YTest <- read.table("UCI HAR Dataset/test/Y_test.txt")
SubjectsTest <- read.table("UCI HAR Dataset/test/subject_test.txt")
DTest <- cbind(SubjectsTest, YTest, XTest)

#Combines the training and test data and gives the coloumns their names:
Data <- rbind(DTraining, DTest)
colnames(Data) <- c("subject", "activity", RelevantFeatures)

#Turns subject and activity into factors and gives them appropriate labels;
Data$activity <- factor(Data$activity, levels = Activity[,1], labels = Activity[,2])
Data$subject <- as.factor(Data$subject)

#Checks and filter NA's from the data:
Data <- Data[complete.cases(Data),]

#Gets required libraries:
library(reshape2)

#Reconstructs the data into average for every subject, feature and activity:
tempoData <- melt(Data, id = c("subject", "activity"))
AVGData <- dcast(tempoData, subject + activity ~ variable, mean)

#Puts the final table in a new TXT file:
write.table(AVGData, file = "AVGData", quote = FALSE, na = "NA", row.names = FALSE)
