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
# sbjs=$(sed -n 1,85p ${bids_dir}/subjects.txt)

# Connectome Generation
# MTL + maget segmentation
for i in ${sbjs}; do
  tck2connectome  ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
  ${bids_dir}/derivatives/itk-snap/sub-${i}/MTL_hipp_subfields.nii.gz \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_MTL_hipp_connectome_stream_default.csv \
  -out_assignments ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_MTL_hipp_assignments_stream_default.csv \
  -force
done

# Metric specific connectomes
metrics="FA MD AD RD"
for i in ${sbjs}; do
  for t in ${metrics}; do
    tck2connectome ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
    ${bids_dir}/derivatives/itk-snap/sub-${i}/MTL_hipp_subfields.nii.gz \
    ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_MTL_hipp_connectome_${t}.csv \
    -scale_file ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_${t}.csv \
    -stat_edge mean -force
  done
done
