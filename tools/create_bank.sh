#!/bin/bash
source 'config.sh'
#
$LOCAL_SRC/keyword_to_pdblist.sh
#
if [ ! -f $file_idlist ]; then
  echo "$file_idlist could not be found. Exiting..."
  exit
fi
#
HOST='ftp.wwpdb.org'
LIST=""
while read line
do
  LIST=$LIST" $line"
done < $file_idlist
#
#
cd $INIT_BANK
#
for pdb in $LIST
do
  if [ ! -f ${pdb}.pdb ]; then
    echo "> Retrieving $pdb from PDB"
    ent=$(echo $pdb | awk '{print tolower($0)}')
    FILE="pub/pdb/data/structures/all/pdb/pdb${ent}.ent.gz"
    wget -nv ftp://$HOST/$FILE
    gunzip pdb${ent}.ent.gz
    mv pdb${ent}.ent ${pdb}.pdb
  else
    echo "> $pdb already in $INIT_BANK"
  fi
done
