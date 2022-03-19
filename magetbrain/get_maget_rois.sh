#!/bin/bash

# Convert mnc to nifti
for i in ${sbjs}; do
  mkdir ${work_dir}/sub-${i}
  mnc2nii -nii ${maget_dir}/sub-${i}_T1w_labels.mnc ${work_dir}/sub-${i}/sub-${i}_T1w_labels.nii.gz
done

# Extract gray matter
for i in ${sbjs}; do
  ##Copy maget output to bids_dir and convert mnc to nifti
  mkdir ${work_dir}/sub-${i}
  #mnc2nii -nii ${maget_dir}/sub-${i}_T1w_labels.mnc ${work_dir}/sub-${i}/sub-${i}_T1w_labels.nii.gz

  fslmaths ${maget_dir}/sub-${i}_T1w_labels.nii.gz \
  -thr 1 -uthr 1 -bin ${work_dir}/sub-${i}/sub-${i}_T1w_GM_labels.nii.gz
  atlas=${work_dir}/sub-${i}/sub-${i}_T1w_GM_labels.nii.gz
  parcel=1

  count=`echo "$parcel+1" | bc`
  for r in 2 4 5 6 101 102 104 105 106
  do
    fslmaths ${maget_dir}/sub-${i}_T1w_labels.nii.gz -thr $r -uthr $r\
    -bin -mul $count ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz
    fslmaths ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz -binv ${work_dir}/sub-${i}/sub-${i}_tmp2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/sub-${i}_tmp2.nii.gz -add ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz $atlas
    count=`echo "$count+1" | bc`
  done
done

# Extract white matter
for i in ${sbjs}; do
  fslmaths ${maget_dir}/sub-${i}_T1w_labels.nii.gz \
  -thr 11 -uthr 11 -bin -mul 100 ${work_dir}/sub-${i}/sub-${i}_T1w_WM_labels.nii.gz
  atlas=${work_dir}/sub-${i}/sub-${i}_T1w_WM_labels.nii.gz
  parcel=100

  count=`echo "$parcel+1" | bc`
  for r in 12 22 33 35 37 111 222
  do
    fslmaths ${maget_dir}/sub-${i}_T1w_labels.nii.gz -thr $r -uthr $r\
    -bin -mul $count ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz
    fslmaths ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz -binv ${work_dir}/sub-${i}/sub-${i}_tmp2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/sub-${i}_tmp2.nii.gz -add ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz $atlas
    count=`echo "$count+1" | bc`
  done
done