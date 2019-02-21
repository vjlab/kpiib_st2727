#Forensic genomics of Klebsiella from an NICU outbreak in China reveals patterns of genetic diversity, evolution and epidemiology

Here we explain the bioinformatic steps for the characterization and evolution analysis of 22 isolates of Klebsiella. For those the characterization of virulent and resistant markers, as well as secretion systems was done. The evolutionary analysis included 4082 publicly available genomes of Klebsiella.

#Sequence data processing (Illumina)

1. Quality Control with Fastqc command line

Using the tool FastQC we determined the quality of the sequences. Here are the steps to run this parallel in a HPC machine.

You can find FastQC here: http://www.bioinformatics.babraham.ac.uk/projects/download.html#fastqc

After installing FastQC,  

Generate the core genome alignment using ROARY
https://sanger-pathogens.github.io/Roary/

Prepare the input files for ROARY:

`./ROARYFormat.pl -f FNA/\*.fna -g GFF/\*.gff`

ROARYFormat.pl concatenates the gff and fna files.

Run Roary

`roary -f KlebsiellaCompleteGenomes -p 16 -e -n  -s -ap --group_limit 200000 -v GFF.FNA.ForROARY/\*gff`


#Phylogeny Analysis
Run Phylogeny

`raxmlHPC-PTHREADS-SSE3 -T 16 -f a -s KlebsiellaCompleteGenomes/core_gene_alignment.aln  -m GTRGAMMA  -x 12345 -p 12345 -# autoMRE -n KlebsiellaCompleteGenomesPhylo.GAMMA`


#Metadata for all genomes
ftp://ftp.ncbi.nlm.nih.gov/biosample/

Parsing XML to get Metadata

`./XML2Table.pl Biosample.files/\*xml >BioSampleKlebsiella.txt`

#Post Processing Tree

Prune and plot tree

This R function prune the tree removing branches with repetitive lengths. Additionally
you can keep or drop tips that you wish. If variables keep and drop are NULL only the
tips with unique branches are kept.

R
`source("Function.PruneLargeTRee.r")\n
prune.Large.Tree(tree,keep,drop)`

tree: is a phylogenetic tree
keep: a vector with tips to keep no matter if the length of the branch already exists
drop: a vector with tips to avoid
Calculating Evolutionary rate. LSD
http://www.atgc-montpellier.fr/LSD/

#Time-Calibrated Tree

 `./lsd -i KpIIB.LSD.nwk -d Metadata.KpIIB.txt -c -v 1 -f 100 -s 500000`
