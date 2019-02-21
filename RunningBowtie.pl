#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use Getopt::Long;

my $program= '';
my @files=();
my $output='';

#my $TEMPLATE="template_bowtie.sh";
my $TEMPLATE="template_bowtiePlasmid.sh";

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
		if($names=~m/.*(K.+1.fq_fast__trimmer.fq)$/){
				my $name=$1;
				my $name1=$1;
				  my $name2=$name1=~s/1.fq_fast__trimmer.fq/2.fq_fast__trimmer.fq/r;
				chomp($name);
				my $outputname=$name."_".$output;
				
  			 	my $JOBFILE="submit_$name.sh";
   				
				if($output eq 'no'){ $cmd=$program." ".$names;}else{$cmd=$program." ".$names." -o ".$outputname;}
 				
   				$cmd=~s/\//\\\//g;

  				my $vim="vim -c \"1,\\\$s/outfile/".$outputname."/g\" -c \"1,\\\$s/file2/".$name2."/g\" -c \"1,\\\$s/file1/".$name."/g\" -c \"wq\" ".${JOBFILE};

   				system("cp ${TEMPLATE} ${JOBFILE}");

   				system("$vim");

             system("sbatch $JOBFILE");

				}
}


