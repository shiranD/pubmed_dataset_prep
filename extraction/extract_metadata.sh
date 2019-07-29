#!/bin/bash

### --------  SLURM  ----------- ###
#SBATCH --job-name=parse_xml
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=out/xml_"%A_%a_%j.out"
#SBATCH --error=error/xml_"%A_%a_%j.err"
### -------------------------- ###
echo "job name: $SLURM_JOB_NAME"
echo "SLURM_JOBID:  $SLURM_JOBID"
echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID"

if [ $SLURM_ARRAY_TASK_ID -lt 10 ]; then
  SLURM_ARRAY_TASK_ID=0$SLURM_ARRAY_TASK_ID
fi
input_path=$1
output_path=$2
ruby extract_metadata.rb ${input_path}/${SLURM_ARRAY_TASK_ID}/ ${output_path}/${SLURM_ARRAY_TASK_ID}.txt
