# Getting and Cleaning Data Course Project

This is my course project submission for the 'Getting and Cleaning Data' course offered by Johns Hopkins University.

## Files

* run\_analysis.R: R script that tidies the data (See the file Codebook.md for details)
* tidy\_set.csv: Tidy data produced as output
* averages.csv: Additional tidy set (consisting of grouped averages of variables), also produced as output
* Codebook.md: Document explaining transformations performed by the script


## Instructions

* Download https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Unzip the contents (i.e. the folder 'UCI HAR Dataset') to the current directory.
* Rename the folder 'UCI HAR Dataset' to something convenient like 'dataset'
* Download the run_analysis.R script to the current directory
* In R, set the working directory to the current directory
* Run the following:

source('run_analysis.R')
runAnalysis('<dirName>')
(Replace \<dirName\> with the name of the actual folder your data is in. For example, if you renamed 'UCI HAR Dataset' to 'dataset', type runAnalysis('dataset'))

* The files 'tidy\_set.csv' and 'averages.csv' will be created.