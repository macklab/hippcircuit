#!/bin/bash
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --time=1:00:00

#######################
#### Configuration ####
#######################
# Where logs stored - Change this for your directory
#SBATCH -o /project/m/mmack/projects/hippcircuit/code/logs/%x-%j.out

# Please also change these paths for your directory
bids_dir="/project/m/mmack/projects/hippcircuit"
#######################

# Upload modules
module load NiaEnv/2018a
module load intel/2018.2
module load ants/2.3.1
module load openblas/0.2.20
module load fsl/.experimental-6.0.0
module load fftw/3.3.7
module load eigen/3.3.4
module load mrtrix/3.0.0
module load freesurfer/6.0.0

# Check if bids dir exists
if [ -d ${bids_dir} ]
then
    echo "Directory ${bids_dir} exists."
else
    echo "Error: Directory ${bids_dir} does not exists."
fi
cd ${bids_dir}
# Set subjects
sbjs=$1

# 3) Tractography
# Mask for gray matter - white matter interface
for i in ${sbjs}; do
  5tt2gmwmi ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/gmwmi.mif -force
done

source /scinet/conda/etc/profile.d/scinet-conda.sh
scinet-conda create -n mrtrix3 -c mrtrix3 mrtrix3
scinet-conda activate mrtrix3

# Create whole-brain tractography
for i in ${sbjs}; do
  tckgen ${bids_dir}/derivatives/mrtrix/sub-${i}/WM_FODs.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/10M.tck\
  -act ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif\
  -backtrack -crop_at_gmwmi -seed_gmwmi ${bids_dir}/derivatives/mrtrix/sub-${i}/gmwmi.mif\
  -maxlength 250 -select 10M -cutoff 0.1 -angle 45 -force
done

# Apply spherical-deconvolution informed filtering of tractograms (SIFT) algorithm
for i in ${sbjs}; do
  tcksift ${bids_dir}/derivatives/mrtrix/sub-${i}/10M.tck\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/WM_FODs.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck\
  -act ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif -term_number 2M -force
done
