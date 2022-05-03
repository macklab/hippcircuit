#!/bin/bash
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --time=20:00

#######################
#### Configuration ####
#######################
# Where logs stored - Change this for your directory
#SBATCH -o /project/m/mmack/projects/hippcircuit/code/logs/%x-%j.out

# Please also change these paths for your directory
bids_dir="/project/m/mmack/projects/hippcircuit"
work_dir="${bids_dir}/derivatives/itk-snap" # where segmentations stored
#######################

# Define subjects
sbjs=$1
# OR define subjects here:
# sbjs=$(sed -n 1p ${bids_dir}/subjects_rest.txt)
cd ${work_dir}

# Upload modules
module load NiaEnv/2018a
module load intel/2018.2
module load ants/2.3.1
module load openblas/0.2.20
module load fsl/.experimental-6.0.0
module load fftw/3.3.7
module load eigen/3.3.4
module load mrtrix/3.0.0
module load freesurfer/6.0.0

# Only extract anterior/posterior from ASHS segmentation
for i in ${sbjs}; do
  # Not necessary if you alread renamed the segmented file
  # cp ${work_dir}/sub-${i}/layer_002* \
  # ${work_dir}/sub-${i}/ant_post_all_labels.nii.gz

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
    var=$(cat ${bids_dir}/derivatives/labels/itk-snap_antpost_names.txt | sed -n $r'p')
    fslmaths ${work_dir}/sub-${i}/ant_post_regrid.nii.gz \
    -thr $r -uthr $r -bin ${work_dir}/sub-${i}/${var}.nii.gz
  done
done

# Dilate ant/post
for i in ${sbjs}; do
  for r in $(cat ${bids_dir}/derivatives/labels/itk-snap_antpost_names.txt); do
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
