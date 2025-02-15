# Stage_1 task: All about functions


## 1. Translate a DNA sequence to protein.
    This is a summary of the steps implemented
 - Creating a Named Vector for Codons: First a named vector, dna_codon_table, mapping each DNA codon to its corresponding amino acid was created.

 - Managing Case: Processed the DNA sequence by converting it to uppercase to maintain consistency.

 - Translating Codons to Amino Acids: Iterated through the DNA sequence in triplets (codons), using the named vector to retrieve the corresponding amino acid for each codon. (and generated the protein sequence)

 - Handling Invalid Codons and Stop Signals: Added checks for invalid codons (represented by NA or invalid characters), replacing them with "!", and halted translation when a stop codon (*) was encountered.
