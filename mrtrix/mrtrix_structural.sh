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
# If you'd like to define subjects here:
# sbjs=$(sed -n 1,2p ${seg_dir}/subjects_rest.txt)

# 1) Structural image processing
# Tissue segmented image
# Uses a single core
for i in ${sbjs}; do
  5ttgen fsl ${bids_dir}/sub-${i}/anat/T1w_acpc_dc_restore_brain.nii.gz\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif -premasked -force
done

# Convert multi-tissue image into 3D greyscale
# Visualize vis.mif for mislabels
for i in ${sbjs}; do
  5tt2vis ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/vis.mif -force
done

# Assign the right labels to connectome with respect to the parcellated image
for i in ${sbjs}; do
  labelconvert ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_T1w_GM_labels.nii.gz\
  ${bids_dir}/derivatives/mrtrix/configs/GM_labels_original.txt\
  ${bids_dir}/derivatives/mrtrix/configs/GM_labels_ordered.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/hipp_nodes.mif -force
done
