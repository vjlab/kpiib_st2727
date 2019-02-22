# Forensic genomics of Klebsiella from an NICU outbreak in China reveals patterns of genetic diversity, evolution and epidemiology

Here we explain the bioinformatic steps for the characterization and evolution analysis of 22 isolates of Klebsiella. For those, the characterization of virulent and resistant markers, as well as secretion systems was done. The evolutionary analysis included 4082 publicly available genomes of Klebsiella.

# Sequence data processing (Illumina paired-end)

Quality Control with Fastqc command line

Using the tool FastQC we determined the quality of the sequences. Here are the steps to run this in parallel in a HPC machine with a queue system.

You can find FastQC here: http://www.bioinformatics.babraham.ac.uk/projects/download.html#fastqc

After installing FastQC, use Running_Arrayjobs.pl to generate a individual job for each isolate. Download template_submit.txt file and put it in the same folder. Plese notice that template_submit.txt file should have the specifications of your machine. This example is for SLURM system, but can be change to SGE. Just have in mind to not delete the word PROGRAM on it.

Run FastQC for all files

`./Running_Arrayjobs.pl -f \*fq -p fastqc -o fastQC.results`

You can have a detailed look by checking the graphical outputs of FastQC. However, if you want to have a fast look of only the problematic results, you can *grep* the word "FAIL" or "WARN" through the summary.txt outputs for all your files.

`grep "FAIL" \*fastQC.results/summary.txt`

`grep "WARN" \*fastQC.results/summary.txt`

If needed, trim the sequences using FastX-toolskit: http://hannonlab.cshl.edu/fastx_toolkit/download.html
You can also do this in parallel running:

`./Running_Arrayjobs.pl -p "fastx_trimmer -Q33 -f20 -v -i" -f ../RawData/\*fq -o fast.trimmer.fq`

Between the quotes put the details of your trimming.

Double check your quality running FastQC again.

Use SPAdes to assemble: http://cab.spbu.ru/software/spades/


`./RunningSPAdes.pl -f \*fast__trimmer.fq -p n -o SPAdesoutput`

Generating scaffoldings

Medusa
`java -jar medusa.jar -f ST2727reference/ -i KP1_1.fq_fast__trimmer.fq_SPAdesoutput.fasta -v `

Organizing scaffoldings

Mauve

`java -Xmx500m -cp Mauve.jar org.gel.mauve.contigs.ContigOrderer -output KP9_ST23.CP030172.1 -ref  ST23.CP030172.1.fasta -draft KP9_1.fq_fast.trimmer_Velvetoutput.fa`

# Download all genomes publicly available

source http://www.metagenomics.wiki/tools/fastq/ncbi-ftp-genome-download

`wget ftp://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt`
`grep -E "Klebsiella" assembly_summary_refseq.txt | cut -f 8,9,14,15,16 >list`
`grep -E "Klebsiella" assembly_summary_refseq.txt | cut -f 20 >ftp_folder.txt`

`awk 'BEGIN{FS=OFS="/";filesuffix="genomic.fna.gz"}{ftpdir=$0;asm=$10;file=asm"\_"filesuffix;print "wget "ftpdir,file}' ftp_folder.txt > download_fna_files.sh`

`awk 'BEGIN{FS=OFS="/";filesuffix="genomic.gff.gz"}{ftpdir=$0;asm=$10;file=asm"\_"filesuffix;print "wget "ftpdir,file}' ftp_folder.txt > download_gff_files.sh`

`source download_fna_files.sh`

`source download_gff_files.sh`


# Phylogenetic Analysis

First generate the core genome alignment using ROARY
https://sanger-pathogens.github.io/Roary/

Prepare the input files for ROARY:

`./ROARYFormat.pl -f FNA/\*.fna -g GFF/\*.gff`

ROARYFormat.pl concatenates the gff and fna files.

Run Roary

`roary -f KlebsiellaCompleteGenomes -p 16 -e -n  -s -ap --group_limit 200000 -v GFF.FNA.ForROARY/\*gff`

Run Phylogeny

`raxmlHPC-PTHREADS-SSE3 -T 16 -f a -s KlebsiellaCompleteGenomes/core_gene_alignment.aln  -m GTRGAMMA  -x 12345 -p 12345 -# autoMRE -n KlebsiellaCompleteGenomesPhylo.GAMMA`


# Metadata for all genomes
Get metadata information from the publicly available genomes

wget ftp://ftp.ncbi.nlm.nih.gov/biosample/biosample_set.xml.gz

Parsing XML to get Metadata

`./XML2Table.pl Biosample.files/\*xml >BioSampleKlebsiella.txt`

# Post Processing Tree

Prune and plot tree

This R function prune the tree removing branches with repetitive lengths. Additionally
you can keep or drop tips that you wish. If variables keep and drop are NULL only the
tips with unique branches are kept.

R
`source("Function.PruneLargeTRee.r")`

`prune.Large.Tree(tree,keep,drop)`

tree: is a phylogenetic tree
keep: a vector with tips to keep no matter if the length of the branch already exists
drop: a vector with tips to avoid

# Time-Calibrated Tree

Find the LSD program here: http://www.atgc-montpellier.fr/LSD/

 `./lsd -i KpIIB.LSD.nwk -d Metadata.KpIIB.txt -c -v 1 -f 100 -s 500000`
