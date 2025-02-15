# Stage_1 task: All about functions
### Here's a summary of my approach

## 1. Translate a DNA sequence to protein.
 - A function 'translate' that takes a DNA sequence and translates it into a corresponding protein sequence was created. The function processes the DNA codons by mapping them to amino acids using a named vector(codon table).

 - Processed the DNA sequence by converting it to uppercase to maintain consistency.

 - The DNA sequence is iterated in triplets (codons), using the named vector to retrieve the corresponding amino acid for each codon. (and generated the protein sequence)

 - Added checks for invalid codons (represented by NA or invalid characters), replacing them with "!", and halted translation when a stop codon (*) was encountered.


## 2. Logistic population growth curve.
 - The function 'logistic_growth' models population growth based on the logistic growth equation, with parameters for initial population size (N0), carrying capacity (K), growth rate (r), and lag phase (lag). If the time t is less than the lag, the population remains constant at N0.
 - The lag phase (lag) is randomly generated within a specified range (from 1 to 50). The growth rate is selected from a sequence between 0.01 and 0.5 to randomize the length of exponential phase.
 - The 't' vector represents time in days, ranging from 0 to 100, with a step size of 2 days. This is used to calculate the population at each time point.
 - The 'sapply' function applies the logistic_growth function to each time point t, calculating the population size for each value of t based on the parameters.
 - The 'plot' function creates a line graph showing how the population size changes over time, with the x-axis representing time (in days) and the y-axis representing population size.

## 3. Generating a dataframe with 100 different growth curves.
 - A dataframe 'growth_curve_df' is initialized with 100 rows and the same number of columns as the length of the time vector t. This will store the population data for 100 different growth curves.
 - The logistic growth function is defined, which calculates the population at each time point based on parameters like initial population size (N0), carrying capacity (K), growth rate (r), and lag phase (lag).
 - For each of the 100 iterations, the function randomly selects a growth rate (r) from a sequence between 0.01 and 0.5 and a lag phase (lag) from 1 to 50, ensuring that each growth curve is different.
 - In each iteration, the population at each time point is calculated using the logistic growth function, and the resulting population values are stored in the corresponding row of the growth_curve_df.
 - After 100 iterations, the dataframe growth_curve_df contains 100 different logistic growth curves, with each row representing the population over time for a different set of parameters.

## 4. Hamming distance.
  - The function 'hamming_distance' first checks if the two input strings (slack_name and x_name) have the same length. If they don't, it stops and returns an error message ("String mismatch").
  - A variable 'distance' is initialized and set to 0. This will be used to count the number of differing positions between the two strings.
  - The function then loops through each character of both strings using a for loop. For each character, it compares the characters at the same position in both strings.
  - If the characters at the same position are different, distance is increased by 1.
  - Finally, the output is printed as the total Hamming distance, which is the number of positions where the two strings differ.
