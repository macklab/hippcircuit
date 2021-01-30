#!/bin/bash

# Extract gray matter ROIs from hipp-WM Atlas
# Custom directories
#bids_dir="/data/hippcircuit"
#work_dir="${bids_dir}/derivatives/mrtrix"

#sbjs="sub-103212"
# sbjs=$(head -1 subjects.txt)

bids_dir="/scratch/m/mmack/gumusmel/hippcircuit"
mnc_dir="/scratch/m/mmack/mmack/projects/hcp_maget/output/fusion/majority_vote"
work_dir="${bids_dir}/derivatives/mrtrix"
cd ${bids_dir}

for i in ${sbjs}; do
  ##Copy maget output to bids_dir and convert mnc to nifti
  mkdir ${bids_dir}/derivatives/mrtrix/sub-${i}
  mnc2nii -nii ${mnc_dir}/sub-${i}_T1w_labels.mnc ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_T1w_labels.nii.gz

  fslmaths ${work_dir}/sub-${i}/sub-${i}_T1w_labels.nii.gz -thr 1 -uthr 1 -bin ${work_dir}/sub-${i}/sub-${i}_T1w_GM_labels
  atlas=${work_dir}/sub-${i}/sub-${i}_T1w_GM_labels.nii.gz
  parcel=1

  count=`echo "$parcel+1" | bc`
  for r in 2 4 5 6 101 102 104 105 106
  do
    fslmaths ${work_dir}/sub-${i}/sub-${i}_T1w_labels.nii.gz -thr $r -uthr $r\
    -bin -mul $count ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz
    fslmaths ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz -binv ${work_dir}/sub-${i}/sub-${i}_tmp2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/sub-${i}_tmp2.nii.gz -add ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz $atlas
    count=`echo "$count+1" | bc`
  done
done
