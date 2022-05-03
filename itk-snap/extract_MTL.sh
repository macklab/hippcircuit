#!/bin/bash
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --time=24:00:00

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
