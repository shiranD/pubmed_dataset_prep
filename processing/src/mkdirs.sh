#!/bin/bash

### --------  SLURM  ----------- ###
#SBATCH --job-name=mkdir
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=04:00:00
#SBATCH --output="out/mkdir_%A_%a_%j.out"
#SBATCH --error="error/mkdir_%A_%a_%j.err"
### -------------------------- ###
echo "job name: $SLURM_JOB_NAME"
echo "SLURM_JOBID:  $SLURM_JOBID"
echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID"

shuffle=$1
num=$2
for i in $(seq 0 $num)
do
  mkdir -p ${shuffle}/${i}
done
