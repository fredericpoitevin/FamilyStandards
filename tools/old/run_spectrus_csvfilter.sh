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
if [ ! -d coms ]; then
  echo "COMS are not computed yet"
  exit
fi
cd "$TOP/coms"
if [ -f com.csv ]; then
  ncol=$(awk -F "," '{print NF; exit}' com.csv)
  sed 's/,/ /g' com.csv > comtmp.csv
  filtercsv comtmp.csv outmp.csv $ncol 2.0
fi
