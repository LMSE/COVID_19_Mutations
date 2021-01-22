# The COVID_19_Mutation Package
This package is developed to identify mutations on SARS-CoV-2 receptor binding domain (RBD).
severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2) is responsible for the outbreak of COVID-19, which began in China in December 2019. 
> The SARS-CoV-2 RBD plays the most important roles in viral attachment, fusion and entry, and serves as a target for development of antibodies, entry inhibitors and vaccines ([Tai W, et al. 2020](https://www.nature.com/articles/s41423-020-0400-4)).

The user may submit **nucleotide** sequences of any species to this package and perform mutational analysis.

## Package Requirements
-	developed by ***MATLAB R2020a***.
-	To run the code, we recommend that the user make sure the Bioinformatics toolbox is installed on MATLAB ([read more](https://www.mathworks.com/products/bioinfo.html)).
-	All the nucleotide sequences must be submmited in the **FASTA format**.
-	The user must prepare the input to this package according to their objectives.
	
## Steps for Preparing the **Input**
- [x] Download nucleotide sequences for any species, such as SARS-COV-2 patient samples, available on the [GISAID database](https://www.gisaid.org/).
- [x] Copy the dataset to the *COVID_19_Mutations\Input* directory.
- [x] Download a standard nucleotide sequence from NCBI and copy it to the *COVID_19_Mutations\Input* directory. (As a default, SARS-CoV-2 sequence is provided in this directory)
- [x] Should the user seek to map mutations’ location to the protein structure, a FASTA file of the PDB structure must be provided in the *COVID_19_Mutations\Input* directory. (As a default, the PDF file for SARS-CoV-2 spike protein is provided in this directory).
- [x] Open MATLAB and add *COVID_19_Mutations\CODE\Functions* to the path.
- [x] Run *COVID_19_Mutations\CODE\main.m* script.
	
## Package Workflow/ Output
-	Input sequences are refined to remove any duplicate eneteries, and animal samples.
-	Meta data (Country and date) of submited sequences is mined and stored.
-	This package will generate a database of submitted nucleotide sequences along with their three reading frames (This step can take up to two days for large input files on PC)
-	This database is then saved in the COVID_19_Mutation/Output/database directory.
- 	The main reading frame of the standard sequence will also be generated.
-	Nucleotide sequences and Three reading frames are locally aligned to the standard sequences.(This step can take up to three days for large input files on personal PC)
-	Sequences that do not show any mutations are then removed. Also a reading frame that matches the standard amino acid sequence is selected.
-	Mutated Sequences are then saved in the COVID_19_Mutation/Output directory.
-	Data is also stored in several tables of an Excel file that can be access in the COVID_19_Mutation/Output directory.

## Generated Excel File
The generated Excel file comprises several sheets, discribed below:
1. **Nucleotid Seq** Sheet: Comprises identified Mutations on submitted nucleotide sequences.
2. **Amino Acid Seq** Sheet: Comprises identified Mutations on amino acid sequences.
3. **Nucleotide Frequency** Sheet: Comprises the frequency of Nucleotide mutations across the submitted dataset.
4. **Amino Acid Frequency** Sheet: Comprises the frequency of Amino Acid mutations across the submitted dataset.
5. **NT Location Frequency** Sheet: Comprises the frequency of mutations' location across the nucleotide sequences.
6. **AA Location Frequency** Sheet: Comprises the frequency of mutations' location across the nucleotide sequences.
7. **Country Frequency** Sheet: the frequency of Amino Acid mutations per each country.

## Contact Information
Should you face any question, please do not hesitate to contact me via
- Email: [Kiana.haddadi@mail.utoronto.ca](mailto:kiana.haddadi@mail.utoronto.ca?subject=[GitHub]%20COVID_19%20Mutation)
- Tel: +1 (437) 236 6459


	
