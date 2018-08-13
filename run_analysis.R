# Takes the name of the directory that contains the data
# and tidies data to generate tidy_set.csv and averages.csv
# Please see Codebook.md for details
runAnalysis <- function(dirName) {
  library(dplyr)
  library(stringr)
  
  # Extracts names of features
  features <- readLines(file.path(dirName,'features.txt')) %>%
    strsplit(' ') %>%
    sapply(function(x) x[2])

  # Extracts indices and features that have 'mean()' or 'std()' in them
  # Renames features using tidyName()
  requiredIndices = grep('(mean\\(\\)|std\\(\\))', features)
  reqFeatures = features[requiredIndices] %>%
    sapply(function(x) tidyName(x))
  names(reqFeatures) = NULL
  
  # Extracts activity names and numbers
  activities <- readLines(file.path(dirName,'activity_labels.txt')) %>%
    strsplit(' ') %>%
    sapply(function(x) x[[2]])
  
  # Initializes an empty list of datasets to contain the training and test data
  datasets = list(train = NULL, test = NULL)
  
  for (setType in c('train', 'test')) {
    
    # Reads in data from X_train.txt or X_test.txt
    # Tidies and converts data to numeric
    xData <- readLines(file.path(dirName, setType, paste('X_', setType, '.txt', sep=''))) %>%
      str_trim() %>%
      strsplit(' ') %>%
      lapply(function (x) {
        unlist(x)[x != ''] %>%
        as.numeric
      })
    
    # Converts to tibble and selects just the mean and std variables
    dataset <- do.call(rbind, xData) %>%
      as_tibble %>%
      select(requiredIndices)
    
    # Reads in subject numbers
    subjects <- readLines(file.path(dirName, setType, paste('subject_', setType, '.txt', sep=''))) %>%
      as.numeric
    
    # Reads in activity labels from y_train.txt or y_test.txt
    aLabels <- readLines(file.path(dirName, setType, paste('y_', setType, '.txt', sep=''))) %>%
      as.numeric %>%
      sapply(function(y) activities[y])
    
    names(dataset) <- reqFeatures
    
    # Adds in columns type, activity and subject
    dataset <- mutate(dataset, type = setType, activity = aLabels, subject = subjects)
    
    datasets[[setType]] = dataset
  }
    
  # Combines the test and train sets into a single set and write it out
  tidySet <- rbind(datasets[['train']], datasets[['test']])
  write.table(tidySet, file='tidy_set.txt', row.names = FALSE)
  
  # Get the averages and write out averages.csv
  writeAverages(tidySet)
}

# Function to rename variables
# Eg: fBodyGyro-mean()-Z' becomes 'Mean.fBodyGyro.Z'
tidyName <- function(name) {
  words <- unlist(strsplit(name, '-'))
  if (length(words) == 2) {
    if (words[2] == 'mean()')
      return (paste('Mean.', words[1], sep=''))
    else if (words[2] == 'std()')
      return(paste('SD.', words[1], sep=''))
  }
  else if (length(words) == 3) {
    if (words[2] == 'mean()')
      return(paste('Mean.', words[1], '.', words[3], sep=''))
    else if (words[2] == 'std()')
      return(paste('SD.', words[1], '.', words[3], sep=''))
  }
  name
}

# Function that takes the tidy data set (as a tibble) obtained earlier
# and to summarize by mean, grouped by subject and activity
writeAverages <- function(data) {
  avgData <- select(data, -type) %>%
    group_by(subject, activity) %>%
    summarize_all(funs(mean))
  
  names(avgData) <- names(avgData) %>%
    sapply(function(x) {
      if (x == 'subject' || x == 'activity')
        return (x)
      else
        return(paste('Avg_', x, sep=''))
    })
  
  write.table(avgData, file='averages.txt', row.names = FALSE)
}