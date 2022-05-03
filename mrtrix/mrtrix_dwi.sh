#!/bin/bash
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --time=1:00:00

#######################
#### Configuration ####
#######################
# Where logs stored - Change this for your directory
#SBATCH -o /project/m/mmack/projects/hippcircuit/code/logs/%x-%j.out

# Please also change these paths for your directory
bids_dir="/project/m/mmack/projects/hippcircuit"
#######################

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

# Check if bids dir exists
if [ -d ${bids_dir} ]
then
    echo "Directory ${bids_dir} exists."
else
    echo "Error: Directory ${bids_dir} does not exists."
fi
cd ${bids_dir}
# Set subjects
sbjs=$1

# 2) DWI Processing
# Convert diffusion image into non-compressed format
for i in ${sbjs}; do
  mrconvert ${bids_dir}/sub-${i}/dwi/data.nii.gz\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/DWI.mif -fslgrad\
  ${bids_dir}/sub-${i}/dwi/bvecs ${bids_dir}/sub-${i}/dwi/bvals\
  -datatype float32 -strides 0,0,0,1 -force
done

# Generate b=0 image
for i in ${sbjs}; do
  dwiextract ${bids_dir}/derivatives/mrtrix/sub-${i}/DWI.mif - -bzero | mrmath - mean\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/meanb0.mif -axis 3 -force
done

# Estimate multi-shell, multi-tissue response function
for i in ${sbjs}; do
  dwi2response msmt_5tt ${bids_dir}/derivatives/mrtrix/sub-${i}/DWI.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_WM.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_GM.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_CSF.txt\
  -voxels ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_voxels.mif -force
done
# Check mrview meanb0.mif -overlay.load RF_voxels.mif -overlay.opacity 0.5

# Fibre Orientation Distribution estimation
# Perform multi-shell, multi-tissue constrained spherical deconvolution
# BRANCH OUT HERE FOR FIXEL ANALYSES
for i in ${sbjs}; do
  dwi2fod msmt_csd ${bids_dir}/derivatives/mrtrix/sub-${i}/DWI.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_WM.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/WM_FODs.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_GM.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/GM.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_CSF.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/CSF.mif\
  -mask ${bids_dir}/sub-${i}/dwi/nodif_brain_mask.nii.gz -force
done
