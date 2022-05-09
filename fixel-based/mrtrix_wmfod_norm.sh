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
#######################

# Load modules
module load NiaEnv/2018a
module load intel/2018.2
module load ants/2.3.1
module load openblas/0.2.20
module load fsl/.experimental-6.0.0
module load fftw/3.3.7
module load eigen/3.3.4
module load mrtrix/3.0.0
module load freesurfer/6.0.0

# Define all subjects of interest
sbjs=$1
# OR define here:
# sbjs=$(sed -n 1,831p ${bids_dir}/derivatives/subjects/final_subjects.txt)

# Create subject specific folders for FBA
mkdir ${bids_dir}/derivatives/fixel-based/fixels
for i in ${sbjs}; do
  mkdir ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}
done

# 1) Compute brain mask images
for i in ${sbjs}; do
  dwi2mask ${bids_dir}/derivatives/mrtrix/sub-${i}/DWI.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/mask.mif
done

# 2) Joint bias field correction and global intensity normalisation
for i in ${sbjs}; do
  mtnormalise ${bids_dir}/derivatives/mrtrix/sub-${i}/WM_FODs.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/WM_FODs_norm.mif \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/GM.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/GM_norm.mif \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/CSF.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/CSF_norm.mif \
  -mask ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/mask.mif
done
