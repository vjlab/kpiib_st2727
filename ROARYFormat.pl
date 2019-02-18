#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use Getopt::Long;


my @FNA = ();
my @GFF = ();


GetOptions(
    'FNA|f=s{,}'   => \@FNA,
    'GFF|g=s{,}'   => \@GFF,
	);


 if(!$FNA[0]){
  warn "No fna files. Can not continue.\n";
 &usage();
 exit(1);
 }
 
 if(!$GFF[0]){
  warn "No gff files. Can not continue.\n";
 &usage();
 exit(1);
 }


	sub usage{
	print '
 This script is used to preparate the input files for ROARY.
	--FNA -f path of FNA files (extension fna/fasta).
	--GFF -g path of GFF files (extension gff/gff3).
'
}


my %hash1;
my %hash2;
my @names=();

 print "Creating folder output GFF.FNA.ForROARY\n";
system("mkdir GFF.FNA.ForROARY");

$FNA[0]=~m/(.+\/)(.+)(\.fna|\.fasta)$/;
my $pathFNA= $1;

$GFF[0]=~m/(.+\/)(.+)(\.gff|\.gff3|\.gtf)$/;
my $pathGFF= $1;


        foreach my $FNA(@FNA){
            $FNA=~m/.+\/(.+)(\.fna|\.fasta)$/;
                my $name1=$1;
                push(@names,$name1); 
                $hash1{$name1}=$name1;
                }


                
        foreach my $GFF(@GFF){
            $GFF=~m/.+\/(.+)(\.gff|\.gff3|\.gtf)$/;
                my $name2=$1; 
                $hash2{$name2}=$name2;
                }
                 


                 foreach my $name(@names){
 print "Processing $name\n";                 
                 if(exists $hash1{$name} &&  $hash2{$name}){
    		my $x="$pathFNA"."/"."$name".".f*";
    		my $y="$pathGFF"."/"."$name".".g*";
     print "Processing $name output $name".".addedfasta.gff\n";
                        system("\(cat $y ; echo '##FASTA'; cat $x\) >GFF.FNA.ForROARY/$name.addedfasta.gff");              
                }
   
}
