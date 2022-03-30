#!/bin/bash
#SBATCH -N 2
#SBATCH -c 40
#SBATCH --time=24:00:00
#SBATCH -o %x-%j.out

module load NiaEnv/2018a
module load intel/2018.2
module load ants/2.3.1
module load openblas/0.2.20
module load fsl/.experimental-6.0.0
module load fftw/3.3.7
module load eigen/3.3.4
module load mrtrix/3.0.0
module load freesurfer/6.0.0

# Define path
bids_dir="/project/m/mmack/projects/hippcircuit"
outpath="${bids_dir}/derivatives/fixel-based/standard_space"

# 1) 0 and 0
for i in R L; do
  tckedit \
  ${i}_ERC_CA4DG/tracks_${i}_ERC_CA4DG.tck \
  ${i}_ERC_CA4DG/tracks_${i}_ERC_CA4DG_edit.tck \
  -include ${i}_ERC_CA4DG/${i}_ERC_CA4DG.nii.gz \
  -minlength 10 \
  -maxlength 40 \
  -tck_weights_out \
  ${i}_ERC_CA4DG/${i}_ERC_CA4DG_weights.txt -force

  tcktransform ${i}_ERC_CA4DG/tracks_${i}_ERC_CA4DG_edit.tck \
  ${outpath}/inv_mrtrix_warp_corrected.mif \
  ${i}_ERC_CA4DG/tracks_${i}_ERC_CA4DG_edit_MNI.tck
done

# 2 GOOD
for i in R L; do
  tckedit \
  ${i}_CA4DG_CA2CA3/tracks_${i}_CA4DG_CA2CA3.tck \
  ${i}_CA4DG_CA2CA3/tracks_${i}_CA4DG_CA2CA3_edit.tck \
  -include ${i}_CA4DG_CA2CA3/${i}_CA4DG_CA2CA3.nii.gz \
  -minlength 10 \
  -maxlength 50 \
  -tck_weights_out \
  ${i}_CA4DG_CA2CA3/${i}_CA4DG_CA2CA3_weights.txt -force

  tcktransform ${i}_CA4DG_CA2CA3/tracks_${i}_CA4DG_CA2CA3_edit.tck \
  ${outpath}/inv_mrtrix_warp_corrected.mif \
  ${i}_CA4DG_CA2CA3/tracks_${i}_CA4DG_CA2CA3_edit_MNI.tck
done

# 3 GOOD
for i in R L; do
  tckedit \
  ${i}_CA2CA3_CA1/tracks_${i}_CA2CA3_CA1.tck \
  ${i}_CA2CA3_CA1/tracks_${i}_CA2CA3_CA1_edit.tck \
  -include ${i}_CA2CA3_CA1/${i}_CA2CA3_CA1.nii.gz \
  -minlength 10 \
  -maxlength 40 \
  -tck_weights_out \
  ${i}_CA2CA3_CA1/${i}_CA2CA3_CA1_weights.txt -force

  tcktransform ${i}_CA2CA3_CA1/tracks_${i}_CA2CA3_CA1_edit.tck \
  ${outpath}/inv_mrtrix_warp_corrected.mif \
  ${i}_CA2CA3_CA1/tracks_${i}_CA2CA3_CA1_edit_MNI.tck
done

# 4 GOOD
for i in R L; do
  tckedit \
  ${i}_CA1_SUB/tracks_${i}_CA1_SUB.tck \
  ${i}_CA1_SUB/tracks_${i}_CA1_SUB_edit.tck \
  -include ${i}_CA1_SUB/${i}_CA1_SUB.nii.gz \
  -minlength 10 \
  -maxlength 30 \
  -tck_weights_out \
  ${i}_CA1_SUB/${i}_CA1_SUB_weights.txt -force

  tcktransform ${i}_CA1_SUB/tracks_${i}_CA1_SUB_edit.tck \
  ${outpath}/inv_mrtrix_warp_corrected.mif \
  ${i}_CA1_SUB/tracks_${i}_CA1_SUB_edit_MNI.tck
done

# 5 GOOD
for i in R L; do
  tckedit \
  ${i}_SUB_ERC/tracks_${i}_SUB_ERC.tck \
  ${i}_SUB_ERC/tracks_${i}_SUB_ERC_edit.tck \
  -include ${i}_SUB_ERC/${i}_SUB_ERC.nii.gz \
  -minlength 10 \
  -maxlength 50 \
  -tck_weights_out \
  ${i}_SUB_ERC/${i}_SUB_ERC_weights.txt -force

  tcktransform ${i}_SUB_ERC/tracks_${i}_SUB_ERC_edit.tck \
  ${outpath}/inv_mrtrix_warp_corrected.mif \
  ${i}_SUB_ERC/tracks_${i}_SUB_ERC_edit_MNI.tck
done

# 6 GOOD
for i in R L; do
  tckedit \
  ${i}_ERC_CA1/tracks_${i}_ERC_CA1.tck \
  ${i}_ERC_CA1/tracks_${i}_ERC_CA1_edit.tck \
  -include ${i}_ERC_CA1/${i}_ERC_CA1.nii.gz \
  -minlength 10 \
  -maxlength 40 \
  -tck_weights_out \
  ${i}_ERC_CA1/${i}_ERC_CA1_weights.txt -force

  tcktransform ${i}_ERC_CA1/tracks_${i}_ERC_CA1_edit.tck \
  ${outpath}/inv_mrtrix_warp_corrected.mif \
  ${i}_ERC_CA1/tracks_${i}_ERC_CA1_edit_MNI.tck
done

# 7 0 and 4
for i in R L; do
  tckedit \
  ${i}_SUB_CA4DG/tracks_${i}_SUB_CA4DG.tck \
  ${i}_SUB_CA4DG/tracks_${i}_SUB_CA4DG_edit.tck \
  -include ${i}_SUB_CA4DG/${i}_SUB_CA4DG.nii.gz \
  -tck_weights_out \
  ${i}_SUB_CA4DG/${i}_SUB_CA4DG_weights.txt -force

  tcktransform ${i}_SUB_CA4DG/tracks_${i}_SUB_CA4DG_edit.tck \
  ${outpath}/inv_mrtrix_warp_corrected.mif \
  ${i}_SUB_CA4DG/tracks_${i}_SUB_CA4DG_edit_MNI.tck
done




# END
