library(reshape2) #for melting dataframe
x_train <- read.table("./train/X_train.txt") #read in the measurement data for the training group 
y_train <- read.table("./train/y_train.txt") #read in the activity data for the trainging group
subject_train <- read.table("./train/subject_train.txt") #read in the subject data for the training group
x_test <- read.table("./test/X_test.txt") #read in the measurement data for the test group
y_test <- read.table("./test/y_test.txt") #read in the activity data for the test group
subject_test <- read.table("./test/subject_test.txt") #read in the subject data for the test group
x_total <- rbind(x_train, x_test) #combine the training and test measurement data
y_total <- rbind(y_train, y_test) #combine the training and test activity data
subject_total <- rbind(subject_train, subject_test) #combine the training and test subject data
names_all_vector <- names(x_total) #get all the labels of the columns in the x_total dataframe
features <- read.table("./features.txt") #get all the descriptive names of the columns of the measurement into a dataframe
feature_name_vector <- features[,2] #get all the descriptive names in a vector
feature_vector <- as.character(feature_name_vector) #convert the vector from factor to character type
names(x_total) <- feature_name_vector #label variables with descriptive names
column_select_vector <- c(seq(1,6), seq(41,46), seq(81,86), seq(121,126), seq(161,166), 201, 202, 214,215, 227, 228, 240, 241, 253, 254, seq(266, 271), seq(345, 350), seq(424, 429), 503, 504, 516, 517, 529, 530, 542, 543) #construct index vector for mean and sd data subsetting
x_mean_sd <- x_total[,column_select_vector] #subset the total measurement to extract only the mean and standard deviation variables for each measurement
x_mean_sd$subject <- subject_total[,1] #add subject column to the dataframe
x_mean_sd$activity <- y_total[,1] #add activity column to the dataframe
melt_x <- melt(x_mean_sd, id=c("subject", "activity")) #melt the dataframe to two id groups for the subsequent group and mean calculation
tidy_final <- aggregate(melt_x$value, list(melt_x$subject, melt_x$activity, melt_x$variable), mean) #to calculate mean by two groups for one column only
names(tidy_final) <- c("subject", "activity", "feature", "mean") #relabel columns to descriptive names
write.table(tidy_final, "./tidy_final.txt", row.name=FALSE) #export the final tidy data to a file

