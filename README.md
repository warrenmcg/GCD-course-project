Getting and Cleaning Data Course Project
==================

This ReadMe details how the raw data from the Human Activity Recognition Using Smartphones Dataset was generated, as well as how the data was processed to produce the final tidy dataset.

The untidy data was downloaded from [this website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Details about the Script "run_analysis.R"
--------------------------

#### Do I have to worry about where the script is in relation to the datasets?
The script prompts you to provide the directory that is downloaded from the website above, and temporarily enters that directory to do its work. Thus, there is no concern about where the script is in relation to where the data is.

#### How does the script process the test and training datasets?
The script has an internal function (*makeDataTable*) that can process either the "test" or the "train" sub-directory. Within each sub-directory, there are three files: "subjects_*.txt", "y_*.txt" (which details the activities), and "X_*.txt" (which details the measurements for each feature). The three files have the same number of rows, indicating that each row has a (subject, activity) pair and the associated measurements for that pair. The function follows this logic to combine the test and training datasets.

#### How does the script select just the mean and standard deviation features
Then the script uses the built-in grep function to select only the features related to mean() and std(). To distinguish mean() from meanFreq(), I took advantage of the fact that R converted the parentheses to periods, and used the regular expression "mean[.]". The brackets were necessary because otherwise "." would be interpreted as "any 1 character", which would also include meanFreq() features. This step created the first tidy dataset.

#### How does the script generate the second tidy dataset?
The final step to create the second dataset uses aggregate. The function creates a table that where each row has one (subject, activity) pair, and the averages of each of the relevant features (see the code book below). Example of what this looks like:

**Table 1: example (fake) output for second tidy dataset**

<table>
	<tr>
		<td>Subject</td><td>Activity</td><td>Feature 1</td>
	</tr>
	<tr>
		<td>1</td><td>WALKING</td><td>1</td>
	</tr>
	<tr>
		<td>1</td><td>LAYING</td><td>0.001</td>
	</tr>
	<tr>
		<td>2</td><td>WALKING</td><td>1.5</td>
	</tr>
</table>

### Why is the second dataset tidy?

The three principles established in Hadley Wickham's article ["Tidy Data"](http://vita.had.co.nz/papers/tidy-data.pdf) for a tidy dataset are

1. Each variable is a column.
2. Each observation is a row.
3. Each type of observational unit is a table.

**The reason this is a tidy dataset is because it fulfills these criteria:**

1. Each variable (subject, activity, feature 1, feature 2, … etc) is a column
2. Each observation (what is the average of each feature for each [subject, activity] pair) is a row
3. This table is one type of observational unit: average of features from the Human Activity Recognition dataset for each subject doing each activity

Details About the Raw Data
--------------------------

### How the raw data was generated

Here is a direct quote from the "README.txt" file that came with the raw data:
>The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
>
>The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

### Feature Selection

Here are more details about the "features" obtain from the above raw data (quoted from the "features_info.txt" file included with the raw data):
>The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
>
>Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 
>
>Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 
>
>These signals were used to estimate variables of the feature vector for each pattern:


Code Book
----------------

Note: '.XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

+ Subject: each of the 30 subjects was given a unique identifier 1-30
+ Activity: the activity performed (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
+ tBodyAcc.mean.XYZ: average *linear* acceleration of the body in the X, Y and Z directions
+ tGravityAcc.mean.XYZ: average *linear* acceleration due to gravity in the X, Y and Z directions
+ tBodyAccJerk.mean.XYZ: average *linear* jerk of the body in the X, Y and Z directions 
+ tBodyGyro.mean.XYZ: average *angular* velocity of the body in the X, Y and Z directions
+ tBodyGyroJerk.mean.XYZ: average *angular* jerk of the body in the X, Y and Z directions
+ tBodyAccMag.mean: average 3D *linear* acceleration of the body using the Euclidean norm
+ tGravityAccMag.mean: average 3D *linear* acceleration due to gravity using the Euclidean norm
+ tBodyAccJerkMag.mean: average 3D jerk of the body using the Euclidean norm
+ tBodyGyroMag.mean: average 3D *angular* velocity using the Euclidean norm
+ tBodyGyroJerkMag.mean: average 3D *angular* jerk using the Euclidean norm
+ fBodyAcc.mean.XYZ: average FFT of the *linear* acceleration of the body in the X, Y and Z directions
+ fBodyAccJerk.mean.XYZ: average FFT of the *linear* jerk of the body in the X, Y and Z directions
+ fBodyGyro.mean.XYZ: average FFT of the *angular* velocity of the body in the X, Y and Z directions
+ fBodyAccMag.mean: average FFT of the 3D *linear* acceleration using the Euclidean norm
+ fBodyAccJerkMag.mean: average FFT of the 3D *linear* jerk using the Euclidean norm
+ fBodyGyroMag.mean: average FFT of the 3D *angular* velocity using the Euclidean norm
+ fBodyGyroJerkMag.mean: average FFT of the 3D *angular* jerk using the Euclidean norm

Final Note: How do I read in the tidy dataset?
----------------------------------------------
The data was written out using this line of code:

    write.table(tidy.dataset2,file="UCI_HAR_tidyDataset2.txt", row.names=F, sep="\t", quote=F)

Thus, if you want to read the data into R, you should use this line of code:

    read.table(file="UCI_HAR_tidyDataset2.txt", header=TRUE, sep="\t")