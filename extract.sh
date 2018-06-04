#!/bin/bash
# This scripts can only be used after having run:
# - 'standardize.sh'
# - 'common.sh'
# that is, we assume here that all PDBs already have the same residue numbering
# 
source 'config.sh'
#
if [ $# -lt 3 ]; then
	echo './extract.sh PATHDIR "pymol selection" KEYWORD'
	echo 'will extract "selection" of all PDBs found in PATHDIR in PATHDIR/extract_KEYWORD'
	exit
fi
#
dir="$1"
sel="$2"
keyword=${3:-toto}
outdir=extract_$keyword
cd "$dir"
if [ -d $outdir ]; then echo "... $outdir only exists, please provide another keyword"; exit; fi
mkdir $outdir
#
list=""
ntot=0
for pdb in *.pdb
do
  name=${pdb%.*}
  list=$list" $name"
done
xtpml="extract.pml"; if [ -f $xtpml ]; then rm -f $xtpml; touch $xtpml; fi
seepml="$outdir/see.pml"; 
for name in $list
do
  echo "load $name.pdb, $name" >> $xtpml
  echo "save $outdir/${name}_$keyword.pdb, $name $sel" >> $xtpml
  echo "load ${name}_$keyword.pdb" >> $seepml
done
echo "orient" >> $seepml
echo "util.cbc" >> $seepml
echo "bg_color white" >> $seepml
echo "set specular, off" >> $seepml
echo "as cartoon" >> $seepml
#
echo "... about to extract $sel of $list"
pymol -cq $xtpml > $xtpml.log
echo "  <<< wanna see ? >>>"
echo "$> cd $dir$outdir"
echo "$> pymol see.pml"
#
#
