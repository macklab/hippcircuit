#!/bin/bash
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --time=30:00
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

# Define subjects
sbjs=$(sed -n 1,85p ${bids_dir}/subjects.txt)

mkdir ${bids_dir}/derivatives/fixel-based/validation
rm -f ${bids_dir}/derivatives/fixel-based/validation/nodes_pearson_corr.csv
# # 1) Pearson Correlation for Labels
# for i in $sbjs; do
#   #ImageMath 3 - PearsonCorrelation majorityvote_copy.nii.gz nodes_in_template_space.nii.gz
#   num=$(ImageMath 3 - PearsonCorrelation \
#   ${bids_dir}/derivatives/fixel-based/template/node_template.nii.gz \
#   ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/MTL_hipp_subfields_in_template_space.nii.gz | awk '{print $1}')
#   printf '%s\n' ${i} ${num} | paste -sd ',' >> "${bids_dir}/derivatives/fixel-based/validation/nodes_pearson_corr.csv"
# done

# 1) Pearson Correlation for T1s
rm -f ${bids_dir}/derivatives/fixel-based/validation/T1s_pearson_corr.csv
for i in $sbjs; do
  #ImageMath 3 - PearsonCorrelation majorityvote_copy.nii.gz nodes_in_template_space.nii.gz
  num=$(ImageMath 3 - PearsonCorrelation \
  ${bids_dir}/derivatives/fixel-based/template/T1_template.nii.gz \
  ${bids_dir}/sub-${i}/anat/T1w_acpc_dc_restore_brain.nii.gz | awk '{print $1}')
  printf '%s\n' ${i} ${num} | paste -sd ',' >> "${bids_dir}/derivatives/fixel-based/validation/T1s_pearson_corr.csv"
done

# 2) Dice
mkdir ${bids_dir}/derivatives/fixel-based/validation/dice
for i in ${sbjs}; do
  ImageMath 3 ${bids_dir}/derivatives/fixel-based/validation/dice/sub-${i} \
  DiceAndMinDistSum ${bids_dir}/derivatives/fixel-based/template/node_template.nii.gz \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/MTL_hipp_subfields_in_template_space.nii.gz
  rm -f ${bids_dir}/derivatives/fixel-based/validation/dice/*nii.gz
done

# Combine avg dice into csv
rm -f ${bids_dir}/derivatives/fixel-based/validation/nodes_dice.csv
for i in ${sbjs}; do
  num=$(awk '{print $3}' ${bids_dir}/derivatives/fixel-based/validation/dice/sub-${i})
  printf '%s\n' ${i} ${num} | paste -sd ',' >> "${bids_dir}/derivatives/fixel-based/validation/nodes_dice.csv"
done

# 3) Volumes
mkdir ${bids_dir}/derivatives/fixel-based/validation/volume
rm -f ${bids_dir}/derivatives/fixel-based/validation/ICV.csv
for i in ${sbjs}; do
  fslmaths ${bids_dir}/sub-${i}/anat/aparc+aseg.nii.gz \
  -bin ${bids_dir}/derivatives/fixel-based/validation/volume/temp_bin.nii.gz
  num=$(fslstats \
  ${bids_dir}/derivatives/fixel-based/validation/volume/temp_bin.nii.gz \
  -V | awk '{print $1}')
  printf '%s\n' ${i} ${num} | paste -sd ',' >> "${bids_dir}/derivatives/fixel-based/validation/ICV.csv"
done

rm -rf ${bids_dir}/derivatives/fixel-based/validation/volume/*
# Using hipp_nodes.nii.gz instead of T1w produces the same result
for i in ${sbjs}; do
  num=$(fslstats -K ${bids_dir}/derivatives/itk-snap/sub-${i}/MTL_hipp_subfields.nii.gz \
  ${bids_dir}/sub-${i}/anat/T1w_acpc_dc_restore_brain.nii.gz \
  -V)
  printf '%s\n' $num | awk 'NR % 2' >> "${bids_dir}/derivatives/fixel-based/validation/volume/sub-${i}_node_volume.csv"
done
