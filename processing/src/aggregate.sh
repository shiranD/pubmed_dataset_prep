#!/bin/bash

### --------  SLURM  ----------- ###
#SBATCH --job-name=aggregate
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=out/aggregate_"%A_%a_%j.out"
#SBATCH --error=error/aggregate_"%A_%a_%j.err"
### -------------------------- ###
echo "job name: $SLURM_JOB_NAME"
echo "SLURM_JOBID:  $SLURM_JOBID"
echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID"

input_path=$1
output_path=$2
cat ${input_path}/txt/*.txt > ${input_path}/${output_path}
