# LargePhylogenyBacteria
These steps are to process up to 3000-4000 genomes of bacteria with genomic sizes of ~4Mpb-8Mpb  

Generate the core genome alignment using ROARY 
https://sanger-pathogens.github.io/Roary/

Prepare the input files for ROARY:

./ROARYFormat.pl -f FNA/\*.fna -g GFF/\*.gff

ROARYFormat.pl concatenates the gff and fna files. 

Run Roary

roary -f KlebsiellaCompleteGenomes -p 16 -e -n  -s -ap --group_limit 200000 -v GFF.FNA.ForROARY/\*gff


