#!/usr/bin/env perl

# Diagnose jpeg files and remove corrupted jpeg file recursively.
# This checks only jpeg headers (SOI and EOI).
# Usage:
# perl jpgdiag.pl . # list corrupted jpeg files in current path
# perl jpgdiag.pl -dv . # delete all corrupted jpeg file with verbose reports

use strict;
use warnings;
use File::Find qw/find/;
use feature qw/say/;

# parse arguments
my ($verbose, $deletion, $path);
my $option = '';
for(@ARGV){
  # concat options
  if(m/^\-/){
    $option .= $_;
  } else {
    # last arguments not an option is root path
    $path = $_;
  }
}

$verbose = $option =~ m/v/ ? 1 : 0;
$deletion = $option =~ m/d/ ? 1 : 0;


my @files;
find(sub{push @files, $File::Find::name if m/\.jpe?g/i;}, $path);
@files = sort @files;

my $count = 0;

for my $f (@files){
  my $is_corrupted = 0;

  my $detect = sub {
    print "CORRUPT: $f ... ";

    if($deletion){
      if(unlink $f){
        say "removed.";
      } else {
        say "but ignored."
      }
    }

    ++$count;
  };

  open FH, "<$f" or die $!;
  binmode FH;
  my $jpeg = join('', <FH>);
  close FH;

  if(length($jpeg) < 8){
    $detect->();
    if($verbose){
      say "\ttoo short file."
    }
  }

  if(substr($jpeg, 0, 2) ne "\xFF\xD8"){
    $detect->();
    if($verbose){
      say "\tno SOI marker."
    }
  }

  if(substr($jpeg, -2) ne "\xFF\xD9"){
    $detect->();
    if($verbose){
      say "\tno EOI marker."
    }
  }
}

say "$count corrupted file were detected.";

1;
