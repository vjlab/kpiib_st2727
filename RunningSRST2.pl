#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use Getopt::Long;

my $program= '';
my @files=();
my $output='';

my $TEMPLATE="template_SRST2.sh";


GetOptions(
    'program|p=s' => \$program,
    'files|f=s{,}' => \@files,
    'output|o=s' => \$output,	
     );


if(!-s$files[0]){warn "No file or file empty.\n";
  &usage();
  exit(1);
}


if(!$program){
  warn "No path of the program given.\n";
  &usage();
exit(1);
}


if(!$output){
  warn "No path of the output given.\n";
  &usage();
exit(1);
}


sub usage{
 print STDERR <<EOF;
 This script is used to run parallel jobs.
 
	--program  -p	
	--files    -f	 
	--output  -o
EOF
}

chomp($output);
chomp(@files);
my $cmd='';


foreach my $names(@files){
#fast__trimmer.fq
		if($names=~m/.*(K.+1.+fastq$)/){
				my $name=$1;
				my $name1=$1;


				my $name2=$name1=~s/1.fq_fast__trimmer.fq.fastq/2.fq_fast__trimmer.fq.fastq/r;
				
				#print ">>>>".$name2."\n";
				chomp($name);
				my $outputname=$name."_".$output;
				
  			 	my $JOBFILE="submit_$name.sh";
   				
				if($output eq 'no'){ $cmd=$program." ".$names;}else{$cmd=$program." ".$names." -o ".$outputname;}
 				
   				$cmd=~s/\//\\\//g;

   				#print("DEBUG: $cmd \n");
   				chomp($outputname);
				chomp($name2);
  				my $vim="vim -c \"1,\\\$s/outfile/".$outputname."/g\" -c \"1,\\\$s/file1/".$name."/g\" -c \"1,\\\$s/file2/".$name2."/g\" -c \"1,\\\$s/SRST2.Klebsiella/SRST2.".$name."/g\" -c \"wq\" ".${JOBFILE};

				#my $vim="vim -c \"1,\\\$s/file2/".$name2."\\r/g\" -c \"1,\\\$s/Velvet.Klebsiella/preproc.".$name."\\r/g\" -c \"wq\" ".${JOBFILE};

#srst2 --input_pe strainA_1.fastq.gz strainA_2.fastq.gz --output strainA_test --log --gene_db resistance.fasta
#srst2 --input_pe file1 file2 --output outfilet --log --gene_db resistance.fasta


  				#print("DEBUG: $vim \n\n");

   				system("cp ${TEMPLATE} ${JOBFILE}");

   				system("$vim");

               system("sbatch $JOBFILE");

				}
}


