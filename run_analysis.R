# Runs 
runAnalysis <- function(dirName) {
  library(dplyr)
  library(stringr)
  
  features <- readLines(file.path(dirName,'features.txt')) %>%
    strsplit(' ') %>%
    sapply(function(x) x[2])

  requiredIndices = grep('(mean\\(\\)|std\\(\\))', features)
  reqFeatures = features[requiredIndices] %>%
    sapply(function(x) tidyName(x))
  names(reqFeatures) = NULL
  
  activities <- readLines(file.path(dirName,'activity_labels.txt')) %>%
    strsplit(' ') %>%
    sapply(function(x) x[[2]])
  
  datasets = list(train = NULL, test = NULL)
  
  for (setType in c('train', 'test')) {
    xData <- readLines(file.path(dirName, setType, paste('X_', setType, '.txt', sep=''))) %>%
      str_trim() %>%
      strsplit(' ') %>%
      lapply(function (x) {
        unlist(x)[x != ''] %>%
        as.numeric
      })
    
    dataset <- do.call(rbind, xData) %>%
      as_tibble %>%
      select(requiredIndices)
    
    subjects <- readLines(file.path(dirName, setType, paste('subject_', setType, '.txt', sep=''))) %>%
      as.numeric
    
    aLabels <- readLines(file.path(dirName, setType, paste('y_', setType, '.txt', sep=''))) %>%
      as.numeric %>%
      sapply(function(y) activities[y])
    
    names(dataset) <- reqFeatures
    dataset <- mutate(dataset, type = setType, activity = aLabels, subject = subjects)
    
    datasets[[setType]] = dataset
  }
    
  tidySet <- rbind(datasets[['train']], datasets[['test']])
  write.csv(tidySet, file='tidy_set.csv')
  writeAverages(tidySet)
}

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
  
  write.csv(avgData, file='averages.csv')
}