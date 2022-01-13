After downloading the zipped file UCI_Har_Dataset.zip and extracting the included files into a folder named "specdata", I wrote a script that meets the following requirements: 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each         measurement
3. Uses descriptive activity names to name the activities in the dataset.
4. Appropriately labels the data set with descriptive variable names
5. From the data set in step 4, create a second, independent tidy data set with the   average of each variable for each activity and each subject.
  
The following is the step-by-step process with explanations on how I performed to clean the data until I generated the tidy data. But to better understand my code, open the file entitled run_analysis.R.

After setting the directory to where the extracted files are located, I read the train and test data set into R using the read.table function.The code below shows how it was used to read the train data set into R and the same set of codes were applied to the test data set.

traindata_x <-read.table("./train/X_train.txt", header=FALSE) 

traindata_y <-read.table("./train/y_train.txt", header=FALSE)

subj_train <-read.table("./train/subject_train.txt", header=FALSE)

After reading the data sets into R, I merged the test and train data sets that correspond to x using the following code:

x_combined <- rbind(traindata_x, testdata_x)

I did the same for y and the subject sets. 

The next code reads the feature names into R. This dataframe contains the label for the data set in test and train.

feature_names <- read.table("./features.txt")

The previous code allows us to label the data. We now assign the labels using colnames.The code below shows us how it should be done. We do the same for y_combined and subj_combined and assign them the labels "activity" and "subject"", respectively.

colnames(x_combined) <- feature_names$V2

Now we can create a single data set. In this case, I used the cbind function to metge the three rows I created earlier.

all_data <- cbind(x_combined, y_combined, subj_combined)

From there, I extracted the measurements on the mean and standard deviation from the V2 column of the file that contains the feature names, using grepl.I then created a dataframe that will contain only the data for mean and standard deviation.

Mean_Stdev <- grepl("(-std\\(\\)|-mean\\(\\))",feature_names$V2)
filtered_data <- x_combined[, which(Mean_Stdev == TRUE)]

To use descriptive activity names for the activities in the dataset, I read the activity labels into R. I then used factor, and as.factor to turn activities and subjects into factors.

activity <- factor(all_data$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 

subject  <- as.factor(all_data$subject) 

After that, I merged the subject, activity, and filtered data, column-wise to create a dataframe that will contain the subject list, activity names, and the measurements on mean and standard deviation.

filtered_data <- cbind(subject,activity,filtered_data)

To fulfill the 4th requirement, I used the gsub function to replace the labels into more appropriate ones. The code below was applied to each of the labels. 


filtered_data2<-gsub ("tBody", "Time-Body", names(filtered_data), ignore.case=FALSE)

For the final requirement, I created a tidy data set by creating a function that will group the data based on subject and activity. It will also get the average of each variable for each activity and subject.


tidy_data <- filtered_data %>% 
          group_by(subject, activity) %>% 
          summarize_each(funs(mean)) 
