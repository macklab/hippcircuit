#!/bin/bash

# Paths
bids_dir="/project/m/mmack/projects/hippcircuit"
work_dir="${bids_dir}/derivatives/labels"
cd ${work_dir}

# Extrat ant/post from the label file
num=$(cat ${work_dir}/itk-snap_labels.txt | awk '{print $1}' | tail -n 27)
var=$(cat ${work_dir}/itk-snap_labels.txt | awk '{print $8,$9}' | tail -n 27 | tr -s ' ' '_' | tr -d '"')
#echo $var | awk "{print \$$i}"
count=`echo "0" | bc`
rm ${work_dir}/itk-snap_antpost_names.txt
touch ${work_dir}/itk-snap_antpost_names.txt
for i in $num; do
  count=`echo "$count+1" | bc`
  if [ $i = "1" ] || [ $i = "2" ] || [ $i = "101" ] || [ $i = "102" ]; then
    echo $var | awk "{print \$$count}"
    echo $var | awk "{print \$$count}" >> "${work_dir}/itk-snap_antpost_names.txt"
  fi
done