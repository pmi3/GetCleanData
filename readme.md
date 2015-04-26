The main function (Merger) produces the final aggregated data.
It first calls Unzip() which downloads the data set zipfile and unzips the files out.
It creates a named directory if it does not exist
It then downloads into the new dir.
It unzips into pre-named folder name("UCI HAR Dataset”)
We renames folder to UciHar for convenience.

The core processing kicks in by reading the six files in question separately.  The are first column bound and then row bound to create a six column data frame.

The activity labels file is read separately and columns are renamed.  The core data frame is also adjusted for column names so the join happens between the activity ID (act_id) in both data  frames (during merge)

  # Column name manipulation is done prior to rowbind.

  
The features  file is then read separately and row bound with the manipulated columns; so now the core data frame has column names as in the features list.

The mean and std containing feature names are separately filtered out and joined together.
It is then used the subset from the core data frame.
 
The mean is calculated for each column after grouping by person id(p_id) using the plyr library.
  library(plyr)
  d2<-aggregate(. ~p_id+act_desc, d,mean)
