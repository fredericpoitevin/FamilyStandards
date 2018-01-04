#!/bin/bash
#
# !!! This script must be called after "standardizing.sh" !!!
# From the set of PDB and corr files found in $DEST_BANK, it 
# creates a set of PDB with only the common atoms retained.
# The numbering of these atoms could be set to the one of one
# of the species, if specified.
# 
source 'config.sh'
#
ref=""
dir="common"
if [ $# -eq 1 ]; then
  ref=$1
  dir=$dir"_"$ref
fi
if [ -d $dir ]; then
  echo "$0 already ran! Check directory '$dir' out :) Exiting..."
  exit
fi
mkdir $dir
#
ntot=$( cat $file_alignment | wc -l )
ncnt=0
while read line
do
  ncnt=` expr $ncnt + 1`
  echo -en "... $ncnt / $ntot"\\r
  nam=$(echo $line | awk '{print $1}')
  if [ -f $DEST_BANK/${nam}.corr ]; then
    if [ ! -f $dir/${nam}.pdb ]; then
      chncorr=$DEST_BANK/${nam}.chcorr
      rescorr=$DEST_BANK/${nam}.corr
      $LOCAL_SRC/renumber $INIT_BANK/${nam}.pdb $rescorr $chncorr $dir/${nam}.pdb 1 0
      if [ "$ref" != "" ]; then
        mv $dir/${nam}.pdb tmp.pdb
	rescorr=$DEST_BANK/${ref}.corr
	chncorr=$DEST_BANK/${ref}.chcorr
	$LOCAL_SRC/renumber tmp.pdb $rescorr $chncorr  $dir/${nam}.pdb 1 1
	rm -f tmp.pdb
      fi
    fi
  fi
done < $file_alignment
#
