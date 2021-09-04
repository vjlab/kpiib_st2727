#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use Getopt::Long;

my $program= '';
my @files=();
my $output='';

my $TEMPLATE="template_submit.sh";


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


my $cmd='';


foreach my $names(@files){

		if($names=~m/.*(KP.+)/){
				my $name=$1;
				chomp($name);
				my $outputname=$name."_".$output;

  			 	my $JOBFILE="submit_$name.sh";

				if($output eq 'no'){ $cmd=$program." ".$names;}else{$cmd=$program." ".$names." -o ".$outputname;}

   				$cmd=~s/\//\\\//g;

   				#print("DEBUG: $cmd \n");

  				my $vim="vim -c \"1,\\\$s/PROGRAM/".$cmd."\\r/g\" -c \"1,\\\$s/fastQC.sample/preproc.".$name."\\r/g\" -c \"wq\" ".${JOBFILE};

  				#print("DEBUG: $vim \n\n");

   				system("cp ${TEMPLATE} ${JOBFILE}");

   				system("$vim");

               system("sbatch $JOBFILE");

				}
}
