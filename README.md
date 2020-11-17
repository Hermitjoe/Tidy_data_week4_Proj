# README fiel for the Getting and Cleaning Data Course project

The README that explains the analysis perfomed on the retieved files in a clear and understandable fashion.

Note: Similar comments exist in the R file in this repo

## Process 

### Preping Enviroment
The first part of this script checks to see if the necessary zip file has been retrieved.
* If it has not it is retrieved and stored locally
* Unzipping code was adapted from this doc:  https://www.rdocumentation.org/packages/utils/versions/3.6.2/topics/unzip

The second step looks to see if the necessary files to perform this procedure exist.
* If they do not the Zip file is unzipped 
* Any exising files are overwritten with fresh files

The enviroment is reviewed to see if hte proper packages are installed.
* Any package  found not to be installed is installed
* This was addapted from this Stack Overflow post: https://stackoverflow.com/questions/9341635/check-for-installed-packages-before-running-install-packages 

### Column Header Information
As both Test and Train will use the same headers, the files were brought in and massaged for easier application later.
The activity_labels.txt and features.txt files were imported 
The features were limited to those that this project requires (Mean and Stadard Deviation)
Note: Nothing for subject is done here. It is one header no need to store that into a variable

### Gathering Information and Massaging The Data
#### Test File Prep
The Testing files are imported
The full feature list is aplied to the file headers, the cut down column list is then used to limit the X data
The Y data has its headers applied (from the Activity_list file)
The subject title is then applied to the subject file

Lastly column bind Y in front of X

#### Training File Prep
The above steps are then applied to the training files

#### Final Merging and Output
With all the files in the same layout, append the test data after the training data usign rowbinding
Set Diff is used to make sure the Subject and Y file headers were applied
* Adopted from this page: https://statisticsglobe.com/setdiff-r-function/
Melt is then used to create the table 
dcast applied to apply the mean function 

### File Creation
Write table function is used to place the file into hte working directory







