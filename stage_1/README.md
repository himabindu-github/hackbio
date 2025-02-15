# Stage_1 task: All about functions


## 1. Translate a DNA sequence to protein.
    This is a summary of the steps implemented
 - Created a translate Function: A function that takes a DNA sequence and translates it into a corresponding protein sequence. The function processes the DNA codons by mapping them to amino acids using a named vector(codon table).

 - Managing Case: Processed the DNA sequence by converting it to uppercase to maintain consistency.

 - Translating Codons to Amino Acids: Iterated through the DNA sequence in triplets (codons), using the named vector to retrieve the corresponding amino acid for each codon. (and generated the protein sequence)

 - Handling Invalid Codons and Stop Signals: Added checks for invalid codons (represented by NA or invalid characters), replacing them with "!", and halted translation when a stop codon (*) was encountered.
