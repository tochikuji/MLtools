#!/usr/bin/env perl

# chainer's LabeledImageDataset or Caffe formatted dataset generation script
# which find image files recursively from specified root path
#
# Usage:
# perl make_imglist.pl <root_path> <file extension regex>
# Example:
# perl make_imglist.pl ./dataset/ "(jpe?g|png)" > img_dataset.txt

use File::Find qw/find/;
use List::Util;
use feature qw/say/;
use 5.014;

my ($ROOT, $REGEXT) = @ARGV;

my @files;
find(sub{push @files, $File::Find::name if m/\.$REGEXT$/i;}, $ROOT);
@files = sort @files;

my %table;
for my $f (@files) {
  my ($label) = $f =~ m|(([^/\.]+))/[^/]+\.$REGEXT$|;
  if(not exists $table{$label}){
    $table{$label} = [$f];
  } else {
    push @{$table{$label}}, $f;
  }
}

my $index = 1;

for my $key (keys %table){
  for my $f (@{$table{$key}}) {
    say "$f $index";
  }

  ++$index;
}
