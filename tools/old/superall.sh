#!/bin/bash
# This scripts can only be used after having run 'standardize.sh'
# and 'common.sh'; that is, we assume here that all PDBs already
# have the same residue numbering
# 
# ./superall.sh PATHDIR "selection"
# will superimpose all PDBs found in PATHDIR onto 'selection' 
#
source 'config.sh'
#
if [ $# -lt 2 ]; then
	echo './superall.sh PATHDIR "selection"'
	echo 'will superimpose all PDBs found in PATHDIR onto "selection"'
	exit
fi
#
dir=$1
sel="$2"
cd $dir
list=""
ntot=0
for pdb in *.pdb
do
  name=${pdb%.*}
  ntot=` expr $ntot + 1`
  if [ $ntot -eq 1 ]; then
	  ref_name=$name
  else
	  list=$list" $name"
  fi
done
pml="superall.pml"
echo "load $ref_name.pdb, $ref_name" > $pml
for name in $list
do
  echo "load $name.pdb, $name" >> $pml
  echo "align $name $sel, $ref_name $sel,cycles=0" >> $pml
done
echo "orient $ref_name" >> $pml
$PYMOLBIN $pml
#
#
