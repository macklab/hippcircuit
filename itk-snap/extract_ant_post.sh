#!/bin/bash

# Only extract anterior/posterior from ASHS segmentation
for i in ${sbjs}; do
  cp ${work_dir}/sub-${i}/layer_002* \
  ${work_dir}/sub-${i}/ant_post_all_labels.nii.gz

  fslmaths ${work_dir}/sub-${i}/ant_post_all_labels.nii.gz \
  -thr 1 -uthr 1 -bin ${work_dir}/sub-${i}/ant_post_rois.nii.gz
  atlas=${work_dir}/sub-${i}/ant_post_rois.nii.gz
  parcel=1

  count=`echo "$parcel+1" | bc`
  for r in 2 101 102
  do
    fslmaths ${work_dir}/sub-${i}/ant_post_all_labels.nii.gz -thr $r -uthr $r\
    -bin -mul $count ${work_dir}/sub-${i}/tmp.nii.gz

    fslmaths ${work_dir}/sub-${i}/tmp.nii.gz \
    -binv ${work_dir}/sub-${i}/tmp2.nii.gz

    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp.nii.gz $atlas
    count=`echo "$count+1" | bc`
  done
done

# Regrid roi image with no smoothing, don't add voxels, and use nearest neighbour
# (so we retain binary output instead of averaging values)
for i in ${sbjs}; do
  ResampleImageBySpacing 3 ${work_dir}/sub-${i}/ant_post_rois.nii.gz \
  ${work_dir}/sub-${i}/ant_post_regrid.nii.gz 0.7 0.7 0.7 0 1 1
done

# Extract ant/post
for i in ${sbjs}; do
  for r in 1 2 3 4
  do
    var=$(cat ${work_dir}/configs/itk_antpost_labels.txt | sed -n $r'p')
    fslmaths ${work_dir}/sub-${i}/ant_post_regrid.nii.gz \
    -thr $r -uthr $r -bin ${work_dir}/sub-${i}/${var}.nii.gz
  done
done

#Dilate ant/post
for i in ${sbjs}; do
  for r in $(cat ${work_dir}/configs/itk_antpost_labels.txt); do
    fslmaths ${work_dir}/sub-${i}/${r}.nii.gz \
    -kernel sphere 2.5 -dilM ${work_dir}/sub-${i}/${r}_dil.nii.gz

    fslmaths ${work_dir}/sub-${i}/${r}_dil.nii.gz \
    -thr 0.5 -bin ${work_dir}/sub-${i}/${r}_dil_thr.nii.gz

    fslmaths ${work_dir}/sub-${i}/${r}.nii.gz \
    -binv ${work_dir}/sub-${i}/${r}_binv.nii.gz
  done
done

# Subtract ant from post and post from ant
for i in ${sbjs}; do
  fslmaths ${work_dir}/sub-${i}/Left_Anterior_dil_thr.nii.gz \
  -mas ${work_dir}/sub-${i}/Left_Posterior_binv.nii.gz \
  ${work_dir}/sub-${i}/Left_Anterior_dil_thr_mask.nii.gz

  fslmaths ${work_dir}/sub-${i}/Left_Posterior_dil_thr.nii.gz \
  -mas ${work_dir}/sub-${i}/Left_Anterior_binv.nii.gz \
  ${work_dir}/sub-${i}/Left_Posterior_dil_thr_mask.nii.gz

  fslmaths ${work_dir}/sub-${i}/Right_Anterior_dil_thr.nii.gz \
  -mas ${work_dir}/sub-${i}/Right_Posterior_binv.nii.gz \
  ${work_dir}/sub-${i}/Right_Anterior_dil_thr_mask.nii.gz

  fslmaths ${work_dir}/sub-${i}/Right_Posterior_dil_thr.nii.gz \
  -mas ${work_dir}/sub-${i}/Right_Anterior_binv.nii.gz \
  ${work_dir}/sub-${i}/Right_Posterior_dil_thr_mask.nii.gz
done
