#!/bin/bash

#######################
#### Configuration ####
#######################
# Where logs stored - Change this for your directory
#SBATCH -o /project/m/mmack/projects/hippcircuit/code/logs/%x-%j.out

# Please also change these paths for your directory
bids_dir="/project/m/mmack/projects/hippcircuit"
maget_dir="${bids_dir}/derivatives/maget/output/fusion/majority_vote"
work_dir="${bids_dir}/derivatives/mrtrix"
#######################

# Input subjects
sbjs=$1
cd ${bids_dir}

# Upload modules
if [[ ! $(module is-loaded cobralab/2019b) ]]
then
        module load cobralab/2019b
        source /project/m/mmack/software/MAGeTbrain/bin/activate
fi

# Check if maget path exists
if [ -d ${maget_dir} ]
then
    echo "Directory ${maget_dir} exists."
else
    echo "Error: Directory ${maget_dir} does not exists."
fi

# Convert mnc to nifti
for i in ${sbjs}; do
  mkdir ${work_dir}/sub-${i}
  mnc2nii -nii ${maget_dir}/sub-${i}_T1w_labels.mnc ${maget_dir}/sub-${i}_T1w_labels.nii.gz
  cp ${maget_dir}/sub-${i}_T1w_labels.nii.gz ${work_dir}/sub-${i} # for backup
done
