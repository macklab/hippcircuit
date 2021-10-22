#!/bin/bash

# Extract roi from maget
num=$(cat ${bids_dir}/derivatives/mrtrix/configs/GM_labels_original.txt | awk '{print $1}' | tail -n 10)
var=$(cat ${bids_dir}/derivatives/mrtrix/configs/GM_labels_original.txt | awk '{print $8}' | tail -n 10)
for k in ${sbjs}; do
  for i in ${num}; do
    roi=$(echo $var | awk "{print \$$i}" | tr -d '"')

    fslmaths ${bids_dir}/derivatives/mrtrix/sub-${k}/sub-${k}_T1w_GM_labels.nii.gz \
    -thr ${i} -uthr ${i} -bin ${work_dir}/sub-${k}/${roi}.nii.gz
  done
done

# Create an atlas
for i in ${sbjs}; do
  fslmaths ${work_dir}/sub-${i}/R_CA1.nii.gz \
  -mas ${work_dir}/sub-${i}/Right_Anterior_dil_thr_mask.nii.gz \
  -bin -mul 1 ${work_dir}/sub-${i}/ant_post_subfields.nii.gz

  fslmaths ${work_dir}/sub-${i}/R_CA1.nii.gz \
  -mas ${work_dir}/sub-${i}/Right_Posterior_dil_thr_mask.nii.gz \
  -bin -mul 2 ${work_dir}/sub-${i}/tmp3.nii.gz

  fslmaths ${work_dir}/sub-${i}/tmp3.nii.gz -binv ${work_dir}/sub-${i}/tmp4.nii.gz
  fslmaths ${work_dir}/sub-${i}/ant_post_subfields.nii.gz \
  -mas ${work_dir}/sub-${i}/tmp4.nii.gz \
  -add ${work_dir}/sub-${i}/tmp3.nii.gz ${work_dir}/sub-${i}/ant_post_subfields.nii.gz
done

atlas=${work_dir}/sub-${i}/ant_post_subfields.nii.gz
parcel=1

# Right side
countRant=`echo "$parcel+2" | bc`
countRpost=`echo "$parcel+6" | bc`
for i in ${sbjs}; do
  for r in R_subiculum.nii.gz R_CA4DG.nii.gz R_CA2CA3.nii.gz R_stratum.nii.gz; do
    fslmaths ${work_dir}/sub-${i}/${r} -mas ${work_dir}/sub-${i}/Right_Anterior_dil_thr_mask.nii.gz \
    -bin -mul $countRant ${work_dir}/sub-${i}/tmp_ant1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_ant1.nii.gz -binv ${work_dir}/sub-${i}/tmp_ant2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_ant2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_ant1.nii.gz $atlas
    countRant=`echo "$countRant+1" | bc`

    fslmaths ${work_dir}/sub-${i}/${r} -mas ${work_dir}/sub-${i}/Right_Posterior_dil_thr_mask.nii.gz \
    -bin -mul $countRpost ${work_dir}/sub-${i}/tmp_post1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_post1.nii.gz -binv ${work_dir}/sub-${i}/tmp_post2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_post2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_post1.nii.gz $atlas
    countRpost=`echo "$countRpost+1" | bc`
  done
done

# Left side
countLant=`echo "$parcel+10" | bc`
countLpost=`echo "$parcel+15" | bc`
for i in ${sbjs}; do
  for k in L_CA1.nii.gz L_subiculum.nii.gz L_CA4DG.nii.gz L_CA2CA3.nii.gz L_stratum.nii.gz; do
    fslmaths ${work_dir}/sub-${i}/${k} -mas ${work_dir}/sub-${i}/Left_Anterior_dil_thr_mask.nii.gz \
    -bin -mul $countLant ${work_dir}/sub-${i}/tmp_ant1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_ant1.nii.gz -binv ${work_dir}/sub-${i}/tmp_ant2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_ant2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_ant1.nii.gz $atlas
    countLant=`echo "$countLant+1" | bc`

    fslmaths ${work_dir}/sub-${i}/${k} -mas ${work_dir}/sub-${i}/Left_Posterior_dil_thr_mask.nii.gz \
    -bin -mul $countLpost ${work_dir}/sub-${i}/tmp_post1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_post1.nii.gz -binv ${work_dir}/sub-${i}/tmp_post2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_post2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_post1.nii.gz $atlas
    countLpost=`echo "$countLpost+1" | bc`
  done
done
