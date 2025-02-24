# Stage_2 : Data manipulation and visualization
## Public health data
- The NHANES dataset was imported into R, and its structure was inspected to understand its variables.
- Missing values (NAs) in the data were handled by replacing them with "0" for numeric columns and "unknown" for character columns.
- Distributions of BMI, weight, weight in pounds, and age were visualized using histograms to understand the spread of the data.
- Descriptive statistics like mean, range, variance, and standard deviation were calculated for variables such as pulse, blood pressure, and income.
- Relationships between weight and height were visualized, with points colored by gender, diabetes status, and smoking status to identify patterns.
- t-tests were performed to compare variables like age by gender, BMI by diabetes, and alcohol consumption by relationship status to identify significant differences.

## Conclusions
- We found that weight and BMI follow a normal distribution, while age is more evenly spread across different groups, showing a uniform distribution.

- We also calculated mean, variance, and standard deviation for some variables to better understand the data.

- Height and weight are positively correlated, but gender and smoking don’t seem to affect that relationship. Diabetes is less common in people with lower height and weight, suggesting younger ages.

- Finally, t-tests showed that people with diabetes have a significantly higher BMI, and those in committed relationships consume more alcohol than singles. Both findings were statistically significant, with p-values below 0.05.
