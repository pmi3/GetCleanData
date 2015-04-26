Unzip <-function() {
  # This function downloads the data set zipfile and unzips the files out.

  # creates directory if it does not exist
  if(!file.exists("./UciHar2")){dir.create("./UciHar2")}
  url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  #downloads into the new dir.
  download.file(url,destfile="./UciHar2/data.zip",method="curl")
  #unzips into prenamed folder name
  unzip(zipfile="./UciHar2/Data.zip",exdir="./")
  #renames folder to UciHar
  file.rename("UCI HAR Dataset","UciHar")
}
merger <-function() {
  #This function calls unzip first.
  Unzip()
  #The six files in question are read separately.
  subj_test<-read.table("UciHar/test/subject_test.txt")
  subj_train<-read.table("UciHar/train/subject_train.txt")
  x_test<-read.table("UciHar/test/X_test.txt")
  x_train<-read.table("UciHar/train/X_train.txt")
  y_test<-read.table("UciHar/test/Y_test.txt")
  y_train<-read.table("UciHar/train/Y_train.txt")
  #Column binds the test files in two steps; 
  test<-cbind(subj_test,y_test)
  test<-cbind(test,x_test)
  #Column binds the train files in two steps; 
  train<-cbind(subj_train,y_train)
  train<-cbind(train,x_train)
  #Row binds the train and test data.
  mg<-rbind(test,train)

  #The activity labels file is read separately and columns are renamed.
  al<-read.table("UciHar/activity_labels.txt")
  colnames(al) <-c("act_id","act_desc")
  #The column names for the core data is adjusted prior to join.
  colnames(mg)[1]<-"p_id"
  colnames(mg)[2]<-"act_id"
  colnames(mg)[3]<-"V1"
  # The core and activity data are joined, with act_id being the joining field
  m0<-merge(al,mg)

  # Column name manipulation is done prior to rowbind.
  h1<-c(0,"act_id")
  h2<-c(-1,"act_desc")
  h3<-c(-2,"p_id")
  h<-rbind(h1,h2,h3)
  
  #The features  file is read separately and bound with the manipulated columns.
  f<-read.table("UciHar/features.txt")
  f1 <- rbind(h,f)
  names(m0)<-f1$V2
  # the mean and std containing feature names are seperately filtered out and joined together.
  fm<-f$V2[grep("mean",f$V2)]
  fs<-f$V2[grep("std",f$V2)]
  fltr <- c("act_desc","p_id",as.character(fm),as.character(fs))
  #subset data frame with just the mean and std filtered columns
  d<-subset(m,select=fltr)
 
  # the mean is calculated for each column after grouping by person id(p_id)
  library(plyr)
  d2<-aggregate(. ~p_id+act_desc, d,mean)
}