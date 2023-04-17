library(ggplot2)
library(tidyverse)

Spot_Data <- read_csv("C:/Users/apple/Downloads/Spot Data.csv")

Spot_Data_new <- unique(Spot_Data)

names(Spot_Data_new) <- c('Patient_ID','Patient_Zip','Patient_Age','Patient_Sex','Type_of_Kit',"Specimen_Type","Client_ID", "Datetime_Kit_Delivered","Datetime_Kit_Registered","Datetime_Sample_Sent_In","Datetime_Sample_Received","Datetime_of_End_Status","End_Status","Rejection_Reason")

Spot_Data_new <- subset(Spot_Data_new,  End_Status== "rejected" | End_Status == "resulted" | End_Status == "partially_resulted")
                        
ggplot(Spot_Data_new, 
       aes(x = End_Status, 
           fill = Patient_Sex)) + 
  geom_bar(position = "dodge")


ggplot(Spot_Data_new, 
       aes(x = End_Status, 
           fill = Specimen_Type)) + 
  geom_bar(position = "dodge")

ggplot(Spot_Data_new, 
       aes(x = End_Status, 
           fill = Rejection_Reason)) + 
  geom_bar(position = "dodge")


ggplot(data=Spot_Data_new, mapping=aes(x=End_Status, 
                                       y=Patient_Age))+geom_boxplot(fill="violet")










