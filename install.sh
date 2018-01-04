#!/bin/bash
#
source 'config.sh'
#
if [ ! -d "$LOCAL_SRC" ]; then
  echo "INSTALLATION ABORTED."
  echo "> tools are missing..."
  exit
fi
echo ""
echo ">>> Compiling programs or checking their existence (in order of appearance)"
cd "$LOCAL_SRC"
echo "... >>> WGET ?"
	if ! which wget; then
	  echo "WARNING..."
          echo "In the 'auto' mode, you'll need wget. Please install it. [Press enter to resume installation...]"
          read
        fi
echo "... >>> PYTHON ?"
	if ! which python2.7; then
	  echo "WARNING..."
	  echo "In the 'auto' mode, you'll need python2.7. Please install it. [Press enter to resume installation...]"
	  read
	fi
echo "... >>> MUSTANG"
	cd MUSTANG_v3.2.2
	make clean
	make
echo "... >>> PYMOL ?"
	if ! which $PYMOLBIN; then
	  echo "ERROR..."
	  echo "Pymol is needed for the chain numbering standardization step. In the future, built-in methods will deal with it."
	  echo "But for now, Pymol is necessary. Please install it and edit $PYMOLBIN accordingly in 'config.sh'."
	  echo "Come back here once done."
          exit
        fi
echo "... >>> BUILT-IN TOOLS"
	cd "$LOCAL_SRC"
	make
	make built-in
