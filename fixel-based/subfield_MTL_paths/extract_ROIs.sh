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

# Create folders
mkdir ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths
mkdir ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois

# Define labels and label number
rois="CA4DG CA2CA3 CA1 SUB ERC"
R_labels="3 4 1 2 13"
L_labels="8 9 6 7 11"

# 1) Extract ROIs of interest
# Right side
for i in 1 2 3 4 5; do
  roi_num=$(echo $rois | awk '{print $'$i'}')
  label_num=$(echo $R_labels| awk '{print $'$i'}')

  fslmaths \
  ${bids_dir}/derivatives/fixel-based/template/MTL_hipp_subfields_template.nii.gz \
  -thr $label_num -uthr $label_num -bin -mul $label_num \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/R_${roi_num}.nii.gz
done

# Left side
for i in 1 2 3 4 5; do
  roi_num=$(echo $rois | awk '{print $'$i'}')
  label_num=$(echo $L_labels| awk '{print $'$i'}')

  fslmaths \
  ${bids_dir}/derivatives/fixel-based/template/MTL_hipp_subfields_template.nii.gz \
  -thr $label_num -uthr $label_num -bin -mul $label_num \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/L_${roi_num}.nii.gz
done

# Create a folder for each pair
for i in R L; do
  for j in ERC_CA4DG CA4DG_CA2CA3 CA2CA3_CA1 CA1_SUB SUB_ERC ERC_CA1 SUB_CA4DG; do
    mkdir ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_${j}
  done
done

# 2) Add pairs of ROIs to each other so we can look at the tracts connecting them
for i in R L; do
  # For TSP
  fslmaths \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_ERC.nii.gz \
  -add ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_CA4DG.nii.gz \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA4DG/${i}_ERC_CA4DG.nii.gz

  fslmaths \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_CA4DG.nii.gz \
  -add ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_CA2CA3.nii.gz \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA4DG_CA2CA3/${i}_CA4DG_CA2CA3.nii.gz

  fslmaths \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_CA2CA3.nii.gz \
  -add ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_CA1.nii.gz \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA2CA3_CA1/${i}_CA2CA3_CA1.nii.gz

  fslmaths \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_CA1.nii.gz \
  -add ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_SUB.nii.gz \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA1_SUB/${i}_CA1_SUB.nii.gz

  fslmaths \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_SUB.nii.gz \
  -add ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_ERC.nii.gz \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_ERC/${i}_SUB_ERC.nii.gz

  # For MSP
  fslmaths \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_ERC.nii.gz \
  -add ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_CA1.nii.gz \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA1/${i}_ERC_CA1.nii.gz

  # For DG
  fslmaths \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_SUB.nii.gz \
  -add ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/rois/${i}_CA4DG.nii.gz \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_CA4DG/${i}_SUB_CA4DG.nii.gz
done

# 3) Create mesh objects based on the ROI pairs
for i in R L; do
  for j in ERC_CA4DG CA4DG_CA2CA3 CA2CA3_CA1 CA1_SUB SUB_ERC ERC_CA1 SUB_CA4DG; do
    mrconvert -datatype uint32 \
    ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_${j}/${i}_${j}.nii.gz \
    ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_${j}/${i}_${j}.mif -force

    label2mesh \
    ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_${j}/${i}_${j}.nii.gz \
    ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_${j}/${i}_${j}_mesh.obj -force
  done
done

# We may need to add white matter to some of these mesh images
