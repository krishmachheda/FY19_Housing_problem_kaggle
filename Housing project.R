## ------------------------------------------------------------- ##
## -------------------- BOSTON HOUSING PROJECT --------------------- ##
## ------------------------------------------------------------- ##
setwd("D:/kaggle/Housing Project")

# reading the datasets: 
train_data<- read.csv("train.csv", stringsAsFactors = F)
test_data<- read.csv("test.csv", stringsAsFactors = F)

# understading the dataset: 
str(train_data)

## ------------------------------------------------------------- ##
## -------------------- DATA PREPROCESSING --------------------- ##
## ------------------------------------------------------------- ##
# replacing the missing values of various char columns by 'not present' 
# then converting it to factors. 
for (i in 1:length(names(train_data))){
  if(class(train_data[,i])=="character"){
    train_data[,i][is.na(train_data[,i])==T]<-"Not Present"
    train_data[,i]<-as.factor(train_data[,i])
  }
}

# converting some character factor columns into numeric factors
train_data$CentralAir<- as.numeric(train_data$CentralAir)

# coverting some columns to factors: 
train_data$MSSubClass<- as.factor(train_data$MSSubClass)
train_data$YearBuilt<- as.factor(train_data$YearBuilt)
train_data$MoSold<- as.factor(train_data$MoSold)
train_data$YrSold<- as.factor(train_data$YrSold)

# creating a new variable using YearRemodAdd and garagreyrbuilt
train_data$NumYearRemodAdd<- as.numeric(format(Sys.Date(), "%Y")) - train_data$YearRemodAdd
train_data$GarageYrBltSince<- as.numeric(format(Sys.Date(), "%Y")) - train_data$GarageYrBlt

## ------------------------------------------------------------- ##
## -------------------- FEATURE IMPORTANCE --------------------- ##
## ------------------------------------------------------------- ##
