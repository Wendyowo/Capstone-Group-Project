library(ggplot2)
library(tidyverse)

Spot_Data <- read_csv("Spot Data.csv")

Spot_Data_new <- unique(Spot_Data)

Spot_Data_new <- subset(Spot_Data_new,  Spot_Data_new$`End Status`== "rejected" | Spot_Data_new$`End Status` == "resulted" | Spot_Data_new$`End Status` == "partially_resulted")
                        
ggplot(Spot_Data_new, 
       aes(x = `End Status`, 
           fill = `Patient Sex`)) + 
  geom_bar(position = "dodge")


ggplot(Spot_Data_new, 
       aes(x = `End Status`, 
           fill = `Specimen Type`)) + 
  geom_bar(position = "dodge")

ggplot(Spot_Data_new, 
       aes(x = `End Status`, 
           fill = `Rejection Reason`)) + 
  geom_bar(position = "dodge")


ggplot(data=Spot_Data_new, mapping=aes(x=`End Status`, 
                                       y=`Patient Age`))+geom_boxplot(fill="violet")










