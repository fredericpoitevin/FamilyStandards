#!/bin/bash
#
source 'config.sh'
#
ntot=$( cat $file_alignment | wc -l )
ncnt=0
while read line
do
  ncnt=` expr $ncnt + 1`
  echo -en "... $ncnt / $ntot"\\r
  nam=$(echo $line | awk '{print $1}')
  if [ -f $DEST_BANK/${nam}.corr ]; then
    if [ ! -f $DEST_BANK/${nam}.pdb ]; then
      chncorr=$DEST_BANK/${nam}.chcorr
      rescorr=$DEST_BANK/${nam}.corr
      $LOCAL_SRC/renumber $INIT_BANK/${nam}.pdb $rescorr $chncorr $DEST_BANK/${nam}.pdb 0 0
    fi
  fi
done < $file_alignment
#
