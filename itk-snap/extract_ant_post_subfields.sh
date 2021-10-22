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

  atlas=${work_dir}/sub-${i}/ant_post_subfields.nii.gz
  parcel=1

  # Right side
  countRant=`echo "$parcel+2" | bc`
  countRpost=`echo "$parcel+6" | bc`

  for r in R_subiculum.nii.gz R_CA4DG.nii.gz R_CA2CA3.nii.gz R_stratum.nii.gz; do
    fslmaths ${work_dir}/sub-${i}/${r} -mas ${work_dir}/sub-${i}/Right_Anterior_dil_thr_mask.nii.gz \
    -bin -mul $countRant ${work_dir}/sub-${i}/tmp_ant1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_ant1.nii.gz -binv ${work_dir}/sub-${i}/tmp_ant2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_ant2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_ant1.nii.gz $atlas
    countRant=`echo "$countRant+1" | bc`

    fslmaths ${work_dir}/sub-${i}/${r} -mas Right_Posterior_dil_thr_mask.nii.gz \
    -bin -mul $countRpost tmp_post1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_post1.nii.gz -binv ${work_dir}/sub-${i}/tmp_post2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_post2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_post1.nii.gz $atlas
    countRpost=`echo "$countRpost+1" | bc`
  done

  # Left side
  countLant=`echo "$parcel+10" | bc`
  countLpost=`echo "$parcel+15" | bc`
  for i in L_CA1.nii.gz L_subiculum.nii.gz L_CA4DG.nii.gz L_CA2CA3.nii.gz L_stratum.nii.gz; do
    fslmaths ${work_dir}/sub-${i}/${r} -mas ${work_dir}/sub-${i}/Left_Anterior_dil_thr_mask.nii.gz \
    -bin -mul $countLant ${work_dir}/sub-${i}/tmp_ant1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_ant1.nii.gz -binv ${work_dir}/sub-${i}/tmp_ant2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_ant2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_ant1.nii.gz $atlas
    countLant=`echo "$countLant+1" | bc`

    fslmaths ${work_dir}/sub-${i}/${r} -mas ${work_dir}/sub-${i}/Left_Posterior_dil_thr_mask.nii.gz \
    -bin -mul $countLpost ${work_dir}/sub-${i}/tmp_post1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_post1.nii.gz -binv ${work_dir}/sub-${i}/tmp_post2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_post2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_post1.nii.gz $atlas
    countLpost=`echo "$countLpost+1" | bc`
  done
done



# while IFS="" read -r p || [ -n "$p" ]
# do
#   # printf '%s\n' "$p"
#   awk '{print $1, $8}' | tail -n 10
# done < GM_labels_original.txt

# num=$(cat GM_labels_original.txt | awk '{print $1}' | tail -n 10)
# for i in ${num}; do
#   roi=$(echo $var | awk "{print \$$i}" | tr -d '"')
#   echo 'hi' ${roi}
# done





# Extract subfields from maget
# for i in ${sbjs}; do
#   fslmaths ${bids_dir}/mrtrix/sub-${i}/sub-${i}_T1w_GM_labels.nii \
#   -thr 1 -uthr 1 -bin ${work_dir}/sub-${i}/R_CA1.nii.gz
#   fslmaths ${bids_dir}/mrtrix/sub-${i}/sub-${i}_T1w_GM_labels.nii \
#   -thr 6 -uthr 6 -bin L_CA1.nii.gz
#
#   fslmaths T1w_GM_labels.nii -thr 2 -uthr 2 -bin R_subiculum.nii.gz
#   fslmaths sub-150019_T1w_GM_labels.nii -thr 7 -uthr 7 -bin L_subiculum.nii.gz
#
#   fslmaths sub-150019_T1w_GM_labels.nii -thr 3 -uthr 3 -bin R_CA4DG.nii.gz
#   fslmaths sub-150019_T1w_GM_labels.nii -thr 8 -uthr 8 -bin L_CA4DG.nii.gz
#
#   fslmaths sub-150019_T1w_GM_labels.nii -thr 4 -uthr 4 -bin R_CA2CA3.nii.gz
#   fslmaths sub-150019_T1w_GM_labels.nii -thr 9 -uthr 9 -bin L_CA2CA3.nii.gz
#
#   fslmaths sub-150019_T1w_GM_labels.nii -thr 5 -uthr 5 -bin R_stratum.nii.gz
#   fslmaths sub-150019_T1w_GM_labels.nii -thr 10 -uthr 10 -bin L_stratum.nii.gz
# done
#



###### CA1
# # Extract L CA1
# fslmaths sub-150019_T1w_GM_labels.nii -thr 1 -uthr 1 -bin R_CA1.nii.gz
# fslmaths sub-150019_T1w_GM_labels.nii -thr 6 -uthr 6 -bin L_CA1.nii.gz
#
# fslmaths sub-150019_T1w_GM_labels.nii -thr 2 -uthr 2 -bin R_subiculum.nii.gz
# fslmaths sub-150019_T1w_GM_labels.nii -thr 7 -uthr 7 -bin L_subiculum.nii.gz
#
# fslmaths sub-150019_T1w_GM_labels.nii -thr 3 -uthr 3 -bin R_CA4DG.nii.gz
# fslmaths sub-150019_T1w_GM_labels.nii -thr 8 -uthr 8 -bin L_CA4DG.nii.gz
#
# fslmaths sub-150019_T1w_GM_labels.nii -thr 4 -uthr 4 -bin R_CA2CA3.nii.gz
# fslmaths sub-150019_T1w_GM_labels.nii -thr 9 -uthr 9 -bin L_CA2CA3.nii.gz
#
# fslmaths sub-150019_T1w_GM_labels.nii -thr 5 -uthr 5 -bin R_stratum.nii.gz
# fslmaths sub-150019_T1w_GM_labels.nii -thr 10 -uthr 10 -bin L_stratum.nii.gz

# fslmaths sub-150019_T1w_GM_labels.nii -thr 2 -uthr 2 -bin R_subiculum.nii.gz
# fslmaths sub-150019_T1w_GM_labels.nii -thr 5 -uthr 5 -bin L_CA1.nii.gz
# fslmaths sub-150019_T1w_GM_labels.nii -thr 5 -uthr 5 -bin L_CA1.nii.gz
# fslmaths sub-150019_T1w_GM_labels.nii -thr 5 -uthr 5 -bin L_CA1.nii.gz
# fslmaths sub-150019_T1w_GM_labels.nii -thr 5 -uthr 5 -bin L_CA1.nii.gz
# fslmaths sub-150019_T1w_GM_labels.nii -thr 5 -uthr 5 -bin L_CA1.nii.gz
#
# 0     0    0    0        0  0  0    "Clear Label"
# 1   255    0    0        1  1  1    "R_CA1"
# 2     0  255    0        1  1  1    "R_subiculum"
# 3     0    0  255        1  1  1    "R_CA4DG"
# 4   255  255    0        1  1  1    "R_CA2CA3"
# 5     0  255  255        1  1  1    "R_stratum"
# 6   255    0    0        1  1  1    "L_CA1"
# 7     0  255    0        1  1  1    "L_subiculum"
# 8     0    0  255        1  1  1    "L_CA4DG"
# 9   255  255    0        1  1  1    "L_CA2CA3"
# 10    0  255  255        1  1  1    "L_stratum"

# #flirt -ref <image in space you want to be in> -in <input image> -out <input image in new space> -nosearch -interp trilinear
# flirt -ref sub-150019_T1w_GM_labels.nii -in L_ant_hip_dil_thr_mask.nii.gz -out L_ant_hip_moved.nii.gz -nosearch -interp trilinear
# flirt -ref sub-150019_T1w_GM_labels.nii -in L_post_hip_dil_thr_mask.nii.gz -out L_post_hip_moved.nii.gz -nosearch -interp trilinear
# flirt -ref sub-150019_T1w_GM_labels.nii -in R_ant_hip_dil_thr_mask.nii.gz -out R_ant_hip_moved.nii.gz -nosearch -interp trilinear
# flirt -ref sub-150019_T1w_GM_labels.nii -in R_post_hip_dil_thr_mask.nii.gz -out R_post_hip_moved.nii.gz -nosearch -interp trilinear

# for m in L R
# do
#   for i in ${m}_CA1.nii.gz ${m}_subiculum.nii.gz ${m}_CA4DG.nii.gz ${m}_CA2CA3.nii.gz ${m}_stratum.nii.gz
#   do
#     sub_name=$(echo ${i} | cut -d_ -f2 | cut -d. -f1)
#     for r in ${m}_ant_hip_moved.nii.gz ${m}_post_hip_moved.nii.gz
#     do
#       ori_name=$(echo ${r} | cut -d_ -f2)
#       fslmaths ${i} -mas ${m}_${ori_name}_hip_moved.nii.gz ${m}_${ori_name}_${sub_name}.nii.gz
#     done
#   done
# done
#
# #
# fslmaths R_CA1.nii.gz -mas R_ant_hip_dil_thr_mask.nii.gz R_ant_CA1.nii.gz
#
# for m in L R
# do
#   for i in ${m}_CA1.nii.gz ${m}_subiculum.nii.gz ${m}_CA4DG.nii.gz ${m}_CA2CA3.nii.gz ${m}_stratum.nii.gz
#   do
#     sub_name=$(echo ${i} | cut -d_ -f2 | cut -d. -f1)
#     for r in ${m}_ant_hip_dil_thr_mask.nii.gz ${m}_post_hip_dil_thr_mask.nii.gz
#     do
#       ori_name=$(echo ${r} | cut -d_ -f2)
#       fslmaths ${i} -mas ${m}_${ori_name}_hip_dil_thr_mask.nii.gz ${m}_${ori_name}_${sub_name}.nii.gz
#     done
#   done
# done
#
# fslmaths R_CA1.nii.gz -bin -mul 1 ant_post_subfields.nii.gz


#
# fslmaths sub-150019_T1w_GM_labels.nii -thr 1 -uthr 1 -bin R_CA1.nii.gz

# cp layer_002* ant_post_all_labels.nii.gz
# fslmaths ant_post_all_labels.nii.gz \
# -thr 1 -uthr 1 -bin R_CA1.nii.gz
# atlas=ant_post_rois.nii.gz
# parcel=1
#
# count=`echo "$parcel+1" | bc`
# for r in 2 101 102
# do
#   fslmaths ant_post_all_labels.nii.gz -thr $r -uthr $r\
#   -bin -mul $count tmp.nii.gz
#   fslmaths tmp.nii.gz -binv tmp2.nii.gz
#   fslmaths $atlas -mas tmp2.nii.gz -add tmp.nii.gz $atlas
#   count=`echo "$count+1" | bc`
# done
##
fslmaths R_CA1.nii.gz -mas R_ant_hip_dil_thr_mask.nii.gz -bin -mul 1 ant_post_subfields.nii.gz
fslmaths R_CA1.nii.gz -mas R_post_hip_dil_thr_mask.nii.gz -bin -mul 2 tmp3.nii.gz
fslmaths tmp3.nii.gz -binv tmp4.nii.gz
fslmaths ant_post_subfields.nii.gz -mas tmp4.nii.gz -add tmp3.nii.gz ant_post_subfields.nii.gz
atlas=ant_post_subfields.nii.gz
parcel=1
#fslmaths ant_post_subfields.nii.gz -add tmp3.nii.gz

countRant=`echo "$parcel+2" | bc`
for i in R_subiculum.nii.gz R_CA4DG.nii.gz R_CA2CA3.nii.gz R_stratum.nii.gz; do
  fslmaths ${i} -mas R_ant_hip_dil_thr_mask.nii.gz -bin -mul $countRant tmp_ant1.nii.gz
  fslmaths tmp_ant1.nii.gz -binv tmp_ant2.nii.gz
  fslmaths $atlas -mas tmp_ant2.nii.gz -add tmp_ant1.nii.gz $atlas
  countRant=`echo "$countRant+1" | bc`
done

countRpost=`echo "$parcel+6" | bc`
for i in R_subiculum.nii.gz R_CA4DG.nii.gz R_CA2CA3.nii.gz R_stratum.nii.gz; do
  fslmaths ${i} -mas R_post_hip_dil_thr_mask.nii.gz -bin -mul $countRpost tmp_post1.nii.gz
  fslmaths tmp_post1.nii.gz -binv tmp_post2.nii.gz
  fslmaths $atlas -mas tmp_post2.nii.gz -add tmp_post1.nii.gz $atlas
  countRpost=`echo "$countRpost+1" | bc`
done

countLant=`echo "$parcel+10" | bc`
countLpost=`echo "$parcel+15" | bc`
for i in L_CA1.nii.gz L_subiculum.nii.gz L_CA4DG.nii.gz L_CA2CA3.nii.gz L_stratum.nii.gz; do
  fslmaths ${i} -mas L_ant_hip_dil_thr_mask.nii.gz -bin -mul $countLant tmp_ant1.nii.gz
  fslmaths tmp_ant1.nii.gz -binv tmp_ant2.nii.gz
  fslmaths $atlas -mas tmp_ant2.nii.gz -add tmp_ant1.nii.gz $atlas
  countLant=`echo "$countLant+1" | bc`

  fslmaths ${i} -mas L_post_hip_dil_thr_mask.nii.gz -bin -mul $countLpost tmp_post1.nii.gz
  fslmaths tmp_post1.nii.gz -binv tmp_post2.nii.gz
  fslmaths $atlas -mas tmp_post2.nii.gz -add tmp_post1.nii.gz $atlas
  countLpost=`echo "$countLpost+1" | bc`
done


#
# for m in L R
# do
#   for i in ${m}_CA1.nii.gz ${m}_subiculum.nii.gz ${m}_CA4DG.nii.gz ${m}_CA2CA3.nii.gz ${m}_stratum.nii.gz
#   do
#     sub_name=$(echo ${i} | cut -d_ -f2 | cut -d. -f1)
#     for r in ${m}_ant_hip_dil_thr_mask.nii.gz ${m}_post_hip_dil_thr_mask.nii.gz
#     do
#       ori_name=$(echo ${r} | cut -d_ -f2)
#       fslmaths ${i} -mas ${m}_${ori_name}_hip_moved.nii.gz ${m}_${ori_name}_${sub_name}.nii.gz
#     done
#   done
# done
#
#
#
#
#
#
#
#
#
# ## new
#
# cp layer_002* ant_post_all_labels.nii.gz
# fslmaths ant_post_all_labels.nii.gz \
# -thr 1 -uthr 1 -bin ant_post_rois.nii.gz
# atlas=ant_post_rois.nii.gz
# parcel=1
#
# count=`echo "$parcel+1" | bc`
# for r in 2 101 102
# do
#   fslmaths ant_post_all_labels.nii.gz -thr $r -uthr $r\
#   -bin -mul $count tmp.nii.gz
#   fslmaths tmp.nii.gz -binv tmp2.nii.gz
#   fslmaths $atlas -mas tmp2.nii.gz -add tmp.nii.gz $atlas
#   count=`echo "$count+1" | bc`
# done
#
#
# for m in L R
# do
#   for i in ${m}_CA1.nii.gz ${m}_subiculum.nii.gz ${m}_CA4DG.nii.gz ${m}_CA2CA3.nii.gz ${m}_stratum.nii.gz
#   do
#     sub_name=$(echo ${i} | cut -d_ -f2 | cut -d. -f1)
#     for r in ${m}_ant_hip_dil_thr_mask.nii.gz ${m}_post_hip_dil_thr_mask.nii.gz
#     do
#       ori_name=$(echo ${r} | cut -d_ -f2)
#       fslmaths ${i} -mas ${m}_${ori_name}_hip_dil_thr_mask.nii.gz ${m}_${ori_name}_${sub_name}.nii.gz
#     done
#   done
# done
#
#
# # NEW new
#
# cp layer_002* ant_post_all_labels.nii.gz
# fslmaths ant_post_all_labels.nii.gz \
# -thr 1 -uthr 1 -bin ant_post_rois.nii.gz
# atlas=ant_post_rois.nii.gz
# parcel=1
#
# count=`echo "$parcel+1" | bc`
# for r in 2 101 102
# do
#   fslmaths ant_post_all_labels.nii.gz -thr $r -uthr $r\
#   -bin -mul $count tmp.nii.gz
#   fslmaths tmp.nii.gz -binv tmp2.nii.gz
#   fslmaths $atlas -mas tmp2.nii.gz -add tmp.nii.gz $atlas
#   count=`echo "$count+1" | bc`
# done
#
#
# fslmaths sub-150019_T1w_GM_labels.nii -thr 1 -uthr 1\
# -bin tmp3.nii.gz
# fslmaths tmp3.nii.gz -mas L_ant_hip_dil_thr_mask.nii.gz ant_post_subfields.nii.gz
# atlas=ant_post_subfields.nii.gz
# parcel=1
#
# for i in 1 2 3 4 5 6 7 8 9 10; do
#   fslmaths sub-150019_T1w_GM_labels.nii -thr $i -uthr $i\
#   -bin -mul $count tmp.nii.gz
#   for r in L_ant_hip_dil_thr_mask.nii.gz L_post_hip_dil_thr_mask.nii.gz
#   do
#     #fslmaths ${i} -mas ${m}_${ori_name}_hip_dil_thr_mask.nii.gz ${m}_${ori_name}_${sub_name}.nii.gz
#     fslmaths tmp.nii.gz -mas ${r} tmp2.nii.gz
#
#   done
# done
#
# lab=$(awk '{print $NF}' GM_labels_original.txt | tail -n -10)
# lab=$(awk '{print $NF}' GM_labels_original.txt | tail -n -10 | paste -s -d" " -)
#
#
# lab=$(awk '{print $NF}' GM_labels_original.txt | tail -n -10 | paste -s -d" " -)
# while read -n 1 char
# do
#   echo ${i}_hi
# done
#
# awk '{print $NF}' GM_labels_original.txt | tail -n -3 | head -n 1
#
# label=$(awk '{print $1}' GM_labels_original.txt | tail -n 10)
# for i in ${label}
# do
#   echo ${i}_hi
# done
#
# while read L; do
#   awk '{print $NF}' | tail -n -10
#   echo $L
# done < GM_labels_original.txt
#
#
# for i in ${lab[@]}
# do
#   echo ${i}_hi
# done
#
# ####
# # Left
# #for i in ${m}_CA1.nii.gz ${m}_subiculum.nii.gz ${m}_CA4DG.nii.gz ${m}_CA2CA3.nii.gz ${m}_stratum.nii.gz
# for i in 1 2 3 4 5
# do
#   #sub_name=$(echo ${i} | cut -d_ -f2 | cut -d. -f1)
#   for r in L_ant_hip_moved.nii.gz L_post_hip_moved.nii.gz
#   do
#       fslmaths ${i} -mas ${m}_${ori_name}_hip_moved.nii.gz ${m}_${ori_name}_${sub_name}.nii.gz
#     done
#   done
# done
#
# # flirt -ref ${i} -in ${r} -out ${m}_${ori_name}_hip_dil_thr_mask_space.nii.gz -nosearch -interp trilinear
# #
# #
# # flirt -ref L_CA1.nii.gz -in L_ant_hip_dil_thr_mask.nii.gz -out L_ant_hip_dil_thr_mask_space.nii.gz -nosearch -interp trilinear
# # fslmaths L_CA1.nii.gz -mas L_ant_hip_dil_thr_mask_space.nii.gz L_ant_CA1.nii.gz
# #
# #
# # fslmaths L_ant_hip_dil_thr_mask_space.nii.gz -binv L_ant_hip_dil_thr_mask_space_binv.nii.gz
# # fslmaths L_CA1.nii.gz -mas L_ant_hip_dil_thr_mask_space_binv.nii.gz L_ant_CA1_new.nii.gz
# #
# #
# # # fslmaths L_ant_hip.nii.gz -binv L_ant_hip_binv.nii.gz
# # # fslmaths L_post_hip_dil_thr.nii.gz -mas L_ant_hip_binv.nii.gz L_post_hip_dil_thr_mask.nii.gz
# #
# #
# #
# # # Exctract L anterior CA1
# # flirt -ref L_CA1.nii.gz -in L_ant_hip_dil_thr_mask.nii.gz -out L_ant_hip_dil_thr_mask_space.nii.gz -nosearch -interp trilinear
# # fslmaths L_CA1.nii.gz -mas L_ant_hip_dil_thr_mask_space.nii.gz L_ant_CA1.nii.gz
# #
# # # Extract L posterior CA1
# # flirt -ref L_CA1.nii.gz -in L_post_hip_dil_thr_mask.nii.gz -out L_post_hip_dil_thr_mask_space.nii.gz -nosearch -interp trilinear
# # fslmaths L_CA1.nii.gz -mas L_post_hip_dil_thr_mask_space.nii.gz L_post_CA1.nii.gz
# #
# # # Exctract R anterior CA1
# # flirt -ref R_CA1.nii.gz -in R_ant_hip_dil_thr_mask.nii.gz -out R_ant_hip_dil_thr_mask_space.nii.gz -nosearch -interp trilinear
# # fslmaths R_CA1.nii.gz -mas R_ant_hip_dil_thr_mask_space.nii.gz R_ant_CA1.nii.gz
# #
# # # Extract R posterior CA1
# # flirt -ref R_CA1.nii.gz -in R_post_hip_dil_thr_mask.nii.gz -out R_post_hip_dil_thr_mask_space.nii.gz -nosearch -interp trilinear
# # fslmaths R_CA1.nii.gz -mas R_post_hip_dil_thr_mask_space.nii.gz R_post_CA1.nii.gz
# #
# # ###### CA2CA3
