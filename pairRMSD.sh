#!/bin/bash
# This scripts can only be used after having run:
# - 'standardize.sh'
# - 'common.sh'
# - 'extract.sh'
# that is, we assume here that all PDBs already have the same residue numbering
# and they all contain exactly the same ATOMS, only their xyz differ
# 
source 'config.sh'
#
if [ $# -lt 1 ]; then
	echo './pairRMSD.sh PATHDIR'
	echo 'will compute RMSD between all pairs of PDB found in PATHDIR'
	exit
fi
#
dir="$1"
cd "$dir"
#
list=""
ntot=0
for pdb in *.pdb
do
  list=$list" $pdb"
done
#
if [ -f rmsd.pair ]; then echo "rmsd.pair already exists. Exit."; exit; fi
touch rmsd.pair
n1=0
for pdb1 in $list
do
  n1=` expr $n1 + 1`
  n2=0
  for pdb2 in $list
  do
    n2=` expr $n2 + 1`
    if [ $n2 -lt $n1 ]; then
      rmsd=`$LOCAL_SRC/static_rmsd $pdb1 $pdb2`
      echo "$pdb1 $pdb2 $rmsd" >> rmsd.pair
      tail -1 rmsd.pair
    fi
  done
done
#
