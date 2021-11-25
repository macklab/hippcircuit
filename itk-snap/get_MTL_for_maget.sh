#!/bin/bash

for i in ${sbjs}; do
  parcel=11
  fslmaths ${work_dir}/sub-${i}/MTL_regrid.nii.gz \
  -thr 21 -uthr 21 -bin -mul $parcel ${work_dir}/sub-${i}/MTL_rois_for_maget.nii.gz
  atlas=${work_dir}/sub-${i}/MTL_rois_for_maget.nii.gz

  count=`echo "$parcel+1" | bc`
  for m in 22 23 24 25 26
  do
    fslmaths ${work_dir}/sub-${i}/MTL_regrid.nii.gz -thr $m -uthr $m \
    -bin -mul $count ${work_dir}/sub-${i}/tmp.nii.gz

    fslmaths ${work_dir}/sub-${i}/tmp.nii.gz \
    -binv ${work_dir}/sub-${i}/tmp2.nii.gz

    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp.nii.gz $atlas
    count=`echo "$count+1" | bc`
  done

  fslmaths ${work_dir}/sub-${i}/MTL_rois_for_maget.nii.gz -binv ${work_dir}/sub-${i}/MTL_rois_for_maget_binv.nii.gz
  fslmaths ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_T1w_GM_labels.nii.gz \
  -mas ${work_dir}/sub-${i}/MTL_rois_for_maget_binv.nii.gz \
  -add ${work_dir}/sub-${i}/MTL_rois_for_maget.nii.gz ${work_dir}/sub-${i}/MTL_hipp_subfields.nii.gz
done


# END
