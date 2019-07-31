#!/bin/bash

### --------  SLURM  ----------- ###
#SBATCH --job-name=snt_sg
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=10:00:00
#SBATCH --output="out/snt_sg_%A_%a_%j.out"
#SBATCH --error="error/snt_sg_%A_%a_%j.err"
### -------------------------- ###
echo "job name: $SLURM_JOB_NAME"
echo "SLURM_JOBID:  $SLURM_JOBID"
echo "SLURM_ARRAY_TASK_ID: $SLURM_ARRAY_TASK_ID"
echo "SLURM_ARRAY_JOB_ID: $SLURM_ARRAY_JOB_ID"

path2corpus=$1
new_corpus=$2
srcdir=$3
python $srcdir/sentence_segment.py --fname ${path2corpus}_${SLURM_ARRAY_TASK_ID} > ${new_corpus}_${SLURM_ARRAY_TASK_ID}_a
awk NF ${new_corpus}_${SLURM_ARRAY_TASK_ID}_a > ${new_corpus}_${SLURM_ARRAY_TASK_ID}
rm ${new_corpus}_${SLURM_ARRAY_TASK_ID}_a
