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
