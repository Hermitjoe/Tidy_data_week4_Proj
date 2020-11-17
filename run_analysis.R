#Here are the data for the project:
#    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

# You should create one R script called run_analysis.R that does the following.
##  Merges the training and the test sets to create one data set.
##  Extracts only the measurements on the mean and standard deviation for each measurement.
##  Uses descriptive activity names to name the activities in the data set
##  Appropriately labels the data set with descriptive variable names.
##  From the data set in step 4, creates a second, independent tidy data set with the average 
##     of each variable for each activity and each subject.

##Good luck!


## Program Start #################################

## Get Data if not already downloaded
If !file.exists('./DataSet.zip') {
  download.file( 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                 'DataSet.zip')
}

## Check to see if the files needed to run this script exist, if they do not unzip (again) and create them
## Unzip command taken from this site: https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/unzip
## This unzip will place hte files in a new sub directory - UCI HAR Dataset
if (!file.exists("./UCI HAR Dataset/activity_labels.txt") | !file.exists("./UCI HAR Dataset/features.txt") | 
    !file.exists("./UCI HAR Dataset/X_test.txt") | !file.exists("./UCI HAR Dataset/y_test.txt") | 
    !file.exists("./UCI HAR Dataset/X_train.txt") | !file.exists("./UCI HAR Dataset/y_train.txt") |
    !file.exists("./UCI HAR Dataset/subject_test.txt")) {
  ## If any of the files are missing, unzip the file - If any exist they wil lbe replaced with fresh copies
  unzip(zipfile = "DataSet.zip", exdir = getwd())}

## If these packages are not already installed, install them
# Saw this function by Sean Murphy on Stack Overflow and liked it
# From: https://stackoverflow.com/questions/9341635/check-for-installed-packages-before-running-install-packages
packages <- c("data.table", "dplyr", "reshape2")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

## get list of lables 
aLbls <- read.table("./UCI HAR Dataset/activity_labels.txt") [,2]   ## ,2 - These are column headers (aka lables)
feats <- read.table("./UCI HAR Dataset/features.txt")[,2]           ## More Column headers 

## REQ3 - Uses descriptive activity names to name the activities in the data set
##      -  To make this easier later, lets pull all the column headers that meat this requirement
x_feat <- grepl("mean|std", feats)    ## Hold for later, any header that has Mean or Stand Dev in it

## Next load the Test information
# Load and process X_test & y_test data.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")        ## Pull X Info
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")        ## Pull y Info
s_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")  ## Pull subject Info

#REQ 4 - Appropriately labels the data set with descriptive variable names.
## Running Head on the X_test file shows all the column headers a V##, which is meaning less
## Apply the features (pulled earlier) to the file to make it more descriptive - and so we can filter 
names(X_test) = feats

## REQ2 - Extract only the measurements on the mean and standard deviation for each measurement.
# Extract only mean and standard deviation items 
X_test = X_test[,x_feat]

# Add descriptives to the y_Test file
y_test[,2] = aLbls[y_test[,1]]                          ## Add activity label to each row     
names(y_test) = c("Activity_ID", "Activity_Label")      ## Add Column headers

# Lastly load the column headers to Subject info
names(s_test) = "subject"                               ## 1 column, set header to Subject          

## As we will only have one file at the end, merge the test files back together
test_data <- cbind(as.data.table(subject_test), y_test, X_test)


##### Perform the same steps again for the Training Data
## GRab data, we will use hte same column headers as used above
X_train <- read.table("./UCI HAR Dataset/train/X_test.txt")        ## Pull X Info
y_train <- read.table("./UCI HAR Dataset/train/y_test.txt")        ## Pull y Info
s_train <- read.table("./UCI HAR Dataset/train/subject_test.txt")  ## Pull subject Info

#REQ 4 - Appropriately labels the data set with descriptive variable names.
## Apply the headers to the training data
names(X_train) = feats

## REQ2 - Extract only the measurements on the mean and standard deviation for each measurement.
# Extract mean and standard deviation items again
X_train = X_train[,extract_features]

# Load activity data
y_train[,2] = activity_labels[y_train[,1]]              ## Add activity label to each row
names(y_train) = c("Activity_ID", "Activity_Label")     ## Add Column headers

names(subject_train) = "subject"                        ## 1 column, set header to Subject

## Again combine the information into 1 table
train_data <- cbind(as.data.table(subject_train), y_train, X_train) ## 1 column, set header to Subject

## Now that we have all the data in the same layout it is time to merge the tables into a single data set
data = rbind(test_data, train_data)                     ## row bind - Put the Train set after the Test set data   

id_lbls = c("Activity_ID", "Activity_Label", "subject") ## Add the subject column header to the Y set header

## SETDUFF -whats in set 1 thats not in set 2 - 
## outlined here: https://statisticsglobe.com/setdiff-r-function/
dif_lbls = setdiff(colnames(data), id_lbls)      ## Create a new list without the extra headers  
m_data   = melt(data, id = id_lbls, measure.vars = dif_lbls) ## Use Melt to culminate the dat set 

# Create the tidy data table 
td_table = dcast(m_data, subject + Activity_Label ~ variable, mean) ## Create table and apply mean function

## REQ 5 - From the data set in step 4, creates a second, independent tidy data set with the average of
##         each variable for each activity and each subject. 
##   tidy data set with the average of each variable for each activity and each subject.
##   To do this we will place our created table back out into a new file (tidy_data.txt) 
write.table(td_table, file = "./tidy_data.txt")
