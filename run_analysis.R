# extract data

unzip("dataset.zip")

# merge subsets
train = read.table("UCI HAR Dataset/train/X_train.txt", header=F)
subj  = read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
actv  = read.table("UCI HAR Dataset/train/y_train.txt", header=F)

train = cbind(subj, actv, train)

test  = read.table("UCI HAR Dataset/test/X_test.txt", header=F)
subj  = read.table("UCI HAR Dataset/test/subject_test.txt", header=F)
actv  = read.table("UCI HAR Dataset/test/y_test.txt", header=F)

test = cbind(subj, actv, test)


data  = rbind(train, test)
rm(train, test, subj, actv)

# filter columns

colns = read.table("UCI HAR Dataset/features.txt", stringsAs=F)[,2]
colnames(data) = c("Subject", "Activity", colns)
cols  = str_detect(colns,"mean") | str_detect(colns,"std")
cols  = colns[cols]
cols  = c("Subject", "Activity", cols)

data  = data[,cols]
rm(colns, cols)

# add activity names
actv = read.table("UCI HAR Dataset/activity_labels.txt", stringsAsF=F)
data$Activity = as.character(data$Activity)
data[data$Activity == "1",2] = actv[1,2]
data[data$Activity == "2",2] = actv[2,2]
data[data$Activity == "3",2] = actv[3,2]
data[data$Activity == "4",2] = actv[4,2]
data[data$Activity == "5",2] = actv[5,2]
data[data$Activity == "6",2] = actv[6,2]

rm(actv)

save(data,file="data.Rda")
data = as.data.frame(data, stringsAsF=F)

tidy.data = aggregate(data[,3:ncol(data)], list(Subject=data$Subject, Activity=data$Activity), mean)

write.csv(tidy.data, "tidy_data.txt", row.names=F)
