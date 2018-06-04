#!/bin/bash
# This scripts can only be used after having run 'standardize.sh'
# and 'common.sh'; that is, we assume here that all PDBs already
# have the same residue numbering
# 
# ./superall.sh PATHDIR "pymol selection" KEYWORD
# will superimpose all PDBs found in PATHDIR onto 'selection' 
#
source 'config.sh'
#
if [ $# -lt 3 ]; then
	echo './superall.sh PATHDIR "pymol selection" KEYWORD'
	echo 'will superimpose all PDBs found in PATHDIR onto "selection"'
	echo 'if KEYWORD is provided, superimposed structures will be saved in PATHDIR/KEYWORD'
	exit
fi
#
dir="$1"
sel="$2"
keyword=${3:-toto}
cd "$dir"
if [ -d $keyword ]; then echo "... $keyword only exists, please provide another keyword"; exit; fi
mkdir $keyword
#
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
superpml="superall.pml"
seepml="$keyword/see.pml"
echo "load $ref_name.pdb, $ref_name" > $superpml
echo "save $keyword/${ref_name}_$keyword.pdb, $ref_name" >> $superpml
echo "load ${ref_name}_$keyword.pdb" > $seepml
for name in $list
do
  echo "load $name.pdb, $name" >> $superpml
  echo "align $name $sel, $ref_name $sel,cycles=0" >> $superpml
  echo "save $keyword/${name}_$keyword.pdb, $name" >> $superpml
  echo "load ${name}_$keyword.pdb" >> $seepml
done
echo "orient ${ref_name}_$keyword" >> $seepml
echo "util.cbc" >> $seepml
echo "bg_color white" >> $seepml
echo "set specular, off" >> $seepml
echo "as cartoon" >> $seepml
#
echo "... about to superimpose $list"
pymol -cq $superpml > $superpml.log
echo "  <<< wanna see ? >>>"
echo "$> cd $dir$keyword"
echo "$> pymol see.pml"
#
#
