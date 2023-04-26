# load packages needed 
library(sqldf)
library(tidyverse)
library(ggplot2)
library(dplyr)

spot_df <- read.csv("Spot Data.csv")

names(spot_df) <- c('Patient_ID','Patient_Zip','Patient_Age','Patient_Sex','Type_of_Kit',"Specimen_Type","Client_ID", "Datetime_Kit_Delivered","Datetime_Kit_Registered","Datetime_Sample_Sent_In","Datetime_Sample_Received","Datetime_of_End_Status","End_Status","Rejection_Reason")


#check general duplication
duplicated_rows <- duplicated(spot_df)
duplicated_rows <- spot_df[duplicated_rows,]
#remove exactly same rows 
spot_df_unique <- unique(spot_df)


# only keep rows with end_status are rejected, resulted and partially_resulted (for analyzing purpose)
spot_df_new <- subset(spot_df_unique, End_Status == "rejected" | End_Status == "resulted" | End_Status == "partially_resulted")


 #target variable 

# convert end status variable into dummy
new1 <- spot_df_new
new1$End_Status <- ifelse(new1$End_Status == "resulted", 1, 0)


#process time-related variables

# convert all time-related variables as date
new2 <- new1
new2$Datetime_Kit_Delivered <- as.Date(new2$Datetime_Kit_Delivered)
new2$Datetime_Kit_Registered <- as.Date(new2$Datetime_Kit_Registered)
new2$Datetime_Sample_Sent_In <- as.Date(new2$Datetime_Sample_Sent_In)
new2$Datetime_Sample_Received <- as.Date(new2$Datetime_Sample_Received)
new2$Datetime_of_End_Status <- as.Date(new2$Datetime_of_End_Status)
#remove NA
new2 <- na.omit(new2)
# calculate time gap
new2 <- new2 %>%
  mutate(
    sample_sent_back_days = as.numeric(difftime(Datetime_Sample_Sent_In, Datetime_Kit_Delivered, units = "days")),
    sample_received_days = as.numeric(difftime(Datetime_Sample_Received, Datetime_Sample_Sent_In, units = "days")),
    lab_process_days = as.numeric(difftime(Datetime_of_End_Status,Datetime_Sample_Received, units = "days"))
  )
#drop original time-related variables 
new2 <- new2 %>%
  select(-Datetime_Kit_Delivered,
         -Datetime_Kit_Registered,
         -Datetime_Sample_Sent_In,
         -Datetime_Sample_Received,
         -Datetime_of_End_Status)


# drop other variables and convert gender into binary

# drop variables that can not be put in model 
new3 <- new2 %>%
  select(-Patient_ID,
         -Patient_Zip,
         -Type_of_Kit,
         -Specimen_Type,
         -Client_ID)
# convert gender in to dummy, Female = 0, male = 1 
new3$Patient_Sex <- ifelse(new3$Patient_Sex == "M", 1, 0)


library(neuralnet)
model <- neuralnet(End_Status ~ Patient_Sex+Patient_Age+sample_sent_back_days+sample_received_days+lab_process_days, data = new3) 
                   
                  
plot(model)

