#!/bin/bash
set -x
set -e

path2json=../json # assuming xml_parse.sh provided output to this dir
path2txt=../txt
mkdir -p ${path2txt}
end=3

for j in $(seq 0 $end)
do 
  input_path=${path2json}/${j}
  output_path=${path2txt}/txt
  folder=${j}
  mkdir -p ${output_path}
  num1=00
  num2=39
  sbatch --array=${num1}-${num2} json2text.sh ${input_path} ${output_path} ${folder} 
done
