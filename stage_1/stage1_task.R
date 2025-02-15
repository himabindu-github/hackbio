#stage_1_task

###### 1. Translate DNA to protein
# make a codon table to specify which codon represents which amino acid
# https://en.wikipedia.org/wiki/DNA_and_RNA_codon_tables#Standard_DNA_codon_table

dna_codon_table <- c(
  "TTT" = "F", "TTC" = "F", "TTA" = "L", "TTG" = "L",
  "CTT" = "L", "CTC" = "L", "CTA" = "L", "CTG" = "L",
  "ATT" = "I", "ATC" = "I", "ATA" = "I", "ATG" = "M", 
  "GTT" = "V", "GTC" = "V", "GTA" = "V", "GTG" = "V",
  "TCT" = "S", "TCC" = "S", "TCA" = "S", "TCG" = "S",
  "CCT" = "P", "CCC" = "P", "CCA" = "P", "CCG" = "P",
  "ACT" = "T", "ACC" = "T", "ACA" = "T", "ACG" = "T",
  "GCT" = "A", "GCC" = "A", "GCA" = "A", "GCG" = "A",
  "TAT" = "Y", "TAC" = "Y", "TAA" = "*", "TAG" = "*", 
  "CAT" = "H", "CAC" = "H", "CAA" = "Q", "CAG" = "Q",
  "AAT" = "N", "AAC" = "N", "AAA" = "K", "AAG" = "K",
  "GAT" = "D", "GAC" = "D", "GAA" = "E", "GAG" = "E",
  "TGT" = "C", "TGC" = "C", "TGA" = "*", "TGG" = "W",
  "CGT" = "R", "CGC" = "R", "CGA" = "R", "CGG" = "R",
  "AGT" = "S", "AGC" = "S", "AGA" = "R", "AGG" = "R",
  "GGT" = "G", "GGC" = "G", "GGA" = "G", "GGG" = "G"
)

# a function to translate DNA sequence to protein
translate <- function(dna_seq) {
  dna_seq <- toupper(dna_seq) # makes all the nucleotides to upper case
  protein <- c()
  # an empty vector is initiated. This is where the translated protein sequence is stored
  
  for (i in seq(1, nchar(dna_seq), by = 3)) {
    # for loop iterates over each element in a sequence created by seq().
    # here seq(1, nchar(dna_seq), by = 3) creates a sequence of indices starting from 1 and ending at length of dna_seq
    # by = 3 : sequence increment by 3 -> (1,4,7,10) : we are considering 3 nucleotides as an element and iterating over till the end of the sequence
    
    codon <- substring(dna_seq, i, i+2)
    # extracts a substring of length 3 ( i, i+1, i+2) after each iteration and assigns it to 'codon'
    # the given dna_seq is split into chunks of 3 nucleotides(triplet) and each chunk is assigned to 'codon'
    aminoacid <- dna_codon_table[codon]
    
    protein <- c(protein, aminoacid)
    # the aminoacid corresponding to each triplet in 'codon' is retrieved from dna_codon_table and added to vector 
    
    if (is.na(aminoacid)) { # returns "!" when invalid nucleotides are found in the dna seq
      protein <- c(protein, "!")
      next
    }
    
    if (aminoacid == "*" ){ # breaks the loop when a STOP codon is read.
      break
    }
  }
  
  print(paste(protein, collapse = ""))
}

translate("ATGGGGGATTTXGCCCTTTAAACCAATTTAAATGa")




###### 2a. Logistic growth

logistic_growth <- function(t, N0, K, r, lag) {
  if (t < lag) {
    return(N0)
  } else {
    return(K / (1 + ((K - N0) / N0) * exp(-r * (t))))
  }
}

# t: time in days
# N0: initial population size at time = 0.
# K: carrying capacity, or the maximum population size the environment can support.
# r0: growth rate

# Setting the parameters
N0 <- 10  
K <- 100  
r <- sample(seq(0.01, 0.5, by = 0.1),1) # randomized growth rate
t <- seq(0, 100, by = 2)  
lag <- sample(1:50, 1) # randomized lag phase

# population size at each time point
population <- sapply(t, logistic_growth, N0 = N0, K = K, r = r, lag = lag)
# N0 = N0... used named arguments to avoid issues with the order of parameters

# Plot the logistic growth curve
plot(t, population, type = "l", col = "blue", xlab = "Time(days)", ylab = "Population Size", main = "Logistic Population Growth Curve")

###### 2b. Generate a dataframe with 100 different growth curves

# Creating an empty data frame to store the growth curves data(100)
growth_curve_df <- data.frame(matrix(NA, ncol = length(t), nrow = 100)) 

# Defining the logistic growth function 
logistic_growth <- function(t, N0, K, r, lag) { 
  if (t < lag) {
    return(N0)
  } else {
    return(K / (1 + ((K - N0) / N0) * exp(-r * (t))))
  }
}
# t: time in days
# N0: initial population size at time = 0.
# K: carrying capacity, or the maximum population size the environment can support.
# r0: growth rate

# iterating 100 times to generate a dataframe of 100 growth curves
for (i in 1:100) { 
  
  # Setting the parameters
  N0 <- 10  
  K <- 100  
  r <- sample(seq(0.01, 0.5, by = 0.1),1) # randomized growth rate
  t <- seq(0, 500, by = 10)  
  lag <- sample(1:50, 1) # randomized lag phase
  
  # population size at each time point
  population <- sapply(t, logistic_growth, N0 = N0, K = K, r = r, lag = lag)
  
  growth_curve_df[i, ] <- population 
  # in each loop iteration, after calculating the population for the current curve, the resultis stored in the i-th row of the growth_curve_df.
  # in simpler terms, after 1st iteration, population for curve 1 is stored in 1st row
  # after 2nd iteration, population data for curve 2 is stored in 2nd row
  # this continues until 100th iteration
  
  # Plotting the logistic growth curve
  #plot(t, population, type = "l", col = "blue", xlab = "Time(days)", ylab = "Population Size", main = "Logistic Population Growth Curve")
}

# change rownames to gc_1, gc_2 etc(growthcurve_1)
rownames(growth_curve_df) = paste("gc_", 1:nrow(growth_curve_df), sep = "")

# change column names to t1, t2..(timepoint1, timepoint2..)
colnames(growth_curve_df) <- paste("t", 1:ncol(growth_curve_df), sep = "")

print(growth_curve_df)


##### 2c. Function to determine time taken to reach 80%

logistic_growth_80 <- function(Nt, N0, K, r) {
    return(-(1 / r) * log((N0 * (K - Nt)) / (Nt * (K - N0))))
}
# Setting the parameters
N0 <- 20  
K <- 100  
r <- 0.2
Nt <- 0.8 * K

# population size at each time point
time <- logistic_growth_80(Nt, N0, K, r)
print(time)





###### 3. Hamming distance

hamming_distance <- function(slack_name, x_name) {
  if (nchar(slack_name) != nchar(x_name)) {
    stop("String mismatch") # returns error statement if the two strings are not of same length
  }
  distance <- 0  # set the initial value of distance
  for (i in 1:nchar(slack_name)) { # for each element in the string
    if (substr(slack_name, i, i) != substr(x_name, i, i)) { # if each of the elements in the strings are not the same 
      distance <- distance + 1
    }
  }
  print(paste("Hamming distance =", distance))
}




