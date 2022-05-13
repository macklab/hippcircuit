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

####### Gray Matter Nodes #######
# Warp nodes to T1 template
for i in $sbjs; do
  mrtransform ${bids_dir}/derivatives/itk-snap/sub-${i}/MTL_hipp_subfields.nii.gz \
  -warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  -interp nearest -datatype Float32LE \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/MTL_hipp_subfields_in_template_space.mif \
  -template ${bids_dir}/derivatives/itk-snap/sub-${i}/MTL_hipp_subfields.nii.gz -force
done

# Convert mifs to nifti for ants
for i in $sbjs; do
  mrconvert ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/MTL_hipp_subfields_in_template_space.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/MTL_hipp_subfields_in_template_space.nii.gz -force
done

# Node template
ImageMath 3 ${bids_dir}/derivatives/fixel-based/template/MTL_hipp_subfields_template.nii.gz \
  MajorityVoting ${bids_dir}/derivatives/fixel-based/fixels/sub-*/MTL_hipp_subfields_in_template_space.nii.gz

####### White Matter Labels #######
# Warp white matter ROIs from magetbrain for visualization
for i in $sbjs; do
  mrtransform ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_T1w_WM_labels.nii.gz \
  -warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  -interp nearest -datatype Float32LE \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/WM_labels_in_template_space.mif \
  -template ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_T1w_WM_labels.nii.gz -force
done

# Convert mifs to nifti for ants
for i in $sbjs; do
  mrconvert ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/WM_labels_in_template_space.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/WM_labels_in_template_space.nii.gz -force
done

# White matter label template
ImageMath 3 ${bids_dir}/derivatives/fixel-based/template/WM_label_template.nii.gz \
  MajorityVoting ${bids_dir}/derivatives/fixel-based/fixels/sub-*/WM_labels_in_template_space.nii.gz
