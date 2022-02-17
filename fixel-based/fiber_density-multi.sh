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

bids_dir="/project/m/mmack/projects/hippcircuit"
#cd ${bids_dir}

#cd ${bids_dir}/derivatives/fixel-based
mkdir -p ${bids_dir}/derivatives/fixel-based/fod_input
mkdir ${bids_dir}/derivatives/fixel-based/mask_input
mkdir ${bids_dir}/derivatives/fixel-based/fixels

# Define all subjects of interest
sbjs=$(sed -n 1,85p ${bids_dir}/subjects.txt)

# Subjects to be included in the template
tmp_sbjs=$(sed -n 1,30p ${bids_dir}/template_sbjs.txt)

# Create subject specific folders for FBA
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

# 3) Symbolic link all FOD images (and masks) into a single input folder
for i in ${tmp_sbjs}; do
  ln -sr ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/WM_FODs_norm.mif \
  ${bids_dir}/derivatives/fixel-based/fod_input/${i}.mif
done

for i in ${tmp_sbjs}; do
  ln -sr ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/mask.mif \
  ${bids_dir}/derivatives/fixel-based/mask_input/${i}.mif
done

# 4) Generate a study-specific unbiased FOD template
# based on selected subjects
mkdir ${bids_dir}/derivatives/fixel-based/template
population_template ${bids_dir}/derivatives/fixel-based/fod_input \
  -mask_dir ${bids_dir}/derivatives/fixel-based/mask_input/ \
  ${bids_dir}/derivatives/fixel-based/template/wmfod_template.mif \
  -voxel_size 1.25 -warp_dir ${bids_dir}/derivatives/fixel-based/warps

# 5) Register all subject FOD images to the FOD template
for i in $sbjs; do
  mrregister ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/WM_FODs_norm.mif \
  -mask1 ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/mask.mif \
  ${bids_dir}/derivatives/fixel-based/template/wmfod_template.mif \
  -nl_warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_template2subject_warp.mif
done

# 6) Compute the template mask (intersection of all subject masks in template space)
# Different subjects have different brain coverage. To ensure subsequent
#  analysis is performed in voxels that contain data from all subjects, we
# warp all subject masks into template space and compute the template mask as
# the intersection of all subject masks in template space.
# To warp all masks into template space:
for i in $sbjs; do
  mrtransform ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/mask.mif \
  -warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  -interp nearest -datatype bit ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/mask_in_template_space.mif
done

# Compute the template mask as the intersection of all warped masks
mrmath ${bids_dir}/derivatives/fixel-based/fixels/sub-*/mask_in_template_space.mif \
  min ${bids_dir}/derivatives/fixel-based/template/template_mask.mif -datatype bit

# 7) Compute a white matter template analysis fixel mask
# To segment fixels from the FOD template
fod2fixel -mask ${bids_dir}/derivatives/fixel-based/template/template_mask.mif \
  -fmls_peak_value 0.06 ${bids_dir}/derivatives/fixel-based/template/wmfod_template.mif \
  ${bids_dir}/derivatives/fixel-based/template/fixel_mask

# 8) Warp FOD images to template space
# Warp FOD images into template space without FOD reorientation,
# as reorientation will be performed in a separate subsequent step after
# fixel segmentation
for i in ${sbjs}; do
  mrtransform ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/WM_FODs_norm.mif \
  -warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  -reorient_fod no ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fod_in_template_space_NOT_REORIENTED.mif
done

# 9) Segment FOD images to estimate fixels and their apparent fibre density (FD)
# Segment each FOD lobe to identify the number and orientation of fixels
# in each voxel. The output also contains the apparent fibre density (AFD) value
# per fixel (estimated as the FOD lobe integral)
for i in ${sbjs}; do
  fod2fixel -mask ${bids_dir}/derivatives/fixel-based/template/template_mask.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fod_in_template_space_NOT_REORIENTED.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fixel_in_template_space_NOT_REORIENTED -afd fd.mif
done

# 10) Reorient fixels
# Reorient the fixels of all subjects in template space based on the local
# transformation at each voxel in the warps used previously
for i in ${sbjs}; do
  fixelreorient ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fixel_in_template_space_NOT_REORIENTED \
  ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fixel_in_template_space
done

# Now, the fixel_in_template_space_NOT_REORIENTED folders can be safely removed.
for i in ${sbjs}; do
  rm -rf ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fixel_in_template_space_NOT_REORIENTED
done

# 11) Assign subject fixel to template fixels
for i in ${sbjs}; do
  fixelcorrespondence ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/fixel_in_template_space/fd.mif \
  ${bids_dir}/derivatives/fixel-based/template/fixel_mask \
  ${bids_dir}/derivatives/fixel-based/template/fd \
  sub-${i}.mif
done

# 12) Compute the fibre cross-section (FC) metric
for i in ${sbjs}; do
  warp2metric ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  -fc ${bids_dir}/derivatives/fixel-based/template/fixel_mask \
  ${bids_dir}/derivatives/fixel-based/template/fc \
  sub-${i}.mif
done

# For group statistical analysis of FC, calculate the log(FC) to ensure data
# are centred around zero and normally distributed.
mkdir ${bids_dir}/derivatives/fixel-based/template/log_fc
cp ${bids_dir}/derivatives/fixel-based/template/fc/index.mif \
  ${bids_dir}/derivatives/fixel-based/template/fc/directions.mif \
  ${bids_dir}/derivatives/fixel-based/template/log_fc

for i in ${sbjs}; do
  mrcalc ${bids_dir}/derivatives/fixel-based/template/fc/sub-${i}.mif \
  -log ${bids_dir}/derivatives/fixel-based/template/log_fc/sub-${i}.mif
done

# The FC (and hence also the log(FC)) as calculated here, is a relative metric,
# expressing the local fixel-wise cross-sectional size relative to this study’s
# population template. While this makes it possible to interpret differences of
# FC within a single study (because only a single unique template is used in the
# study), the FC values should not be compared across different studies that each
# have their own population template. Reporting absolute quantities of FC, or
# absolute effect sizes of FC, also provides little information; as again, it is
# only meaningful with respect to the template.

# 13) Compute a combined measure of fibre density and cross-section (FDC)
mkdir ${bids_dir}/derivatives/fixel-based/template/fdc
cp ${bids_dir}/derivatives/fixel-based/template/fc/index.mif \
  ${bids_dir}/derivatives/fixel-based/template/fdc
cp ${bids_dir}/derivatives/fixel-based/template/fc/directions.mif \
${bids_dir}/derivatives/fixel-based/template/fdc

for i in ${sbjs}; do
  mrcalc ${bids_dir}/derivatives/fixel-based/template/fd/sub-${i}.mif \
  ${bids_dir}/derivatives/fixel-based/template/fc/sub-${i}.mif \
  -mult ${bids_dir}/derivatives/fixel-based/template/fdc/sub-${i}.mif
done

# END #
