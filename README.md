# Forensic genomics of a novel _Klebsiella quasipneumoniae_ type from an NICU in China reveals patterns of genetic diversity, evolution and epidemiology

Laura Perlaza-Jiménez<sup>1,2</sup>, Qing Wu<sup>1</sup>,  Von Vergel L. Torres<sup>2</sup>, Xiaoxiao Zhang<sup>3</sup>,  Jiahui Li<sup>1</sup>, Andrea Rocker<sup>2</sup>, PhD.,Trevor Lithgow<sup>2</sup>, Tieli Zhou<sup>1</sup>, Dhanasekaran Vijaykrishna<sup>1,2</sup>
<sup>1</sup>The First Affiliated Hospital of Wenzhou Medical University, Wenzhou, China
<sup>2</sup> Monash University, Victoria, Australia
<sup>3</sup> Women’s Hospital School of Medicine Zhejiang University, Hangzhou, China

## Abstract
During March of 2017 a neonate patient suffered severe diarrhea and subsequently developed septicemia and died, with Klebsiella isolated as the causative microorganism. Coincident illness of an attending staff member and three other neonates with Klebsiella triggered a response, leading to a detailed microbiological and genomics investigation of isolates collected from the staff member and all 21 co-housed neonates. Multilocus sequence typing and genomic sequencing identified that the Klebsiella from all 21 neonates was a new MLST ST2727, and belonged to a less frequently detected subspecies K. quasipneumoniae subsp. similipneumoniae (KpIIB). Genomic characterization showed that the isolated ST2727 strains had diverged from other KpIIB strains at least >90 years ago, whereas the neonate samples were highly similar with a genomic divergence of 3.6 months and not related to the staff member, indicating that transmission did not occur from staff to patient or between patient to patient, but were acquired from a common hospital source. The genomes revealed that the isolates contained the ubiquitous ampH gene responsible for resistance to penicillin G, cefoxitin and cephalosporin C, and all Kp-IIB strains were competent for host cell adhesion. Our results highlight the clinical significance and genomic properties of relatively mild, but persistent MLST types such as ST2727, and urges for genomic surveillance and eradication within hospital environments.

## Methods
The protocols used to process NGS data generated from 22 clinical isolates of _K. quasipneumoniae_ is provided below. The evolutionary analysis included 4082 publicly available genomes of _Klebsiella_.

### Processing Illumina data
Steps to reproduce sequence data processing on a HPC machine with queue system.

#### Quality control using [FastQC][http://www.bioinformatics.babraham.ac.uk/projects/download.html#fastqc]
* Steps described below are for processing data on a HPC machine with a queue system. Run  [`Running_Arrayjobs.pl`](Running_Arrayjobs.pl) to generate individual ‘jobs’ for each isolate. `template_submit.txt` should include the specifications of your HPC and should be within the run folder. This example is for a SLURM system, but can be modified for SGE. A caution to not delete the word PROGRAM.
- run FastQC for all files using:
`./Running_Arrayjobs.pl -f \*fq -p fastqc -o fastQC.results`
- FastQC outputs provides quality  measures. However, problematic samples can be identified using *grep* the word "FAIL" or "WARN" on the summary.txt outputs for all your files.
`grep "FAIL" \*fastQC.results/summary.txt`
`grep "WARN" \*fastQC.results/summary.txt`
- If required, trim sequences using [FastX-toolskit][http://hannonlab.cshl.edu/fastx%5C_toolkit/download.html]. To run in parallel:
`./Running_Arrayjobs.pl -p "fastx_trimmer -Q33 -f20 -v -i" -f ../RawData/\*fq -o fast.trimmer.fq`
Modify content between the quotes to specify the details of your trimming.
- Repeat FastQC to check your quality.

#### Assembly using [SPAdes][http://cab.spbu.ru/software/spades/]
`./RunningSPAdes.pl -f \*fast__trimmer.fq -p n -o SPAdesoutput`

#### Generate scaffolds using [Medusa][https://github.com/combogenomics/medusa]
`java -jar medusa.jar -f ST2727reference/ -i KP1_1.fq_fast__trimmer.fq_SPAdesoutput.fasta -v`

#### Organizing scaffoldings using [Mauve][http://darlinglab.org/mauve/mauve.html]
`java -Xmx500m -cp Mauve.jar org.gel.mauve.contigs.ContigOrderer -output KP9_ST23.CP030172.1 -ref  ST23.CP030172.1.fasta -draft KP9_1.fq_fast.trimmer_Velvetoutput.fa`

### Download publicly available _Klebsiella_  genomes
[source][http://www.metagenomics.wiki/tools/fastq/ncbi-ftp-genome-download]
`wget ftp://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt`
`grep -E "Klebsiella" assembly_summary_refseq.txt | cut -f 8,9,14,15,16 >list`
`grep -E "Klebsiella" assembly_summary_refseq.txt | cut -f 20 >ftp_folder.txt`

`awk 'BEGIN{FS=OFS="/";filesuffix="genomic.fna.gz"}{ftpdir=$0;asm=$10;file=asm"\_"filesuffix;print "wget "ftpdir,file}' ftp_folder.txt > download_fna_files.sh`

`awk 'BEGIN{FS=OFS="/";filesuffix="genomic.gff.gz"}{ftpdir=$0;asm=$10;file=asm"\_"filesuffix;print "wget "ftpdir,file}' ftp_folder.txt > download_gff_files.sh`

`source download_fna_files.sh`

`source download_gff_files.sh`

### Phylogenetic analysis
#### Generate core genome alignment using [ROARY][https://sanger-pathogens.github.io/Roary/]
- Prepare the input files for ROARY using: `./ROARYFormat.pl -f FNA/\*.fna -g GFF/\*.gff`
- ROARYFormat.pl concatenates the gff and fna files.
- Run Roary `roary -f KlebsiellaCompleteGenomes -p 16 -e -n  -s -ap --group_limit 200000 -v GFF.FNA.ForROARY/\*gff`

#### Generate phylogenies using [RAxML][https://github.com/stamatak/standard-RAxML]
`raxmlHPC-PTHREADS-SSE3 -T 16 -f a -s KlebsiellaCompleteGenomes/core_gene_alignment.aln  -m GTRGAMMA  -x 12345 -p 12345 -# autoMRE -n KlebsiellaCompleteGenomesPhylo.GAMMA`

#### Metadata for all genomes
- Get metadata information from the publicly available genomes using `wget ftp://ftp.ncbi.nlm.nih.gov/biosample/biosample\_set.xml.gz`
- Parsing XML to outbrain Metadata`./XML2Table.pl Biosample.files/\*xml >BioSampleKlebsiella.txt`

#### Post Processing tree using R
`source("Function.PruneLargeTRee.r")`
`prune.Large.Tree(tree,keep,drop)`
- **tree**: is a phylogenetic tree; **keep**: a vector with tips to include, even if duplicates exists; **drop**: a vector with tips to ignore
- If variables keep and drop are NULL only the tips with unique branches are kept.

#### Generating time-calibrated tree using [LSD][http://www.atgc-montpellier.fr/LSD/]
 `./lsd -i KpIIB.LSD.nwk -d Metadata.KpIIB.txt -c -v 1 -f 100 -s 500000`
