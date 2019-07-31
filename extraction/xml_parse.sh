#!/bin/bash
set -x
set -e

# The PMC dataset assumes 4 folders with 40 xml files in them (adjust accordigmly to your dataset)
path2pmc=../xml
path2json=../json
end=3 # foldes
mkdir -p ${path2json}
mkdir -p error
mkdir -p out

for j in $(seq 0 $end) # running on pmc-text-0?
do 
  input_path=${path2pmc}/pmc/pmc-text-0${j}
  output_path=${path2json}/${j}
  mkdir -p ${output_path}
  num1=00 # files-
  num2=39 # range
  sbatch --array=${num1}-${num2} extract_metadata.sh ${input_path} ${output_path} 
done
