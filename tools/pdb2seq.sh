#!/bin/bash
#
source 'config.sh'
#
# Extract info from BANK to cure
#
cd $INIT_BANK
num_tot=$( ls -1 *.pdb | wc -l)
num_curr=0
for file in *.pdb
do
  name=${file%.*}
  num_curr=` expr $num_curr + 1`
  echo -en "... $num_curr / $num_tot"\\r
  if [ ! -f $DEST_BANK/${name}.pdb ]; then
   # Get a unique atom for each residue (aa or nt) based on its numbering
   # Store temporarily in tmp.pdb
   grep "ATOM" $file | sort -k 1.23,1.26 --stable --unique > $DEST_BANK/tmp.pdb
   touch $DEST_BANK/${name}.pdb
   sequence=""
#  
   # Do some editing to tmp.pdb before storing name.pdb
   while read line
   do
     if [ ${line:0:4} == "ATOM" ]; then
      length=${#line}
      if [ $length -lt 50 ]; then
        echo "... ATOM line quite short ... "$line
      fi
      # Convert nt names to aa names, and replace atom type by CA
      rest=` expr $length - 20`
      left=${line:0:13}
      chain=${line:21:1}
      ch=$chain
      right=${line:22:$rest}
      rs_type=${line:17:3}
      nt_type=${line:19:1}
      ca="CA"
      sequence=$sequence$nt_type
      echo "$left$ca  $rs_type $ch$right$add" >> $DEST_BANK/${name}.pdb
    fi
   done < $DEST_BANK/tmp.pdb
   rm -f $DEST_BANK/tmp.pdb
   # only keep candidates with sequences longer than cutoff
   if [ ${#sequence} -ge $cutoff ]; then
     echo -e "$name $sequence ${#sequence}" >> $file_seqlist
   else
     rm -f $DEST_BANK/${name}.pdb
   fi
  fi
done
#
if [ ! -f $file_seqlist_complete ]; then
  #
  # Only keep unique sequence occurences
  # Sort the alignment file with respect to sequence length
  mv $file_seqlist $file_seqlist_complete
  cat $file_seqlist_complete | sort -u -k2,2 | sort -r -k3,3 > $file_seqlist
fi
# Now we should have all we need to work.
