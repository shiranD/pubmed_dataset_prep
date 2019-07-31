#!/bin/bash

### --------  SLURM  ----------- ###
#SBATCH --job-name=shuffle
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=04:00:00
#SBATCH --output="out/shuffle_%A_%a_%j.out"
#SBATCH --error="error/shuffle_%A_%a_%j.err"
### -------------------------- ###
echo "job name: $SLURM_JOB_NAME"
echo "SLURM_JOBID:  $SLURM_JOBID"
echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID"

path2corpus=$1
new_corpus=$2
fnum=$3
srcdir=$4

python ${srcdir}/shuffle.py --fdata ${path2corpus}_$SLURM_ARRAY_TASK_ID --fout ${new_corpus} --num ${fnum} --task $SLURM_ARRAY_TASK_ID 
