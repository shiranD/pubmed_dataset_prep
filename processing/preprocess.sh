#!/bin/bash
set -x
set -e

# Vars
corpusname=pbmd # corpus name
path2corpus=../txt
dataf=../pbmd_data # data folder name
srcdir=src

# Paths
start_corpus=${dataf}/corpus

# mk Dirs
mkdir -p ${dataf}
mkdir -p ${start_corpus}
mkdir -p error
mkdir -p out
echo "PRE PROCESS DATA"

## UnComment one sbatch at a time
# aggregate txt files to one
#sbatch ${srcdir}/aggregate.sh ${path2corpus} ${corpusname}
# split corpus
#sbatch ${srcdir}/split_corpus.sh ${path2corpus}/${corpusname} ${start_corpus} ${corpusname}
