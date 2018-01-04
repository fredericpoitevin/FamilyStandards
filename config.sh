#!/bin/bash
# This file stores variables used throughout the whole runs
#
####################################
# USER-DEFINED PARAMETERS
#
# 0) JOB IDENTIFIER
jobid="BANK"
#
# 1) GENERATION OF INITIAL PDB BANK
mode="auto" # [auto] will retrieve set of PDB according to keyword
            # [anything else] assume you provide your own set of PDB 
	    #                 in $INIT_BANK directory 
	    #                 (see below for its path definition)
# keyword is a list of keyword separated by '>' used in the 'auto' mode 
# to generate the initial PDB list.
keyword=""
keyword="$keyword >GluCl"
#keyword="$keyword >pentameric ligand gated ion channel"
#keyword="$keyword >glutamate gated chloride channel"
#keyword="$keyword >serotonin 5-HT3 receptor"
# 
# 2) STANDARD PARAMETERS
cutoff=250 # this parameter is used to discard any PDB whose sequence 
           #is shorter than 'cutoff' residues.
symmetry=5 # this parameter is used to retain the first 'symmetry' chains 
           # in the input PDBs.
           # In the future, robust and generalized handling of multi-chain 
           #PDBs will be implemented.
#
######################################################
# DO NOT EDIT BELOW UNLESS YOU KNOW WHAT YOU ARE DOING
LOCAL_TOP="/Users/fpoitevi/gdrive/Toolkit/FamilyStandards/FamilyStandards_release"
LOCAL_SRC="$LOCAL_TOP"/tools
INIT_BANK="$LOCAL_TOP"/init$jobid
DEST_BANK="$LOCAL_TOP"/dest$jobid
#
MUSTANGBIN="$LOCAL_SRC"/MUSTANG_v3.2.2/bin/mustang-3.2.1
PYTHONBIN=$( which python2.7)
PYMOLBIN=$( which pymol)
#
# The files that we are going to create along the process
file_idlist="$INIT_BANK/idlist.txt"                      # list of initial PDB files
file_seqlist="$DEST_BANK/seqlist.txt"                    # list of non redundant sequences among them
file_seqlist_complete="$DEST_BANK/seqlist_complete.txt"  # list of all sequences
file_alignment="$DEST_BANK/alignment.aln"                # list of non redundant, then all, sequences aligned
file_mustang_input="$DEST_BANK/description.file"         # input file needed by mustang
file_mustang_output_pdb="$DEST_BANK/alignment.pdb"       # output from mustang
file_mustang_output_fasta="$DEST_BANK/alignment.fasta"   # output from mustang
#
