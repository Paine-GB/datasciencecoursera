#Here is a brief description of the material from my own perspective,
#The first two columns are of fullData are used to distinguish the experiment subjects and
#the labels, and 561 columns after that are selected feature-vectors to describe subjects' behavior

train_x<-read.table("UCI HAR Dataset/train/X_train.txt")
#way to read data in the folder
train_y<-read.table("UCI HAR Dataset/train/y_train.txt")
train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt")
test_x<-read.table("UCI HAR Dataset/test/X_test.txt")
test_y<-read.table("UCI HAR Dataset/test/y_test.txt")
test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt")
#above are the commands to load all data
trainData <- cbind(train_subject, train_y, train_x)
testData <- cbind(test_subject, test_y, test_x)
fullData <- rbind(trainData, testData)
#merge two datasets with cbind command to create whole new one
featureName <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
#only use the second column of featureName
#extract mean and standard deviation of each measurements
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
#\\(\\)   this command is used to match parenthesis 
#grep command return to the index of pattern
finalData <- fullData[, c(1, 2, featureIndex+2)]
#extract all rows and with these number of columns: 1,2,featurIndex+2 of fullData, while 
#these columns,respectively, are mean and std measurements
colnames(finalData) <- c("subject", "activity", featureName[featureIndex])
#in order to rename the column names of finalData, the beautiful way is the featureName[featureIndex]

#load activity data into R
activityName <- read.table("UCI HAR Dataset/activity_labels.txt")
## replace 1 to 6 with activity names
finalData$activity <- factor(finalData$activity, levels = activityName[,1], labels = activityName[,2])
#function which used to replace some character with other characters, say encoding
#where levels are represented as the values that finalData$activity might have taken

names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Std", names(finalData))
# gsub perform replacement of all matches
#^ 放在表达式开始出表示匹配文本开始位置
library(dplyr)
groupData <- finalData %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(groupData, "./MeanData.txt", row.names = FALSE)
#export data




