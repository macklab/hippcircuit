#!/bin/bash
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --time=30:00

#######################
#### Configuration ####
#######################
# Where logs stored - Change this for your directory
#SBATCH -o /project/m/mmack/projects/hippcircuit/code/logs/%x-%j.out

# Please also change these paths for your directory
bids_dir="/project/m/mmack/projects/hippcircuit"
work_dir="${bids_dir}/derivatives/mrtrix"
#######################

# Input subjects
sbjs=$1
cd ${bids_dir}

# Upload modules
module load NiaEnv/2018a
module load openblas/0.2.20
module load fsl/.experimental-6.0.0

# Extract gray matter
for i in ${sbjs}; do
  fslmaths ${work_dir}/sub-${i}/sub-${i}_T1w_labels.nii.gz \
  -thr 1 -uthr 1 -bin ${work_dir}/sub-${i}/sub-${i}_T1w_GM_labels.nii.gz
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

# Extract white matter
for i in ${sbjs}; do
  fslmaths ${work_dir}/sub-${i}/sub-${i}_T1w_labels.nii.gz \
  -thr 11 -uthr 11 -bin -mul 100 ${work_dir}/sub-${i}/sub-${i}_T1w_WM_labels.nii.gz
  atlas=${work_dir}/sub-${i}/sub-${i}_T1w_WM_labels.nii.gz
  parcel=100

  count=`echo "$parcel+1" | bc`
  for r in 12 22 33 35 37 111 222
  do
    fslmaths ${work_dir}/sub-${i}/sub-${i}_T1w_labels.nii.gz -thr $r -uthr $r\
    -bin -mul $count ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz
    fslmaths ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz -binv ${work_dir}/sub-${i}/sub-${i}_tmp2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/sub-${i}_tmp2.nii.gz -add ${work_dir}/sub-${i}/sub-${i}_tmp.nii.gz $atlas
    count=`echo "$count+1" | bc`
  done
done
