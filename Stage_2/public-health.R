#################### Load the required packages----
library(dplyr)
library(tidyverse)
library(ggplot2)
#library(plotly)
library(cowplot)
library(data.table)

#################### Read data into R -----
nhanes_data <- read.csv("nhanes.csv")

#################### Details of the data -----

dim(nhanes_data)  # 5000  32

str(nhanes_data)
# 'data.frame':	5000 obs. of  32 variables:
#   $ id                : int  62163 62172 62174 62174 62175 62176 62178 62180 62186 62190 ...
# $ Gender            : chr  "male" "female" "male" "male" ...
# $ Age               : int  14 43 80 80 5 34 80 35 17 15 ...
# $ Race              : chr  "Asian" "Black" "White" "White" ...
# $ Education         : chr  NA "High School" "College Grad" "College Grad" ...
# $ MaritalStatus     : chr  NA "NeverMarried" "Married" "Married" ...
# $ RelationshipStatus: chr  NA "Single" "Committed" "Committed" ...
# $ Insured           : chr  "Yes" "Yes" "Yes" "Yes" ...
# $ Income            : int  100000 22500 70000 70000 12500 100000 2500 22500 22500 30000 ...
# $ Poverty           : num  4.07 2.02 4.3 4.3 0.39 5 0.05 0.87 0.53 0.54 ...

table(is.na(nhanes_data))
# FALSE   TRUE 
# 126009  33991

#################### Handle NAs ----
for (i in colnames(nhanes_data)) {  # loops through each column name in the dataset
  x <- nhanes_data[[i]] # extracts the values in the column
  if (is.numeric(x)) { # checks if numeric
    nhanes_data[[i]] <- replace(x, is.na(x), 0) # replaces NAs with 0
  } else if (is.character(x)) {
    nhanes_data[[i]] <- replace(x, is.na(x), "unknown")
  }
}

print(nhanes_data)

table(is.na(nhanes_data))
#################### Visualize distribution -----
# distribution of BMI, Weight, Weight in pounds (weight *2.2) and Age with an histogram.

new.nhanes_data <- nhanes_data %>% 
  mutate(Weight_pounds = Weight * 2.2)
# adds another column to the dataset

par(mfrow = c(2,2))  # arranges the plotting area into 2 rows and 2 columns
BMI <- hist(new.nhanes_data$BMI, 
            main = "Body Mass Index", 
            xlab = "BMI",
            col = "pink",
            breaks = pretty(new.nhanes_data$BMI, n = 10))
Weight <- hist(new.nhanes_data$Weight, 
               main = "Weight", 
               xlab = "Weight (kg)",
               col = "lightgreen",
               breaks = pretty(new.nhanes_data$Weight, n = 10))
W_pounds <- hist(new.nhanes_data$Weight_pounds, 
                 main = "Weight_pounds", 
                 xlab = "Weight(lbs)",
                 col = "lavender",
                 breaks = pretty(new.nhanes_data$Weight_pounds, n = 10))
Age <- hist(new.nhanes_data$Age, 
                 main = "Age", 
                 xlab = "Age",
                 col = "lightblue",
                 breaks = pretty(new.nhanes_data$Age, n = 10))
axis(1, at = seq(0, 100, by = 10)) 
par(mfrow = c(1,1))  # resets the plot layout

#################### Descriptive stats ----
# mean 60-second pulse rate for all participants 
mean_pulse <- mean(new.nhanes_data$Pulse) #  63.06

# range of values for diastolic blood pressure
bp_range <- range(new.nhanes_data$BPDia) # 0 116


# variance and standard deviation for income 
var_income <- var(new.nhanes_data$Income) # 1264147754

sd_income <- sd(new.nhanes_data$Income) # 35554.86

#################### visualize relationship ----
# Visualize the relationship between weight and height 
# Color the points by gender, diabetes, smoking status
# uncleaned data with NA is used to avoid additional "unknown" groups in variables
# na.rm = TRUE ignores NAs

# table(factor(nhanes.df1$Gender))
# table(factor(nhanes.df1$Diabetes))
# table(factor(nhanes.df1$SmokingStatus))

gen <-ggplot(nhanes.df1) +
  aes(x = Weight, y = Height, colour = Gender, group = Gender) +
  geom_point(na.rm = TRUE) +
  labs(x = "Weight (kg)", y = "Height (cm)", title = "Relationship Between Weight and Height by Gender")#+
  #geom_smooth( method = "lm")
  

diab <- ggplot(nhanes.df1) +
  aes(x = Weight, y = Height, colour = Diabetes) +
  scale_color_manual(values = c("lightgray", "red"), na.translate = FALSE) +
  geom_point(na.rm = TRUE) +
  labs(x = "Weight (kg)", y = "Height (cm)", title = "Relationship Between Weight and Height by Diabetes status") 
  

smok <- ggplot(nhanes.df1) +
  aes(x = Weight, y = Height, colour = SmokingStatus) +
  scale_color_manual(values = c("green", "blue", "red"), na.translate = FALSE) +
  geom_point(na.rm = TRUE) +
  labs(x = "Weight (kg)", y = "Height (cm)", title = "Relationship Between Weight and Height by Smoking status") 

#plot_grid(gen, diab, smok, ncol = 3)

#################### t-tests -----
# t-test and make conclusions on the relationship between them based on P-Value
# Age and Gender
# BMI and Diabetes
# Alcohol Year and Relationship Status

t_test_age_gender <- t.test(Age ~ Gender, data = nhanes.df1)

#t_test_bmi <- t.test(BMI ~ Diabetes, data = new.nhanes_data)
#the t-test function (t.test()) automatically handles missing values (NA) 
# by ignoring them during the calculation

t_test_bmi <- t.test(BMI ~ Diabetes, data = nhanes.df1)
#the groups are "No" (presumably individuals without diabetes) and 
#"Yes" (individuals with diabetes), based on the variable BMI (Body Mass Index).
# very small p-value means that the observed difference in means is highly unlikely to have occurred by chance
#Diabetes     mean_bmi
#  <chr>       <dbl>
#  1 No           25.9
#  2 Yes          32.5

t_test_alc_rel <- t.test(AlcoholYear ~ RelationshipStatus, data = nhanes.df1)
# AlcoholYear : Estimated number of days over the past year that participant 
# drank alcoholic beverages. Reported for participants aged 18 years or older.
# RelationshipStatus   mean_days
#<chr>                    <dbl>
#1 Committed               83.9
#2 Single                  63.5


## github link : https://github.com/himabindu-github/hackbio/tree/main/Stage_2
## linkedin post : https://www.linkedin.com/feed/update/urn:li:activity:7299658541093527553/
###############################################
