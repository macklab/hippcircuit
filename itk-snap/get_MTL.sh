#!/bin/bash

# Only extract anterior/posterior from ASHS segmentation
for i in ${sbjs}; do
  # Since ant/post subfield file ends up with 20 regions, parcel starts with 20
  parcel=21

  fslmaths ${work_dir}/sub-${i}/ant_post_all_labels.nii.gz \
  -thr 10 -uthr 10 -bin -mul $parcel ${work_dir}/sub-${i}/MTL_rois.nii.gz
  atlas=${work_dir}/sub-${i}/MTL_rois.nii.gz

  count=`echo "$parcel+1" | bc`
  for r in 13 110 113
  do
    fslmaths ${work_dir}/sub-${i}/ant_post_all_labels.nii.gz -thr $r -uthr $r\
    -bin -mul $count ${work_dir}/sub-${i}/tmp.nii.gz

    fslmaths ${work_dir}/sub-${i}/tmp.nii.gz \
    -binv ${work_dir}/sub-${i}/tmp2.nii.gz

    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp.nii.gz $atlas
    count=`echo "$count+1" | bc`
  done

  # Left PRC
  for k in 11 12
  do
    fslmaths ${work_dir}/sub-${i}/ant_post_all_labels.nii.gz -thr $k -uthr $k\
    -bin -mul 25 ${work_dir}/sub-${i}/tmp.nii.gz

    fslmaths ${work_dir}/sub-${i}/tmp.nii.gz \
    -binv ${work_dir}/sub-${i}/tmp2.nii.gz

    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp.nii.gz $atlas
  done

  # Right PRC
  for m in 111 112
  do
    fslmaths ${work_dir}/sub-${i}/ant_post_all_labels.nii.gz -thr $m -uthr $m\
    -bin -mul 26 ${work_dir}/sub-${i}/tmp.nii.gz

    fslmaths ${work_dir}/sub-${i}/tmp.nii.gz \
    -binv ${work_dir}/sub-${i}/tmp2.nii.gz

    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp.nii.gz $atlas
  done
done

# Regrid roi image with no smoothing, don't add voxels, and use nearest neighbour
# (so we retain binary output instead of averaging values)
for i in ${sbjs}; do
  ResampleImageBySpacing 3 ${work_dir}/sub-${i}/MTL_rois.nii.gz \
  ${work_dir}/sub-${i}/MTL_regrid.nii.gz 0.7 0.7 0.7 0 1 1
done

# Add MTL to anterior/posterior subfield segmentations
for i in ${sbjs}; do
  fslmaths ${work_dir}/sub-${i}/MTL_regrid.nii.gz -binv ${work_dir}/sub-${i}/MTL_rois_binv.nii.gz
  fslmaths ${work_dir}/sub-${i}/ant_post_subfields.nii.gz \
  -mas ${work_dir}/sub-${i}/MTL_rois_binv.nii.gz \
  -add ${work_dir}/sub-${i}/MTL_regrid.nii.gz ${work_dir}/sub-${i}/ant_post_MTL_rois.nii.gz
done
