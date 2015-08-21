
# Reading data in

training = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
training[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

#  read activity labels

activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)

#read in features and make names more clear

features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])
features[,2] = gsub('^t', 'time', features[,2])
features[,2] = gsub('^f', 'frequency', features[,2])

features[,2] = gsub('Gyro', 'Gyroscope', features[,2])
features[,2] = gsub('Mag', 'Magnitude', features[,2])
features[,2] = gsub('BodyBody', 'Body', features[,2])


#  merge the two datasets together

totalData = rbind(training, test)

# get required columns on Mean, StD

requiredCols <- grep(".*Mean.*|.*Std.*", features[,2])

#  reduce table.

features <- features[requiredCols,]

requiredCols <- c(requiredCols, 562, 563)

totalData <- totalData[,requiredCols]

colnames(totalData) <- c(features$V2, "Activity", "Subject")
colnames(totalData) <- tolower(colnames(totalData))

currentActivity = 1
for (currentActivityLabel in activityLabels$V2) {
  totalData$activity <- gsub(currentActivity, currentActivityLabel, totalData$activity)
  currentActivity <- currentActivity + 1
}

totalData$activity <- as.factor(totalData$activity)
totalData$subject <- as.factor(totalData$subject)

##  create tidy table based on mean 



tidy = aggregate(totalData, by=list(activity = totalData$activity, subject=totalData$subject), mean)
 	
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t")
