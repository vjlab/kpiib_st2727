#!/bin/perl -w
use strict;
use diagnostics;
use lib "/home/lper0012/bm14_scratch/Laura/BioSamplesParsing/XML-Simple-2.25/lib/";
use XML::Simple;
use Data::Dumper;

# load the lists document
my @files=@ARGV;

foreach my $file(@files){
#print "Processing $file\n";


my $simple = XML::Simple->new( );             # initialize the object
my $tree = $simple->XMLin( $file );   # read, store document

#print Dumper ($tree);

print "$file\t";
 print  "$tree->{accession}\t";


# 'submission_date' => '2013-05-07T11:34:26.030',

print "$tree->{submission_date}\t";

 my $taxa = $tree->{Description}{Organism};
  foreach my $key0 (keys %$taxa) {
   print "$key0\t$taxa->{$key0}\t";
    }


 if(ref($tree->{Ids}{Id}) eq 'ARRAY'){
	 foreach my $key1 (@{$tree->{Ids}{Id}})
 	{
	 if(exists $key1->{db}){print "$key1->{db}\t";}
 	if(exists $key1->{content}){print "$key1->{content}\t";}
        }
	
  }else{ my $Ids = $tree->{Ids}{Ids};
  		foreach my $key11 (keys %$Ids) {
   		print "$key11\t$Ids->{$key11}\t";

		}
	}





  if(ref($tree->{Attributes}{Attribute}) eq 'ARRAY'){
 	foreach my $key2 (@{$tree->{Attributes}{Attribute}})
 	{
	if(exists $key2->{attribute_name}){print "$key2->{attribute_name}\t";}
    	if(exists $key2->{content}){	print "$key2->{content}\t";}

 	}
   }else{  my $Attribute = $tree->{Attributes}{Attribute};
  		foreach my $key3 (keys %$Attribute) {
   		print "$key3\t$Attribute->{$key3}\t";
    	}
    }

print "\n";
}










