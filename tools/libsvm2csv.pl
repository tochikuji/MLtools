#!/usr/bin/env perl

# convert libsvm formatted dataset into csv
# Usage:
# perl libsvm2csv.pl <input1> <input2> ...
# Example:
# perl libsvm2csv.pl Training.libsvm # CSV will appear in STDOUT
# # if multiple arguments were specified, data will be concatenated like `cat`
# perl libsvm2csv.pl training test # concatenate 2 data into 1 csv

for my $f (@ARGV){
  open FH, $f;
  for(<FH>){
    s/\s+(?:\d+:)?/,/g;
    chop;
    print $_.$/;
  }
}
