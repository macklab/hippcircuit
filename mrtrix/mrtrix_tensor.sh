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

# 4) FA/MD/RD/AD Tensor Images #
# Create a mask
for i in ${sbjs};do
  dwi2mask ${bids_dir}/sub-${i}/dwi/data.nii.gz \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/tempmask.mif \
  -fslgrad ${bids_dir}/sub-${i}/dwi/bvecs \
  ${bids_dir}/sub-${i}/dwi/bvals -force
done

# Create tensor images
for i in ${sbjs}; do
  dwi2tensor ${bids_dir}/sub-${i}/dwi/data.nii.gz \
  -mask ${bids_dir}/derivatives/mrtrix/sub-${i}/tempmask.mif \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/tensor.mif \
  -fslgrad ${bids_dir}/sub-${i}/dwi/bvecs \
  ${bids_dir}/sub-${i}/dwi/bvals -force
done

# Create metric specific images
for i in ${sbjs}; do
  tensor2metric ${bids_dir}/derivatives/mrtrix/sub-${i}/tensor.mif \
  -fa ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_FA.mif \
  -adc ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_MD.mif \
  -ad ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_AD.mif \
  -rd ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_RD.mif -force
done

# Sample tractography for tensors
metrics="FA MD AD RD"
for i in ${sbjs}; do
  for t in ${metrics}; do
    tcksample ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
    ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_${t}.mif \
    ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_${t}.csv -stat_tck mean
  done
done
