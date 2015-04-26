The script "run_analysis.R" processes Human Activity Recognition Using Smartphones Dataset from Smartlab - Non Linear Complex Systems Laboratory.

The experiments have been carried out with a group of 30 volunteers with each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Measurements of 3-axial linear acceleration and 3-axial angular velocity were captured at a constant rate of 50Hz. 70% of the volunteers was selected for generating the training data and 30% the test data. 

A total of 561 variables were captured in the measurement data set.

This R project extracts the mean and standard deviation data for each measurement into a separate dataset, relabels the variables with descriptive names, based on which it generates a new tidy dataset with the average for each activity and each subject.    

The detailed description of eash line of the script can be found below. 

Basically, the script first read in the measurement, subject, and activity data into dataframes for the training and test seperately and relabels the measurement dataset by descriptive names. Then it combines the training and test dataset together before extracting the mean and standard deviation columns for each measurement into a new measurement dataframe (with 66 variables). In order to calculate the mean grouped by the subject and activity, the script adds the subject and activity columns to the measurement dataframe and then melts the dataframe based on the subject and activity. The final tidy dataset with the average of each variable for each activity and each subject is obtained by using the aggregate function on the melted dataset. The result is a narrow and tall dataset with 30*6*66=11880 rows and four columns (subject, activity, feature, mean). The final tidy dataset is exported using write.table() function into a text file. 

library(reshape2) 
#read in the measurement data for the training group 
x_train <- read.table("./train/X_train.txt") 
#read in the activity data for the trainging group
y_train <- read.table("./train/y_train.txt") 
#read in the subject data for the training group
subject_train <- read.table("./train/subject_train.txt") 
#read in the measurement data for the test group
x_test <- read.table("./test/X_test.txt") 
#read in the activity data for the test group
y_test <- read.table("./test/y_test.txt") 
#read in the subject data for the test group
subject_test <- read.table("./test/subject_test.txt") 
#combine the training and test measurement data
x_total <- rbind(x_train, x_test) 
#combine the training and test activity data
y_total <- rbind(y_train, y_test) 
#combine the training and test subject data
subject_total <- rbind(subject_train, subject_test) 
#get all the labels of the columns in the x_total dataframe
names_all_vector <- names(x_total) 
#get all the descriptive names of the columns of the measurement into a dataframe
features <- read.table("./features.txt") 
#get all the descriptive names in a vector
feature_name_vector <- features[,2] 
#convert the vector from factor to character type
feature_vector <- as.character(feature_name_vector) 
#label variables with descriptive names
names(x_total) <- feature_name_vector 
#construct index vector for mean and sd data subsetting
column_select_vector <- c(seq(1,6), seq(41,46), seq(81,86), seq(121,126), seq(161,166), 201, 202, 214,215, 227, 228, 240, 241, 253, 254, seq(266, 271), seq(345, 350), seq(424, 429), 503, 504, 516, 517, 529, 530, 542, 543) 
#subset the total measurement to extract only the mean and standard deviation variables for each measurement
x_mean_sd <- x_total[,column_select_vector] 
#add subject column to the dataframe
x_mean_sd$subject <- subject_total[,1] 
#add activity column to the dataframe
x_mean_sd$activity <- y_total[,1] 
#melt the dataframe to two id groups for the subsequent group and mean calculation
melt_x <- melt(x_mean_sd, id=c("subject", "activity")) 
#to calculate mean by two groups for one column only
tidy_final <- aggregate(melt_x$value, list(melt_x$subject, melt_x$activity, melt_x$variable), mean) 
#relabel columns to descriptive names
names(tidy_final) <- c("subject", "activity", "feature", "mean") 
#export the final tidy data to a file
write.table(tidy_final, "./tidy_final.txt", row.name=FALSE) 

