#!/bin/bash
#SBATCH -N 1
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

# Define subjects
sbjs=$(sed -n 1,85p ${bids_dir}/subjects.txt)

# Warp nodes to T1 template
for i in $sbjs; do
  mrtransform ${bids_dir}/derivatives/itk-snap/sub-${i}/MTL_hipp_subfields.nii.gz \
  -warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  -interp nearest -datatype Float32LE \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/MTL_hipp_subfields_in_template_space.mif \
  -template ${bids_dir}/derivatives/itk-snap/sub-${i}/MTL_hipp_subfields.nii.gz -force
done
#${bids_dir}/derivatives/itk-snap/sub-${i}/MTL_hipp_subfields.nii.gz

# Convert mifs to nifti for ants
for i in $sbjs; do
  mrconvert ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/MTL_hipp_subfields_in_template_space.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/MTL_hipp_subfields_in_template_space.nii.gz -force
done

# Node template
ImageMath 3 ${bids_dir}/derivatives/fixel-based/template/node_template.nii.gz \
  MajorityVoting ${bids_dir}/derivatives/fixel-based/fixels/sub-*/MTL_hipp_subfields_in_template_space.nii.gz
