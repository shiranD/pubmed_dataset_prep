#!/bin/bash

### --------  SLURM  ----------- ###
#SBATCH --job-name=split_corpus
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=out/split_corpus_"%A_%a_%j.out"
#SBATCH --error=error/split_corpus_"%A_%a_%j.err"
### -------------------------- ###
echo "job name: $SLURM_JOB_NAME"
echo "SLURM_JOBID:  $SLURM_JOBID"
echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID"

path2txt=$1
start_corpus=$2
corpusname=$3

split -l 100000 -d -a 6 ${path2txt} ${start_corpus}/${corpusname}_
i=0
for FILE in `ls ${start_corpus}/`
 do
 mv ${start_corpus}/$FILE ${start_corpus}/${corpusname}_$i
 let i=i+1
done
