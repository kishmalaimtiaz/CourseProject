#Reading data into R
x_test <- read.table(paste(sep = "" , "./test/X_test.txt"))
y_test <- read.table(paste(sep = "" , "./test/y_test.txt"))
s_test <- read.table(paste(sep = "" , "./test/subject_test.txt"))

x_train <- read.table(paste(sep = "", "./train/X_train.txt"))
y_train <- read.table(paste(sep = "", "./train/y_train.txt"))
s_train <- read.table(paste(sep = "", "./train/subject_train.txt"))

#Merging data and training sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(s_train, s_test)

#Reading feature and activity info
feature <- read.table(paste(sep = "", "features.txt"))
activitylabels <- read.table(paste(sep = "", "activity_labels.txt"))
activitylabels[,2] <- as.character(activitylabels[,2])

#Selecting features containg mean or std deviation and imroving their names
selectedcolumns <- grep("-(mean|std).*", as.character(feature[,2]))
selectedColNames <- feature[selectedcolumns, 2]
selectedColNames <- gsub("-mean", "Mean", selectedColNames)
selectedColNames <- gsub("-std", "Std", selectedColNames)
selectedColNames <- gsub("[-()]", "", selectedColNames)

#Giving descriptive column names and converting activities and subject to 
#factor variable
x_data <- x_data[selectedcolumns]
allData <- cbind(subject_data, y_data, x_data)
colnames(allData) <- c("Subject", "Activity", selectedColNames)

allData$Activity <- factor(allData$Activity, levels = activitylabels[,1], 
                           labels = activitylabels[,2])
allData$Subject <- as.factor(allData$Subject)

#Getting averge of each subject against each activity

library(reshape2)
allDatamelted <- melt(allData, id = c("Subject", "Activity"))
tidyData <- dcast(allDatamelted, Subject + Activity ~ variable, mean)

write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)                         
