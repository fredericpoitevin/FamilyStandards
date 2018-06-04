#!/bin/bash
#
source 'config.sh'
#
cd "$LOCAL_TOP"
echo -e "\n <<< *** FAMILY STANDARDS *** >>> \n (we are here: "$PWD" )\n"
#
if [ ! -d "$INIT_BANK" ]; then
  if [ "$mode" == "auto" ]; then
    "$LOCAL_SRC"/create_bank.sh
  else
    echo "... missing bank directory ... Exiting now"
    exit
  fi
fi
if [ ! -d "$DEST_BANK" ]; then
  mkdir "$DEST_BANK"
fi
#
echo "i)   from PDB Bank to list of sequences "
if [ ! -f "$file_seqlist" ]; then
  "$LOCAL_SRC"/pdb2seq.sh 
fi
if [ ! -f "$file_seqlist" ]; then
  echo "... uhoh! something happened. Exiting..."
else
  echo "ii) perform multiple structural alignment with MUSTANG"
  echo "    and build the correspondance tables"
  "$LOCAL_SRC"/align.sh
  echo "iii) Create new PDB bank with common numbering"
  "$LOCAL_SRC"/newpdb.sh
  echo ""
  echo "At that stage, we should have succesfully processed the set of structures"
  echo "originally found in "
  echo "$INIT_BANK"
  echo "to a set of readily comparable ones in "
  echo "$DEST_BANK"
  echo "where the accompanying .corr and .chcorr files will help"
  echo "going back and forth between common and species-specific residue and chain"
  echo "numbering, in subsequent studies."
fi
#
