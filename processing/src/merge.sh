#!/bin/bash

### --------  SLURM  ----------- ###
#SBATCH --job-name=merge
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=04:00:00
#SBATCH --output="out/merge_%A_%a_%j.out"
#SBATCH --error="error/merge_%A_%a_%j.err"
### -------------------------- ###
echo "job name: $SLURM_JOB_NAME"
echo "SLURM_JOBID:  $SLURM_JOBID"
echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID"

shuffle=$1
corpusname=$2

cat ${shuffle}/$SLURM_ARRAY_TASK_ID/* > ${shuffle}/${corpusname}_$SLURM_ARRAY_TASK_ID
rm -rf ${shuffle}/$SLURM_ARRAY_TASK_ID
