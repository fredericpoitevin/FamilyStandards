#!/bin/bash
if [ $# -lt 1 ]; then
        echo "$0 PATHDIR"
        echo "where PATHDIR contains the initial set of PDB"
        exit
fi
TOP="$PWD"
input_bank=$1
TOP=$TOP"/"$input_bank
cd $TOP
bank=spectrus_bank
echo "We are here: $TOP"
spectrus_results="results_all/spectrus_results"
if [ ! -d $spectrus_results ]; then
  echo "Spectrus results directory can not be found"
  exit
fi
if [ ! -d $bank ]; then
  echo "Original PDB repository directory can not be found"
  exit
fi
if [ ! -d coms ]; then
  mkdir coms
fi
cd "$TOP/$bank"
list=""
for pdb in *.pdb
do
  echo -ne "."
  list=$list" $pdb"
done
#
echo ">"
cd "$TOP/$spectrus_results"
for pdb in $list
do
  echo -ne "."
  cp "$TOP/$bank/$pdb" .
  postpectrus 20 $pdb > toto
  rm -f $pdb
  mv com.pdb "$TOP/coms/com_$pdb"
done
rm -f toto
echo ">"
cp com*.pml "$TOP/coms/"
cp *.txt "$TOP/coms/"
cd "$TOP/coms/"
pml="align_com.pml"
n=0
for pdb in *.pdb
do
  name=${pdb%.*}
  echo "load $pdb" >> $pml
  if [ $n -eq 0 ]; then
	  echo "load $pdb, ref" >> $pml
  else
    echo "pair_fit $name, ref" >> $pml 
  fi
  n=` expr $n + 1`
done
echo "zoom" >> $pml
#
