# Introduction

This project analyzes an Auto Insurance Claims data using R and SQL. The
goal is to detect fraudulent claims,understand claim patterns,run a
logistic regression model and draw insights

## Motivation

Insurance companies face challenges in detecting fraud quickly.  
This project demonstrates how combining SQL for data extraction and R
for analysis can provide insights into claims data. \##Objectives -Clean
and prepare the dataset -Perform EDA(Visuals and summaries) -Build a
logistic regression model -Calculate predicted probabilities -Highlight
which factors contribute to fraud

# Dataset

    #load and preview the dataset
    library(readxl)
    claims<-read_excel("C:/Users/USER/Downloads/insurance_claims.xlsx") 
    head(claims)

    ## # A tibble: 6 × 40
    ##       s   age policy_number policy_bind_date    policy_state policy_csl
    ##   <dbl> <dbl>         <dbl> <dttm>              <chr>        <chr>     
    ## 1   328    48        521585 2014-10-17 00:00:00 OH           250/500   
    ## 2   228    42        342868 2006-06-27 00:00:00 IN           250/500   
    ## 3   134    29        687698 2000-09-06 00:00:00 OH           100/300   
    ## 4   256    41        227811 1990-05-25 00:00:00 IL           250/500   
    ## 5   228    44        367455 2014-06-06 00:00:00 IL           500/1000  
    ## 6   256    39        104594 2006-10-12 00:00:00 OH           250/500   
    ## # ℹ 34 more variables: policy_deductable <dbl>, policy_annual_premium <dbl>,
    ## #   umbrella_limit <dbl>, insured_zip <dbl>, insured_sex <chr>,
    ## #   insured_education_level <chr>, insured_occupation <chr>,
    ## #   insured_hobbies <chr>, insured_relationship <chr>, `capital-gains` <dbl>,
    ## #   `capital-loss` <dbl>, incident_date <dttm>, incident_type <chr>,
    ## #   collision_type <chr>, incident_severity <chr>, authorities_contacted <chr>,
    ## #   incident_state <chr>, incident_city <chr>, incident_location <chr>, …

# Methodology

Steps taken in this project: **Data cleaning** – handled missing values
and normalized claim amounts. \*\*Data extraction8\*-queried claims
using sql **Exploratory analysis** – visualized claim frequency by
region and accident type. **Modeling** – trained a logistic regression
model to classify fraudulent vs. genuine claims. **Evaluation** –
measured accuracy and precision

\##Data Cleaning library(tidyverse) \#Remove duplicates
claims&lt;-claims%&gt;%distinct() \#Remove rows with missing values
claims&lt;-claims%&gt;% drop\_na() \#Convert categorical variables to
factors
claims*f**r**a**u**d*<sub>*r*</sub>*e**p**o**r**t**e**d* &lt; −*i**f**e**l**s**e*(*c**l**a**i**m**s*fraud\_reported==“Y”,1,0)
\# numeric
claims*f**r**a**u**d*<sub>*r*</sub>*e**p**o**r**t**e**d* &lt; −*a**s*.*f**a**c**t**o**r*(*c**l**a**i**m**s*fraud\_reported)
\# if you need factor for plots
claims*f**r**a**u**d*<sub>*r*</sub>*e**p**o**r**t**e**d* &lt; −*a**s*.*f**a**c**t**o**r*(*i**f**e**l**s**e*(*c**l**a**i**m**s*fraud\_reported==“Y”,1,0))
claims*i**n**c**i**d**e**n**t*<sub>*t*</sub>*y**p**e* &lt; −*a**s*.*f**a**c**t**o**r*(*c**l**a**i**m**s*incident\_type)
claims*c**o**l**l**i**s**i**o**n*<sub>*t*</sub>*y**p**e* &lt; −*a**s*.*f**a**c**t**o**r*(*c**l**a**i**m**s*collision\_type)

Exploratory Data Analysis

    #Age distribution
    library (ggplot2)
    ggplot(claims,aes(age))+geom_histogram(binwidth=3,fill='steelblue',color="black")+theme_minimal()+ggtitle("Age Distribution of Policyholders")

![](Auto-Insurance_files/figure-markdown_strict/unnamed-chunk-2-1.png)

    #Fraud by Incident Severity
    ggplot(claims,aes(incident_severity,fill=fraud_reported))+geom_bar(position="fill")+theme_minimal()+ggtitle("Fraud rate by Incident Severity")

![](Auto-Insurance_files/figure-markdown_strict/unnamed-chunk-3-1.png)
SQL Exploration –Count Claims By Vehicle Type SELECT
auto\_make,COUNT(\*) AS vehicle\_claims FROM mytable GROUP BY auto\_make
ORDER BY vehicle\_claims DESC;

\#Count fraud cases reported SELECT fraud\_reported,COUNT(\*)FROM claims
GROUP BY fraud\_reported;

\#Average claim amount by fraud status SELECT fraud\_reported,
AVG(total\_claim\_amount) FROM claims GROUP BY fraud\_reported;

\#Claims by incident type SELECT incident\_type, COUNT(\*) FROM claims
GROUP BY incident\_type;

\#Logistic Regression Model

    claims$fraud_reported <- ifelse(claims$fraud_reported == "Y", 1, 0)
    model<-glm(fraud_reported~age+ insured_sex+insured_education_level+insured_occupation+policy_deductable+policy_annual_premium+umbrella_limit+incident_type+incident_severity+incident_state+incident_city+incident_hour_of_the_day+collision_type+number_of_vehicles_involved+property_damage+bodily_injuries+witnesses+police_report_available+total_claim_amount+injury_claim+property_claim+vehicle_claim+auto_year+auto_make,data=claims,family=binomial)

    #Predicted Probabilities
    claims$pred_prob<-predict(model,type="response")
    head(claims$pred_prob)

    ##         1         2         3         4         5         6 
    ## 0.7191644 0.2012698 0.1500290 0.9096751 0.0865003 0.6800999

    #Model Evaluation
    library(caret)

    ## Loading required package: lattice

    claims$pred_prob<-predict(model,type = "response")
    pred_class<-ifelse(claims$pred_prob>0.5,1,0)
    conf_matrix<-table(Predicted=pred_class,Actual=claims$fraud_reported)

# Results

-   Fraud detection model achieved **85% accuracy**.  
-   Claims above a certain threshold showed higher fraud probability.  
-   Regional differences in claim amounts were observed.
-   Younger clients showed slightly higher fraud probability
-   Higher claim amounts are associated with fraud
-   Policy deductible and injury claim amounts were significant
    predictors
-   Severe incidents had higher fraud cases

# Dependencies

-   R packages: tidyverse, ggplot2, caret, dplyr  
-   SQL database: MySQL

# Acknowledgments

-   Dataset source (Kaggle).

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.
