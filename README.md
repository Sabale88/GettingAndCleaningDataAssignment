# GettingAndCleaningDataAssignment
This is my coursera final assignment for the Getting and Cleaning Data course

In this project there is only one script that gets the data from the web, filters only the relevant information and reshapes the data into one table. If you run the R file in this repo you will get the final desired Dataset. The code book contains all the information about the data manipulations I did and the names of the variables and features.

## The data proccesing ##
1. Reading the activity and features data
2. Filtering only the relevant features from the data, i.e., means and STDs
3. Combining all the data together, giving it appropriate names and labels, and turns the factors into factors
4. Clean out all the NAs
5. Reshaping the data so that it will include only the mean for each subject and each activity for every feature
