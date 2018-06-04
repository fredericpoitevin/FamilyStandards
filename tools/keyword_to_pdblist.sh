#!/bin/bash
source 'config.sh'
#
if [ ! -d $INIT_BANK ]; then
  mkdir $INIT_BANK
fi
#
LIST=""
i=2
iok=1
echo "... keywords to query PDB: ..."
while [ $iok -eq 1 ]
do
  keylist=$(echo "$keyword" | awk -v i=$i -F ">" '{print $i }')
  echo "$keylist"
  if [ "$keylist" != "" ]; then
    LIST=$LIST" ` $PYTHONBIN $LOCAL_SRC/pdb_list_keyword.py "$keylist"`"
    i=` expr $i + 1`
  else
    iok=0
  fi
done
echo "... retrieved PDB IDs ..."
echo $LIST
#
cd $INIT_BANK
#
if [ -f $file_idlist ]; then
  rm -f $file_idlist
fi
touch $file_idlist
#
for pdb in $LIST
do
  echo "$pdb" >> $file_idlist
done

