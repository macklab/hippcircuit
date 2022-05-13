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

# Dilate roi pairs
for i in R L; do
  for j in ERC_CA4DG CA4DG_CA2CA3 CA2CA3_CA1 CA1_SUB SUB_ERC; do # ERC_CA1 SUB_CA4DG; do
    fslmaths ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_${j}/${i}_${j}.nii.gz \
    -kernel sphere 2.5 -dilM \
    -binv ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_${j}/${i}_${j}_dil_binv.nii.gz
  done
done

for i in R L; do
  fslmaths ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA1/${i}_ERC_CA1.nii.gz \
  -kernel sphere 5 -dilM \
  -binv ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA1/${i}_ERC_CA1_dil_binv.nii.gz
done

for i in R L; do
  fslmaths ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_CA4DG/${i}_SUB_CA4DG.nii.gz \
  -kernel sphere 5 -dilM \
  -binv ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_CA4DG/${i}_SUB_CA4DG_dil_binv.nii.gz
done

# 1) 0 and 0
for i in R L; do
  tckedit \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA4DG/tracks_${i}_ERC_CA4DG.tck \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA4DG/tracks_${i}_ERC_CA4DG_edit.tck \
  -exclude ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA4DG/${i}_ERC_CA4DG_dil_binv.nii.gz \
  -tck_weights_out \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA4DG/${i}_ERC_CA4DG_weights.txt -force
done

# 2
for i in R L; do
  tckedit \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA4DG_CA2CA3/tracks_${i}_CA4DG_CA2CA3.tck \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA4DG_CA2CA3/tracks_${i}_CA4DG_CA2CA3_edit.tck \
  -exclude ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA4DG_CA2CA3/${i}_CA4DG_CA2CA3_dil_binv.nii.gz \
  -minlength 6 \
  -tck_weights_out \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA4DG_CA2CA3/${i}_CA4DG_CA2CA3_weights.txt -force
done

# 3
for i in R L; do
  tckedit \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA2CA3_CA1/tracks_${i}_CA2CA3_CA1.tck \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA2CA3_CA1/tracks_${i}_CA2CA3_CA1_edit.tck \
  -exclude ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA2CA3_CA1/${i}_CA2CA3_CA1_dil_binv.nii.gz \
  -tck_weights_out \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA2CA3_CA1/${i}_CA2CA3_CA1_weights.txt -force
done

# 4
for i in R L; do
  tckedit \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA1_SUB/tracks_${i}_CA1_SUB.tck \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA1_SUB/tracks_${i}_CA1_SUB_edit.tck \
  -exclude ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA1_SUB/${i}_CA1_SUB_dil_binv.nii.gz \
  -minlength 7 \
  -maxlength 40 \
  -tck_weights_out \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_CA1_SUB/${i}_CA1_SUB_weights.txt -force
done

# 5
for i in R L; do
  tckedit \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_ERC/tracks_${i}_SUB_ERC.tck \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_ERC/tracks_${i}_SUB_ERC_edit.tck \
  -exclude ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_ERC/${i}_SUB_ERC_dil_binv.nii.gz \
  -minlength 10 \
  -tck_weights_out \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_ERC/${i}_SUB_ERC_weights.txt -force
done

# 6
for i in R L; do
  tckedit \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA1/tracks_${i}_ERC_CA1.tck \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA1/tracks_${i}_ERC_CA1_edit.tck \
  -exclude ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA1/${i}_ERC_CA1_dil_binv.nii.gz \
  -maxlength 40 \
  -tck_weights_out \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_ERC_CA1/${i}_ERC_CA1_weights.txt -force
done

# 7
for i in R L; do
  tckedit \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_CA4DG/tracks_${i}_SUB_CA4DG.tck \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_CA4DG/tracks_${i}_SUB_CA4DG_edit.tck \
  -exclude ${i}_SUB_CA4DG/${i}_SUB_CA4DG_dil_binv.nii.gz \
  -minlength 10 \
  -tck_weights_out \
  ${bids_dir}/derivatives/fixel-based/subfield_MTL_paths/${i}_SUB_CA4DG/${i}_SUB_CA4DG_weights.txt -force
done
