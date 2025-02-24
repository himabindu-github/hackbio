#################### Load the required packages----
library(dplyr)
library(tidyverse)
#library(ggplot2)
#library(plotly)
library(cowplot)
library(data.table)

#################### Read data into R -----
nhanes_data <- read.csv("nhanes.csv")
nhanes.df1 <- copy(nhanes_data)

#################### Details of the data -----

dim(nhanes_data)  # 5000  32
str(nhanes_data)
# 'data.frame':	5000 obs. of  32 variables:

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


###################    ggplot ###################################
# gen <-ggplot(nhanes.df1) +
#   aes(x = Weight, y = Height, colour = Gender, group = Gender) +
#   geom_point(na.rm = TRUE) +
#   labs(x = "Weight (kg)", y = "Height (cm)", title = "Relationship Between Weight and Height by Gender") 
#   #geom_smooth( method = "lm")
#   
# 
# diab <- ggplot(nhanes.df1) +
#   aes(x = Weight, y = Height, colour = Diabetes) +
#   scale_color_manual(values = c("lightgray", "red"), na.translate = FALSE) +
#   geom_point(na.rm = TRUE) +
#   labs(x = "Weight (kg)", y = "Height (cm)", title = "Relationship Between Weight and Height by Diabetes status") 
#   
# 
# smok <- ggplot(nhanes.df1) +
#   aes(x = Weight, y = Height, colour = SmokingStatus) +
#   scale_color_manual(values = c("green", "blue", "red"), na.translate = FALSE) +
#   geom_point(na.rm = TRUE) +
#   labs(x = "Weight (kg)", y = "Height (cm)", title = "Relationship Between Weight and Height by Smoking status") 

#plot_grid(gen, diab, smok, ncol = 3)
#################################################################


#base R plots
plot(nhanes.df1$Weight, nhanes.df1$Height,
     col = ifelse(nhanes.df1$Gender == "male", "blue", "pink"),
     pch = 16,
     xlab = "Weight (kg)", ylab = "Height (cm)", 
     main = "Relationship Between Weight and Height by Gender")
legend("bottomright", legend = c("Male", "Female"), fill = c("blue", "pink"))

plot(nhanes.df1$Weight, nhanes.df1$Height,
     col = ifelse(nhanes.df1$Diabetes == "Yes", "blue", "gray"), 
     pch = ifelse(nhanes.df1$Diabetes == "Yes", 16,2),
     xlab = "Weight (kg)", ylab = "Height (cm)", 
     main = "Relationship Between Weight and Height by Diabetes")
legend("bottomright", legend = c("Yes", "No"), fill = c("blue", "gray"))

colors <- c("Current" = "red", "Never" = "green", "Former" = "blue")
plot(nhanes.df1$Weight, nhanes.df1$Height,
     col = colors[nhanes.df1$SmokingStatus], 
     pch = 16,
     xlab = "Weight (kg)", ylab = "Height (cm)", 
     main = "Relationship Between Weight and Height by Diabetes")
legend("bottomright", legend = c("Current", "Former", "Never"), fill = c("red", "blue", "green"))
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
