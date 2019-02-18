# LargePhylogenyBacteria
These steps are to process up to 3000-4000 genomes of bacteria with genomic sizes of ~4Mpb-8Mpb  

Generate the core genome alignment using ROARY 
https://sanger-pathogens.github.io/Roary/

Prepare the input files for ROARY:

./ROARYFormat.pl -f FNA/\*.fna -g GFF/\*.gff

ROARYFormat.pl concatenates the gff and fna files. 

Run Roary

roary -f KlebsiellaCompleteGenomes -p 16 -e -n  -s -ap --group_limit 200000 -v GFF.FNA.ForROARY/\*gff

Run Phylogeny

raxmlHPC-PTHREADS-SSE3 -T 16 -f a -s KlebsiellaCompleteGenomes/core_gene_alignment.aln  -m GTRGAMMA  -x 12345 -p 12345 -# autoMRE -n KlebsiellaCompleteGenomesPhylo.GAMMA

Metadata for all genomes
ftp://ftp.ncbi.nlm.nih.gov/biosample/

Parsing XML to get Metadata

./XML2Table.pl Biosample.files/*xml >BioSampleKlebsiella.txt

Prune and plot tree

R 
source("Function.PruneLArgeTRee.r")


Calculating Evolutionary rate. LSD
http://www.atgc-montpellier.fr/LSD/

 ./lsd -i KpIIB.LSD.nwk -d Metadata.KpIIB.txt -c -v 1 -f 100 -s 500000



