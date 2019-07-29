#!/bin/bash

### --------  SLURM  ----------- ###
#SBATCH --job-name=textify
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=out/txt_"%A_%a_%j.out"
#SBATCH --error=error/txt_"%A_%a_%j.err"
### -------------------------- ###
echo "job name: $SLURM_JOB_NAME"
echo "SLURM_JOBID:  $SLURM_JOBID"
echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID"

input_path=$1
output_path=$2
folder=$3
python3 json2text.py ${input_path} ${SLURM_ARRAY_TASK_ID} > ${output_path}/${folder}_${SLURM_ARRAY_TASK_ID}.txt
