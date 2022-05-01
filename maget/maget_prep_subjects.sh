#!/bin/bash

#######################
#### Configuration ####
#######################
# Please change these paths for your directory of interest
bids_dir='/project/m/mmack/projects/hippcircuit'
maget_dir='/scratch/m/mmack/mmack/projects/hcp_maget'
#######################

# Check if module uploaded
if [[ ! $(module is-loaded cobralab/2019b) ]]
then
	module load cobralab/2019b
	source /project/m/mmack/software/MAGeTbrain/bin/activate
fi

sbjs=$1
# sbjs=$(sed -n 21p ${bids_dir}/subjects_rest.txt)

for s in $sbjs;
do
	t1nii=${bids_dir}/sub-${s}/anat/T1w_acpc_dc_restore_brain.nii.gz
	t1mnc=${maget_dir}/input/subjects/brains/sub-${s}_T1w.mnc
	nii2mnc $t1nii $t1mnc
	echo "-- converted and transferred $s"
done
