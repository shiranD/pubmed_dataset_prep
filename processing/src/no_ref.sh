#!/bin/bash

### --------  SLURM  ----------- ###
#SBATCH --job-name=no_ref
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=04:00:00
#SBATCH --output="out/no_ref_sg_%A_%a_%j.out"
#SBATCH --error="error/no_ref_%A_%a_%j.err"
### -------------------------- ###
echo "job name: $SLURM_JOB_NAME"
echo "SLURM_JOBID:  $SLURM_JOBID"
echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID"

path2corpus=$1
new_corpus=$2
srcdir=$3
python3 ${srcdir}/no_ref.py --fdata ${path2corpus}_$SLURM_ARRAY_TASK_ID --fout ${new_corpus}_${SLURM_ARRAY_TASK_ID}
