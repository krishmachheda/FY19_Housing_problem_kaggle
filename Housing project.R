setwd("D:/kaggle/Housing Project")

# reading the datasets: 
train_data<- read.csv("train.csv", stringsAsFactors = F)
test_data<- read.csv("test.csv", stringsAsFactors = F)

# understading the dataset: 
str(train_data)

# replacing the missing values of various char columns by 'not present' 
# then converting it to factors. 
for (i in 1:length(names(train_data))){
  if(class(train_data[,i])=="character"){
    train_data[,i][is.na(train_data[,i])==T]<-"Not Present"
    train_data[,i]<-as.factor(train_data[,i])
  }
}

# converting some character factor columns into numeric factors
# doing it separately for each columns as the treatment for each of it is different


for (i in 1:length(names(train_data))){
  if(class(train_data[,i])=="integer"){
    train_data[,i][is.na(train_data[,i])==T]<-"Not Present"
    train_data[,i]<-as.factor(train_data[,i])
  }
}
