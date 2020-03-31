#!/bin/bash
set -x
set -e

# Vars
folds=4 # how many folds
corpusname=pbmd # corpus name

dataf=../pbmd_data # data folder name

# Paths
start_corpus=${dataf}/corpus
seg_corpus=${dataf}/segmented
noref_corpus=${dataf}/nref
pos_corpus=${dataf}/pos
shuffle=${dataf}/shuffle
sets=${dataf}/sets
fold=${dataf}/folds
srcdir=src
kwd= # (optional) additinal keyword to differentiate similar trainings

# mk Dirs
mkdir -p ${dataf}
mkdir -p ${start_corpus}
mkdir -p ${pos_corpus}
mkdir -p ${noref_corpus}
mkdir -p error
mkdir -p out
mkdir -p ${fold}
mkdir -p ${sets}
mkdir -p ${seg_corpus}
mkdir -p ${shuffle}

## run commands (ZEROTH,FIRST,..) line by line to ensure every cmd is completed successfuly, read comments

echo "PROCESS DATA"

# count number of shards
num=$(ls -l ${dataf}/corpus | grep ${corpusname} | wc -l)
num=$(($num-1))

## segment sentences found in paragraphs
#ZEROTH=$(sbatch --array=0-$num $srcdir/sentence_seg.sh ${start_corpus}/${corpusname} ${seg_corpus}/${corpusname} $srcdir | cut -f4 -d' ')

## preprocess text by removing undesired data
#FIRST=$(sbatch --array=0-$num $srcdir/no_ref.sh ${seg_corpus}/${corpusname} ${noref_corpus}/${corpusname} $srcdir | cut -f4 -d' ')

## together with SciSpacy annotate for POS
#SECOND=$(sbatch --array=0-$num ${srcdir}/add_pos.sh ${noref_corpus}/${corpusname} ${pos_corpus}/${corpusname} $srcdir | cut -f4 -d' ')

## make dirs to split data (and by that shuffle it). Uncomment THIRD and FOURTH together
#THIRD=$(sbatch ${srcdir}/mkdirs.sh ${shuffle} ${num} | cut -f 4 -d' ' )

## shuffle
#FOURTH=$(sbatch --array=0-$num --dependency=afterok:${THIRD} ${srcdir}/shuffle.sh ${pos_corpus}/${corpusname} ${shuffle} ${num} ${srcdir} | cut -f 4 -d' ' )

## merge the shuffled data
#FIFTH=$(sbatch --array=0-$num ${srcdir}/merge.sh ${shuffle} ${corpusname} | cut -f 4 -d' ' )

## mkdir for folds. Uncomment SIXTH and SEVETH together
#SIXTH=$(sbatch ${srcdir}/mkdirs.sh ${fold} ${folds} | cut -f 4 -d' ' )

## split again, but to number of folds+1, and merge within each fold
#SEVENTH=$(sbatch --array=0-$num --dependency=afterok:${SIXTH} ${srcdir}/shuffle.sh ${shuffle}/${corpusname} ${fold} ${folds} ${srcdir} | cut -f 4 -d' ' )

#EIGHTH=$(sbatch --array=0-$folds ${srcdir}/merge.sh ${fold} fold | cut -f 4 -d' ' )

## create sets from folds/shards. If No POS is done (skipping SECOND) uncomment sets.py and comment sets_pos.py in sets.sh.
## to skip SECOND make sure THIRD gets "noref" and not "pos" corpus as input.
#NINTH=$(sbatch --array=0-$folds $srcdir/sets.sh ${fold}/fold ${sets} $folds $srcdir | cut -f 4 -d' ')

# this process may create black lines in files remove with sed -i '/^$/d' file
