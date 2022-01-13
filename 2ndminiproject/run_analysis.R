#Second Mini Project

#checking the working directory 
getwd()  
#setting the working directory to where the file was extracted 
setwd("D:/Desktop/specdata/UCI HAR Dataset")

#Loading the dplyr package
library(dplyr) 

# Reading the training dataset into R

traindata_x <-read.table("./train/X_train.txt", header=FALSE) 
traindata_y <-read.table("./train/y_train.txt", header=FALSE)
subj_train <-read.table("./train/subject_train.txt", header=FALSE)

# Reading the test dataset into R
testdata_x <-read.table("./test/X_test.txt", header=FALSE) 
testdata_y <-read.table("./test/y_test.txt", header=FALSE)
subj_test <-read.table("./test/subject_test.txt", header=FALSE)

#1st Requirement: Merges the training and the test sets to create one data set.

# Combining the two raw data tables together, row-wise.
x_combined <- rbind(traindata_x, testdata_x)
# combining the two label sets which correspond to the activities, row-wise
y_combined <- rbind(traindata_y,testdata_y) 
# combining the two subject codes list, row-wise
subj_combined <- rbind(subj_train, subj_test) 

#Reading the features into R
feature_names <- read.table("./features.txt")

# Assigning names to the datasets
colnames(x_combined) <- feature_names$V2
colnames(y_combined) <- "activity"
colnames(subj_combined) <- "subject"

# Creating one data set
all_data <- cbind(x_combined, y_combined, subj_combined)
# Removing columns with duplicated variable names
all_data <- all_data[, !duplicated(colnames(all_data))]

#2nd Requirement: Extracts only the measurements on the mean and standard deviation for each measurement

# Extracting the measurements on the mean and standard deviation

Mean_Stdev <- grepl("(-std\\(\\)|-mean\\(\\))",feature_names$V2)
filtered_data <- x_combined[, which(Mean_Stdev == TRUE)]


#3rd Requirement: Uses descriptive activity names to name the activities in the dataset

# Reading the activity labels into R
activity_labels <- read.table("./activity_labels.txt") 

# Turning activities & subjects into factors 
activity <- factor(all_data$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
subject  <- as.factor(all_data$subject) 

# Binding the subject, activity, and filtered data, column-wise
filtered_data <- cbind(subject,activity,filtered_data)

#4th Requirement: Appropriately labels the data set with descriptive variable names

# Replacing the label with the appropriate descriptive variable names using gsub

filtered_data2<-gsub ("tBody", "Time-Body", names(filtered_data), ignore.case=FALSE)
filtered_data2<-gsub ("tGravity", "Time-Gravity", filtered_data2, ignore.case=FALSE)
filtered_data2<-gsub ("Mag", "Magnitude", filtered_data2, ignore.case=FALSE)
filtered_data2<-gsub ("Gyro", "Gyroscope", filtered_data2, ignore.case=FALSE)
filtered_data2<-gsub ("Acc", "Accelerometer", filtered_data2, ignore.case=FALSE)
filtered_data2<-gsub ("fBody", "FastFourierTransform-Body", filtered_data2, ignore.case=FALSE)
filtered_data2<-gsub ("Freq", "Frequency", filtered_data2, ignore.case=FALSE)
filtered_data2<-gsub ("BodyBody", "Body", filtered_data2, ignore.case=FALSE)

colnames(filtered_data)<-filtered_data2

#5th Requirement: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

# Organizing the data set from step 4
tidy_data <- filtered_data %>% 
          group_by(subject, activity) %>% 
          summarize_each(funs(mean)) 