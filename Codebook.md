# Codebook for: Getting and Cleaning Data Course Project

## Variables

The variables correspond to measurements taken using the accelerometer and gyroscope of a smartphone, mapped to subjects (numbered 1 to 30, volunteers) and activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING).

There are 561 variables derived from the raw signals, out of which we're interested in only the ones corresponding to mean and standard deviation (i.e. those that have either 'mean()' or 'std()' in the original variable name).


## Input data

* activity\_labels.txt: Mapping between activity names and numbers (Eg: 1 = WALKING)
* features\_info.txt: Key information and long-form descriptions of the variables
* features.txt: Names of the 561 variables in order
* train/X\_train.txt: 7352 rows of 561 numbers each, corresponding to the 561 variables and 7352 observations in the training set.
* train/y\_train.txt: Corresponding activity numbers for each of the 7352 observations
* train/subject\_train.txt: Corresponding subject numbers for each of the 7352 observations
* test/X\_test.txt: 2947 rows of 561 numbers each, corresponding to the 561 variables and 2947 observations in the test set.
* test/y\_test.txt: Corresponding activity numbers for each of the 2947 observations
* test/subject\_test.txt: Corresponding subject numbers for each of the 2947 observations


## Transformations performed

1. From the file 'features.txt', extract the lines and split using spaces to obtain the feature (variable) names and corresponding indices.

2. Find the indices of all feature names that contain 'mean()' or 'std()' and save it into requiredIndices.

3. Tidy up the feature names. Eg: If a feature name is 'fBodyGyro-mean()-Z', change it to: 'Mean.fBodyGyro.Z'.

4. From the file 'activity\_labels.txt', extract the lines and split using spaces to obtain the activity names and corresponding indices.

5. Do the following for each of test and training:

..a. From the file X\_<type>.txt / X\_<type>.txt:
....1. Extract the lines
....2. Trim the leading whitespace
....3. Split each line by spaces to obtain the list of features for each observation
....4. Convert each such list into numeric values

..b. Convert the list obtained above into a dataframe, and then a tibble (see dplyr library)

..c. Select only the columns corresponding to requiredIndices.

..d. Read the lines of subject\_<type>.txt file into a numeric vector

..e. Read the lines of y\_<type>.txt file into a numeric vector and obtain the mapped activity names

..f. Set the column names of the dataset to those extracted in Step 1

..g. Add type ('train' or 'test'), activity and subject as columns in the data set.

6. Combine the 'train' and 'test' datasets to obtain a single dataset using rbind.

7. Group the data set by activity and subject.

8. Summarize the data using mean() to get the average of every variable.


## Output

* tidy\_set.csv: The tidy data set with 66 variables corresponding to mean and standard deviation, and three additional ones: type ('train' or 'test'), subject, and activity.

* grouped\_averages.csv: Averages of the 66 variables, grouped by subject and activity.