#Auto Insurance Claims Analysis
#1.Load libraries
install.packages("tidyverse")   # dplyr,ggplot2 etc
install.packages("caret")    #for model building
install.packages("caTools")   #for train-test split
install.packages("corrplot")   #optional for correlation plots
install.packages("sqldf")    #optional if using SQL inside R
library(tidyverse)
library(caret)
library(caTools)
library(corrplot)
library(sqldf)
claims<-read_excel("C:/Users/USER/Downloads/insurance_claims.xlsx") 
#inspect data
head(claims)
install.packages("readxl")
library(readxl)
tail(claims)
summary(claims)
str(claims)      
#Data Cleaning,removing dupicates
claims<-claims%>%distinct()
#Remove rows with NAs for simpicity
claims<-claims%>%drop_na()
#Convert categorical variables to factors
claims$insured_sex<-as.factor(claims$insured_sex) 
ggplot(claims,aes(x=age))+geom_histogram(binwidth=5,fill='steelblue',color='black')+theme_minimal()+ggtitle("Age Distribution of Policyholders")
#Claim distribution by Gender
ggplot(claims,aes(x=insured_sex,fill=total_claim_amount))+geom_bar(position='fill')+theme_minimal()+ggtitle("Claim Filing by Gender")+ylab('Proportion')
names(claims)
nrow(claims)
#Incident severity vs Colision Type
ggplot(claims,aes(x=collision_type,fill=incident_severity))+geom_bar(position='fill')+theme_minimal()+ggtitle("Incident severity vs Collision Type")+ylab("Proportion")
# Correlation heatmap for numeric variables
numeric_cols<-claims%>% select_if(is.numeric)corr_matrix<-cor(numeric_cols)corrplot(corr_matrix,method='circle')
claims$fraud_reported<-ifelse(claims$fraud_reported=="Y",1,0)
claims$incident_city<-as.factor(claims$incident_city)
claims$collision_type<-as.factor(claims$collision_type)
claims$auto_make<-as.factor(claims$auto_make)
#Logistic regression model
model<-glm(fraud_reported~age+ insured_sex+insured_education_level+insured_occupation+policy_deductable+policy_annual_premium+umbrella_limit+incident_type+incident_severity+incident_state+incident_city+incident_hour_of_the_day+collision_type+number_of_vehicles_involved+property_damage+bodily_injuries+witnesses+police_report_available+total_claim_amount+injury_claim+property_claim+vehicle_claim+auto_year+auto_make,data=claims,family=binomial)
claims<-claims%>%drop_na(fraud_reported)
claims$pred_prob<-predict(model,type = "response")#Adding predicted probabilities to the dataet
#Plot probability vs Age
ggplot(claims,aes(x=age,y=pred_prob))+geom_point(alpha=0.5,color="steelblue")+geom_smooth(method="loess",color="red")+theme_minimal()+ggtitle("Predicted Probability of Fraud vs Age")+xlab("Age")+ylab("Predicted  Probability of Fraud")
#Plot probability vs Gender
ggplot(claims,aes(x=insured_sex,y=pred_prob))+geom_boxplot(fill="lightgreen")+theme_minimal()+ggtitle("Predicted Probability of Fraud by Gender")+ylab("Predicted Probability of Fraud")
#Plot probability vs Vehicle Age
ggplot(claims,aes(x=auto_year,y=pred_prob))+geom_point(alpha=0.5)+geom_smooth(method="loess",color="purple")+theme_minimal()+ggtitle("Predicted Probability of Fraud vs Vehicle Year")+xlab("Vehicle Year")+ylab("Predicted  Probability of Fraud")                                                                                                      
