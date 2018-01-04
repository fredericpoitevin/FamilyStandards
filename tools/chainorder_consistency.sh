#!/bin/bash
# This script aims at standardizing the chain numbering
# without any preconception. Although at that stage, it
# is not completely bullet-proof and is better aimed at
# working with objects with Cn symmetry,
# All will be numbered 
# according to whichever structure is first on the list.
# It will always be possible afterwards to renumber
# everyone according to a specific one, once the corr.
# table will be made out of an arbitrary one. Let s do it!
#
# It goes like this:
# - loop over chains of structure to be corrected,
#   and superimpose them to the first chain in the ref.
#   For each pair:
#   - loop over the remaining chains, and assign them 
#     the chain ID of the closest remaining
#     chain of the ref
#   - Compute RMSD: it gives a score to the pair
# - the pair with lowest score it the one.
#
source 'config.sh'
#
if [ $# -lt 2 ]; then
  echo "> missing arguments for the chain consistency module"
  exit
fi
cd $INIT_BANK
ref=$1
mov=$2
corr=$3
#
list_ref=$( cat $ref | awk -v FS='' '{if($1$2$3$4 == "ATOM" )print $22}' | uniq | tr '\n' ' ')
list_mov=$( cat $mov | awk -v FS='' '{if($1$2$3$4 == "ATOM" )print $22}' | uniq | tr '\n' ' ')
# only keep five firsts
list_ref_tmp=$list_ref
list_mov_tmp=$list_mov
list_ref=""
list_mov=""
n=0
for name in $list_ref_tmp
do
  n=` expr $n + 1`
  if [ $n -le $symmetry ]; then
    if [ $n -eq 1 ]; then
      chainref=$name
    fi
    list_ref=$list_ref" $name"
  fi
done
n=0
for name in $list_mov_tmp
do      
  n=` expr $n + 1`
  if [ $n -le $symmetry ]; then
    list_mov=$list_mov" $name"
  fi      
done 
#echo "$list_ref"
#echo "$list_mov"
#
$LOCAL_SRC/chaincom $ref $ref"_com"
#
# the following loop might be useful to go through
# in the case of non-cylindrical symmetries.
for chain in A #$list_mov
do
  # First, create the model where the chain is superimposed
  keyword="run"
  pml="$keyword.pml"
  log="$keyword.log"
  pdb="$keyword.pdb"
  refname=${ref%.*}
  movname=${mov%.*}
  echo "load $ref, $refname" > $pml
  echo "load $mov, $movname" >> $pml
  echo "align $movname and chain $chain, $refname and chain $chainref">> $pml
  echo "save $pdb, $movname" >> $pml
  $PYMOLBIN -cq $pml >> $log
  # Second, measure the score for this model
  $LOCAL_SRC/chaincom $pdb $pdb"_com"
  $LOCAL_SRC/com_pare $ref"_com" $pdb"_com" $corr
  #
  rm -f $pml $log $pdb $pdb"_com"
done
rm -f  $ref"_com"
#
