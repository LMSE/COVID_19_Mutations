# The COVID_19_Mutation Package
This package is developed to identify mutations on SARS-CoV-2 receptor binding domain (RBD).
severe acute respiratory syndrome coronavirus 2 (SARS-CoV-2) is responsible for the outbreak of COVID-19, which began in China in December 2019. 
The SARS-CoV-2 RBD plays the most important roles in viral attachment, fusion and entry, and serves as a target for development of antibodies, 
entry inhibitors and vaccines [1].
![SARS-CoV-2 Outbreak](https://www.google.com/search?q=covid+19+outbreak&tbm=isch&ved=2ahUKEwjirqXHrbDuAhUOFc0KHZe4CicQ2-cCegQIABAA&oq=covid+19+outbreak&gs_lcp=CgNpbWcQAzICCAAyAggAMgIIADICCAAyAggAMgIIADICCAAyAggAMgIIADICCAA6BwgAELEDEEM6BAgAEEM6BQgAELEDUNGIAViJmQFg_5oBaABwAHgAgAGrAYgBzQeSAQM3LjKYAQCgAQGqAQtnd3Mtd2l6LWltZ8ABAQ&sclient=img&ei=VzILYKKnJY6qtAaX8aq4Ag&bih=646&biw=1280&client=firefox-b-d#imgrc=il8v66aGBHIGQM)
The user may submit **nucleotide** sequences of any species to this package and perform mutational analysis.

## Package Requirements
	*	developed by *MATLAB R2020a*.
	*	To run the code, we recommend that the user make sure the Bioinformatics toolbox is installed on MATLAB ([read more](https://www.mathworks.com/products/bioinfo.html)).
	*	All the nucleotide sequences must be submmited in the **FASTA format**.
	*	The user must prepare the input to this package according to their objectives.
	
## Steps for Preparing the **Input**
	1.	Download nucleotide sequences for any species, such as SARS-COV-2 patient samples, available on the [GISAID database](https://www.gisaid.org/).
	2.	Copy the dataset to the COVID_19_Mutations\Input directory.
	3.	Download a standard nucleotide sequence from NCBI and copy it to the COVID_19_Mutations\Input directory. (As a default, SARS-CoV-2 sequence is provided in this directory)
	4.	Should the user seek to map mutations’ location to the protein structure, a FASTA file of the PDB structure must be provided in the COVID_19_Mutations\Input directory. (As a default, the PDF file for SARS-CoV-2 spike protein is provided in this directory).
	5.	Open MATLAB and add COVID_19_Mutations\CODE\Functions to the path.
	6.	Run COVID_19_Mutations\CODE\main.m script.
	
## Package Workflow/ Output
	*	Input sequences are refined to remove any duplicate eneteries, and animal samples.
	*	Meta data (Country and date) of submited sequences is mined and stored.
	*	This package will generate a database of submitted nucleotide sequences along with their three reading frames (This step can take up to two days for large input files on PC)
	*	This database is then saved in the COVID_19_Mutation/Output/database directory.
	* 	The main reading frame of the standard sequence will also be generated.
	*	Nucleotide sequences and Three reading frames are locally aligned to the standard sequences.(This step can take up to three days for large input files on personal PC)
	*	Sequences that do not show any mutations are then removed. Also a reading frame that matches the standard amino acid sequence is selected.
	*	Mutated Sequences are then saved in the COVID_19_Mutation/Output directory.
	*	Data is also stored in several tables of an Excel file that can be access in the COVID_19_Mutation/Output directory.

## Generated Excel File
The generated Excel file comprises several sheets, discribed below:
	1. ** Nucleotid Seq Sheet: ** Identified Mutations on submitted nucleotide sequences are listed in this sheet.
		*	 
		*	column score discribes the similarity score of sub'pam250'
		
## references

	