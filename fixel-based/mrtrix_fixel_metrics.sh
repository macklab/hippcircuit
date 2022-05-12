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
  sub-${i}.mif -force
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
