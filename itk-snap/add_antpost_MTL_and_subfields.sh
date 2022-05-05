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
# sbjs=$(sed -n 1,11p ${bids_dir}/subjects_rest.txt)
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

# Add MTL to anterior/posterior subfield segmentations
for i in ${sbjs}; do
  fslmaths ${work_dir}/sub-${i}/MTL_regrid.nii.gz -binv ${work_dir}/sub-${i}/MTL_rois_binv.nii.gz
  fslmaths ${work_dir}/sub-${i}/ant_post_subfields.nii.gz \
  -mas ${work_dir}/sub-${i}/MTL_rois_binv.nii.gz \
  -add ${work_dir}/sub-${i}/MTL_regrid.nii.gz ${work_dir}/sub-${i}/ant_post_MTL_rois.nii.gz
done
