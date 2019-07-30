#!/bin/bash
set -x
set -e

# Vars
corpusname=pbmd # corpus name
path2corpus=txt
dataf=pbmd_data # data folder name
srcdir=src

# Paths
start_corpus=${dataf}/corpus

# mk Dirs
mkdir -p ${dataf}
mkdir -p ${start_corpus}

echo "PRE PROCESS DATA"

# aggregate txt files to one
sbatch ${src}/aggregate.sh ${path2corpus} ${corpusname}
# split corpus
sbatch ${src}/split_corpus.sh ${path2corpus} ${start_corpus} ${corpusname}
