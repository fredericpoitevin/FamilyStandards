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
ilevmax=99
if [ ! -d coms ]; then
  echo "COMS are not computed yet"
  exit
fi
cd "$TOP/coms"
cp "$TOP/$spectrus_results/quality_score.dat" .
list=""
for pdb in *.pdb
do
  echo -ne "."
  name=${pdb%.*}
  name=$( echo $name | awk -F "_" '{print $2}')
  list=$list" $name"
done
cp $pdb com_name.pdb
#
echo ">"
if [ -e "com.csv" ]; then
  rm -f com.csv
fi
com2csv name $ilevmax quality_score.dat 6.5 #3.5
mv com_name.csv com.csv
#
for name in $list
do
  echo -ne "."
  csv="com_"$name".csv"
  mv com.csv toto.csv
  com2csv $name $ilevmax quality_score.dat 6.5 #3.5
  cat toto.csv $csv > com.csv
  rm -f toto.csv $csv
done
echo ">"
