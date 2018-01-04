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
if [ $# -lt 3 ]; then
	echo './superall.sh PATHDIR "selection" flag_save'
	echo 'will superimpose all PDBs found in PATHDIR onto "selection"'
	echo 'FLAG_SAVE: if set to 1, superimposed structures will be saved.'
	exit
fi
#
dir="$1"
sel="$2"
flag_save=$3
cd "$dir"
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
if [ $flag_save -eq 1 ]; then
  echo "save ${ref_name}_super.pdb, $ref_name" >> $pml
fi
for name in $list
do
  echo "load $name.pdb, $name" >> $pml
  echo "align $name $sel, $ref_name $sel,cycles=0" >> $pml
  if [ $flag_save -eq 1 ]; then
    echo "save ${name}_super.pdb, $name" >> $pml
  fi
done
echo "orient $ref_name" >> $pml
if [ $flag_save -eq 1 ]; then
  echo "i) First pymol run to superimpose and save the superimposed structures"
  pymol -cq $pml 
  echo "ii) Second actual run to watch them"
  pymol *_super.pdb
else
  pymol $pml
fi
#
#
