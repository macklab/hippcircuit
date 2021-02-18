#!/bin/bash
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --time=24:00:00
#SBATCH -o %x-%j.out

module load NiaEnv/2018a
module load openblas/0.2.20
module load fsl/.experimental-6.0.0

# Define paths for directories
bids_dir="/scratch/m/mmack/gumusmel/hippcircuit"
maget_dir="/project/m/mmack/projects/hippcircuit/derivatives/maget/output/fusion/majority_vote"
work_dir="${bids_dir}/derivatives/mrtrix"
cd ${bids_dir}

# Check if maget path exists
if [ -d ${maget_dir} ]
then
    echo "Directory ${maget_dir} exists."
else
    echo "Error: Directory ${maget_dir} does not exists."
fi

# Define subject number
sbjs=$(sed -n 3,5p ${bids_dir}/subjects.txt)

# Source the script to extract ROIs
source ${work_dir}/configs/extract_rois.sh
