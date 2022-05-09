#!/bin/bash
#SBATCH -N 10
#SBATCH -c 40
#SBATCH --time=24:00:00

#######################
#### Configuration ####
#######################
# Where logs stored - Change this for your directory
#SBATCH -o /project/m/mmack/projects/hippcircuit/code/logs/%x-%j.out

# Please also change these paths for your directory
bids_dir="/project/m/mmack/projects/hippcircuit"

# Subjects to be included in the template
tmp_sbjs=$(sed -n 1,30p ${bids_dir}/derivatives/subjects/template_subjects.txt)
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

# Create fixel folders
mkdir -p ${bids_dir}/derivatives/fixel-based/fod_input
mkdir ${bids_dir}/derivatives/fixel-based/mask_input

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
