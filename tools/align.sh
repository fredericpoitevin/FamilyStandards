#!/bin/bash
#
source 'config.sh'
#
# Run mustang if not already done
if [ ! -f $file_alignment ]; then
	#
	list=""
	while read line
	do
	  name=$( echo $line | awk '{print $1}')
	  name="${name}.pdb"
	  list=$list" $name"
	done < $file_seqlist
	#
	# Perform pairwise structural alignment
	#
	echo "> $DEST_BANK" > $file_mustang_input
	for pdb in $list
	do
	  echo "+$pdb" >> $file_mustang_input 
	done
	#
	$MUSTANGBIN -f $file_mustang_input -F fasta
	# 
	mv results.afasta $file_mustang_output_fasta
	mv results.pdb $file_mustang_output_pdb
	#
	# Produce by-line alignment from fasta one
	#
	touch $file_alignment
	#
	ncount=0
	while read line
	do
	  lgth=${#line}
	  if [ $lgth -ne 0 ]; then
	    if [ ${line:0:1} == ">" ]; then
	      if [ $ncount -ne 0 ]; then
	        echo "$name $seq" >> $file_alignment
	      fi
	      ltmp=` expr $lgth - 5`
	      name=${line:1:$ltmp}
	      seq=""
	      ncount=` expr $ncount + 1`
	    else
	      seq=$seq$line
	    fi
	  fi
	done < $file_mustang_output_fasta
	echo "$name $seq" >> $file_alignment
	#
	# Extract common residues
	echo "Extracting the common set of residues:"
	ncnt=0
	while read line
	do
	  ncnt=` expr $ncnt + 1`
	  nam=$(echo $line | awk '{print $1}')
	  seq=$(echo $line | awk '{print $2}')
	  seq_l=${#seq}
	  i=0
	  bin_tot=0
	  while [ $i -lt $seq_l ]
	  do
	    res=${seq:$i:1}
	    i=` expr $i + 1`
	    if [ $res != "-" ]; then
	      if [ $ncnt -eq 1 ]; then
	        bin[$i]=1
	      fi
	    else
	      bin[$i]=0
	    fi
	    bin_tot=` expr $bin_tot + ${bin[$i]}`
	  echo -ne ">>> $nam : $bin_tot common residues left"\\r
	  done
	  echo ""
	done < $file_alignment
	#
else
	echo "Mustang has already been run here, as testified by the presence of the file $file_alignment"
fi
#
# Put back in the alignment file the redundant sequences if any...
#
n1=$(cat $file_seqlist_complete | wc -l)
ntot=$(cat $file_alignment | wc -l)
if [ $ntot -ne $n1 ]; then
  cat $file_seqlist_complete | sort -k2,2 > tmp.list
  mv $file_alignment tmp.aln
  touch $file_alignment
  while read line
  do
    id=$( echo $line | awk '{print $1}')
    if grep -q "$id" tmp.aln ; then
      seq=$( grep "$id" tmp.aln | awk '{print $2}')
    fi
    echo "$id $seq" >> $file_alignment
  done < tmp.list
  rm -f tmp.list tmp.aln
fi
#
ntot=$(cat $file_alignment | wc -l)
ncnt=0
echo "Building the correspondance tables"
while read line
do
  ncnt=` expr $ncnt + 1`
  echo -en "... $ncnt / $ntot"\\r
  nam=$(echo $line | awk '{print $1}')
  if [ $ncnt -eq 1 ]; then
    namref=$nam
  fi
  #
  # Correspondance in residue numbering
  #
  if [ -f $DEST_BANK/${nam}.corr ]; then
    rm -f $DEST_BANK/${nam}.corr
  fi
  touch $DEST_BANK/${nam}.corr
  seq=$(echo $line | awk '{print $2}')
  seq_l=${#seq}
  i=0
  ires=0
  blank="    "
  while [ $i -lt $seq_l ]
  do
    res=${seq:$i:1}
    i=` expr $i + 1`
    iblank=${blank:0:$(echo "` expr 4 - ${#i}`")}
    if [ $res != "-" ]; then
      ires=` expr $ires + 1`
      pdbline=$( head -n $ires $DEST_BANK/${nam}.pdb | tail -1)
      ch=${pdbline:21:1}
      nres=${pdbline:22:4}
      nblank=${blank:0:$(echo "`expr 4 - ${#nres}`")}
      echo ">$nblank$nres,$iblank$i.${bin[$i]}" >> $DEST_BANK/${nam}.corr
    fi
  done
  #
  # Correpondance in chain numbering
  #
  if [ -f $DEST_BANK/${nam}.chcorr ]; then
    rm -f $DEST_BANK/${nam}.chcorr
  fi
  touch $DEST_BANK/${nam}.chcorr
  echo -n "$nam : "
  $LOCAL_SRC/chainorder_consistency.sh ${namref}.pdb ${nam}.pdb $DEST_BANK/${nam}.chcorr
  rm -f $DEST_BANK/${nam}.pdb
done < $file_alignment
#
