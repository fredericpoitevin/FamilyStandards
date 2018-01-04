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
if [ ! -d  $bank ]; then
	mkdir $bank
fi
#cd $input_bank
n=$(ls -1 *.pdb | wc -l)
i=0
echo "Extracting P and CA as CA in set of PDBs..."
for pdb in *.pdb
do
 if [[ $pdb == "4X5T.pdb" || $pdb == "5CFB.pdb" ]]; then
  i=` expr $i + 1`
    echo -ne "... $i / $n" \\r
 else
  i=` expr $i + 1`
  echo -ne "... $i / $n" \\r
  grep -e "  P " -e "  CA" $pdb > tmp.pdb
  cat tmp.pdb | awk -v FS='' '{if(($17==" ")||($17=="A")) print $0}' >"$TOP/$bank/$pdb"
  rm -f tmp.pdb
 fi
done
cd "$TOP/$bank/"
for pdb in *.pdb
do
  mv $pdb toto
  sed 's/  P /  CA/g' toto > $pdb
  rm -f toto
done
echo "Now zipping"
zip all.zip *.pdb
cd ../
#
mv $bank/all.zip .
echo "> All.zip is here: $PWD"
cp ~/Dropbox/Toolkit/spectrus_package/spectrus.sh .
cp -r ~/Dropbox/Toolkit/spectrus_package/src .
input="INPUT_PARAMS.DAT"
echo "N_DOM_MIN       2"    > $input
echo "N_DOM_MAX       200"   >> $input
echo "KMED_ITER       1000" >> $input
echo "CUTOFF          20"   >> $input
#
echo "> About ot run..."
./spectrus.sh all.zip
#
