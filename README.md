*Note: git LFS is used to support versioning of 'large' PDB files*

# FamilyStandards
to ease the comparison of structures from homologues in a protein family

For a given set of structures, assumed to be FAMILY-related, the first step consists in defining a STANDARD (a common chain and residue numbering), allowing to build chain and residue correspondance tables for each inital structure.

Subsequent steps make use of these, e.g. to build a structural bank of all structures renumbered according to the numbering of one of its members, while only retaining the set of residues that are common to all. 

One possible output is thus a set of structures which only differ in the positions of their atoms, paving the way for insightful analysis, some of which we propose here.

It should work with multimeric proteins, but the treatment of complexes (DNA-RNA-protein mixes) is out of scope for now.

## Installation
This is a linux/macOS only tool.

**Dependencies**

you will need the following to run. First three should be native, the latter can be installed from https://pymolwiki.org/index.php/MAC_Install. 
* wget
* gfortran
* python2.7
* pymol

**Protocol**

`./configure.sh`

`./install.sh`

## Running it

### preparing the run
The FAMILY you wish to STANDARDIZE is an ensemble of PDB files that you can provide yourself, or that you retrieve from the Protein Data Bank through a set of keywords. One option could be to run in auto mode first to initialize the PDB library, manually curating it then, and finally rerunning in manual mode. Please edit the following variables in `config.sh` first:

```bash
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
# to generate the initial PDB list. In the example below, the keyword is 
# GluCl. Additional are proposed and need to be commented out to be used.
keyword=""
keyword="$keyword >GluCl"
#keyword="$keyword >pentameric ligand gated ion channel"
#keyword="$keyword >glutamate gated chloride channel"
keyword="$keyword >serotonin 5-HT3 receptor"
# 
# 2) STANDARD PARAMETERS
cutoff=250 # this parameter is used to discard any PDB whose sequence 
           #is shorter than 'cutoff' residues.
symmetry=5 # this parameter is used to retain the first 'symmetry' chains 
           # in the input PDBs.
           # In the future, robust and generalized handling of multi-chain 
           #PDBs will be implemented.
```

### the actual run

`./standardize.sh`

### benefitting from it

#### rewriting all PDB with common numbering scheme

this can be run without argument. If an argument is provided, it needs to be one of the PDB ID in the set, and the numbering will be set according to that guy.

`./common.sh (optional: PDB ID, e.g. 4PIR)`

#### superimposing PDB found in given DIR on SEL

for example, we superimpose all the new common set on the Calpha of their residues 30-160, a selection that we associate with the keyword "subECD". Here is what you should see:
```
./superall.sh destBANK/common_4PIR/ " and name ca and resi 30-160" subECD
... about to superimpose  3RI5 3RIA 3RIF 4PIR 4TNV 4TNW 5V6N 5V6O
  <<< wanna see ? >>>
$> cd destBANK/common_4PIR/subECD
$> pymol see.pml
```
