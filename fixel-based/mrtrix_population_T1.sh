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

# Define subjects of interest
sbjs=$1
# OR define here:
# sbjs=$(sed -n 1,831p ${bids_dir}/derivatives/subjects/final_subjects.txt)

# Warp T1s to template space
# Convert T1s to mif
for i in $sbjs; do
  mrconvert ${scratch_dir}/sub-${i}/anat/T1w_acpc_dc_restore_brain.nii.gz \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/T1_input.mif
done

# Compute the template T1 (intersection of all subject T1s in template space)
for i in $sbjs; do
  mrtransform ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/T1_input.mif \
  -warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  -interp nearest -datatype Float32LE \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/T1_in_template_space.mif \
  -template ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/T1_input.mif -force
done

# Compute the template as the intersection of all warped T1s
mrmath ${bids_dir}/derivatives/fixel-based/fixels/sub-*/T1_in_template_space.mif \
  mean ${bids_dir}/derivatives/fixel-based/template/T1_template.mif -datatype Float32LE -force
