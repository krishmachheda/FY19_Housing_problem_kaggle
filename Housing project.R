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

# replacing NAs with mean/required values
train_data$LotFrontage[is.na(train_data$LotFrontage)==T]<- mean(train_data$LotFrontage, na.rm = T)
train_data$GarageYrBltSince[is.na(train_data$GarageYrBltSince)==T]<- 0
train_data$MasVnrArea[is.na(train_data$MasVnrArea)==T]<- 0

#removing some variables from the database 
train_data<- subset(train_data, select = -c(GarageYrBlt,YearBuilt))

## ------------------------------------------------------------- ##
## -------------------- FEATURE IMPORTANCE --------------------- ##
## ------------------------------------------------------------- ##

###------------ Random Forest --------------###
# building random forest regression using all variables - except Id column
library(randomForest)
reg_mod1<- randomForest(SalePrice ~ .-Id, data = train_data, type = 'regression')

# getting the importance of variables from the model
variable_imp<- importance(reg_mod1)

# coverting the matrix into a data frame
varImportance <- data.frame(Variables = row.names(variable_imp), 
                            Importance = round(variable_imp[ ,'IncNodePurity'],2))

# ranking the varibales based on importance:
library(dplyr)
variable_rank<- varImportance %>%
  mutate(Rank = paste0(dense_rank(desc(Importance))))
variable_rank$Rank = as.numeric(variable_rank$Rank)
###--- So now we have variable ranks using random forest
###--- We will now try two more methods to get ranks and then conclude the important varibales
