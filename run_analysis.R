require(reshape2)


new.dir <- readline("Where is the UCI HAR dataset you want to tidy up? ")
current.dir <- getwd()
setwd(new.dir)

# step 0: import the activity labels and features files for later
activity.labels <- read.table( "activity_labels.txt", sep=" " )
feature.labels <- read.table( "features.txt", sep=" " )

# given the directory of a dataset (either "test" or "train"), combine the subjects, activities, and measurements into one data frame. This method also gives meaningful names to activities and measurements
makeDataTable <- function( dir ) {
	suffix <- paste( dir, ".txt", sep="" )
	
	# step 1: import file on subjects, and create a column vector from them
	subjects.df <- read.table( file.path(dir, paste( "subject_", suffix, sep="" ) ) )
	subjects <- as.data.frame(subjects.df$V1)
	
	# step 2: import file on activities, and create a column vector from them to combine with subjects
	activities.df <- read.table( file.path( dir, paste( "y_", suffix, sep="" ) ) )
	activities <- as.data.frame( as.factor( activities.df$V1 ) )
	
	dataset <- cbind( subjects, activities )
	colnames( dataset ) <- c( "subject", "activity" )
	
	levels( dataset$activity ) <- activity.labels$V2
	
	# step 3: import file on measurements, and combine them with the two column data frame above
	measurements <- read.table( file.path( dir, paste( "X_", suffix,sep="" ) ), col.names=feature.labels$V2 )
	
	dataset <- cbind( dataset, measurements )
	dataset
}

# step 6: repeat 1-5 for the training dataset, and then rbind them together into one dataset
print("Creating data frame from test dataset")
test <- makeDataTable( "test" )
print("Creating data frame from train dataset")
train <- makeDataTable( "train" )

print("Combining the data and tidying it up")
full.data <- rbind( test, train )

# step 7: use grep to pull out columns on mean and standard deviation to create tidy dataset 1
# use built-in grep method to search for all columns that have "mean" in the name
# note: the [.] is to search for a literal period, since "." usually means any character;
# this was done to exclude meanFreq(), which was a separate method that is unrelated to each variable's mean
mean.cols <- grep("mean[.]", colnames(full.data), value=T)
# use built-in grep method to search for all columns that have "std" in the name
std.cols <- grep("std", colnames(full.data), value=T)
# combine the above two vectors by first making them a 2-row matrix (1st row means; 2nd row SDs), 
# and then converting that columnwise back to a vector, so that each variable's mean is followed by its SD
subset.vector <- c("subject", "activity", rbind(mean.cols, std.cols) )

# use the subset vector to produce the 1st tidy dataset (the one asked for step 4)
tidy.dataset1 <- full.data[ , subset.vector ]

# step 8: manipulate data to get avg for each subject, activity, and variable
# aka: subject	activity	variable 1
#		1		1			1
#		1		2			2
#		2		1			1
#		2		2			1

print("Creating the 2nd independent tidy dataset")
tidy.dataset2 <- aggregate(tidy.dataset1[,mean.cols], list(subject=tidy.dataset1$subject, activity=tidy.dataset1$activity), mean)

colnames(tidy.dataset2) <- gsub("[.][.]","",colnames(tidy.dataset2))

print("Printing the 2nd tidy dataset to file")
write.table(tidy.dataset2,file="UCI_HAR_tidyDataset2.txt", row.names=F, sep="\t", quote=F)

setwd(current.dir)