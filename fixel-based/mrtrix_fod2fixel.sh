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

# 6) Compute the template mask (intersection of all subject masks in template space)
# Different subjects have different brain coverage. To ensure subsequent
#  analysis is performed in voxels that contain data from all subjects, we
# warp all subject masks into template space and compute the template mask as
# the intersection of all subject masks in template space.
# To warp all masks into template space:
for i in $sbjs; do
  mrtransform ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/mask.mif \
  -warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  -interp nearest -datatype bit ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/mask_in_template_space.mif -force
done

# for i in $sbjs; do
#   mrtransform ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/mask.mif \
#   -warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
#   -interp nearest -datatype bit ${scratch_dir}/derivatives/fixel-based/fixels/sub-${i}/mask_in_template_space.mif -force
# done

# Compute the template mask as the intersection of all warped masks
mrmath ${bids_dir}/derivatives/fixel-based/fixels/sub-*/mask_in_template_space.mif \
  min ${bids_dir}/derivatives/fixel-based/template/template_mask.mif -datatype bit -force

# 7) Compute a white matter template analysis fixel mask
# To segment fixels from the FOD template
fod2fixel -mask ${bids_dir}/derivatives/fixel-based/template/template_mask.mif \
  -fmls_peak_value 0.06 ${bids_dir}/derivatives/fixel-based/template/wmfod_template.mif \
  ${bids_dir}/derivatives/fixel-based/template/fixel_mask -force

# 8) Warp FOD images to template space
# Warp FOD images into template space without FOD reorientation,
# as reorientation will be performed in a separate subsequent step after
# fixel segmentation
for i in ${sbjs}; do
  mrtransform ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/WM_FODs_norm.mif \
  -warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  -reorient_fod no ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fod_in_template_space_NOT_REORIENTED.mif \
  -force
done

# 9) Segment FOD images to estimate fixels and their apparent fibre density (FD)
# Segment each FOD lobe to identify the number and orientation of fixels
# in each voxel. The output also contains the apparent fibre density (AFD) value
# per fixel (estimated as the FOD lobe integral)
for i in ${sbjs}; do
  fod2fixel -mask ${bids_dir}/derivatives/fixel-based/template/template_mask.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fod_in_template_space_NOT_REORIENTED.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fixel_in_template_space_NOT_REORIENTED -afd fd.mif \
  -force
done

# 10) Reorient fixels
# Reorient the fixels of all subjects in template space based on the local
# transformation at each voxel in the warps used previously
for i in ${sbjs}; do
  fixelreorient ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fixel_in_template_space_NOT_REORIENTED \
  ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fixel_in_template_space \
  -force
done

# Now, the fixel_in_template_space_NOT_REORIENTED folders can be safely removed.
for i in ${sbjs}; do
  rm -rf ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fixel_in_template_space_NOT_REORIENTED
done