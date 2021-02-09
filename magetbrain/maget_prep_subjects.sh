#!/bin/bash

if [[ ! $(module is-loaded cobralab/2019b) ]]
then
	module load cobralab/2019b
	source /project/m/mmack/software/MAGeTbrain/bin/activate
fi

bids_dir='/scratch/m/mmack/gumusmel/hippcircuit'
maget_dir='/scratch/m/mmack/mmack/projects/hcp_maget'

sbjs=$1

for s in $sbjs;
do
	t1nii=${bids_dir}/sub-${s}/anat/T1w_acpc_dc_restore_brain.nii.gz
	t1mnc=${maget_dir}/input/subjects/brains/sub-${s}_T1w.mnc
	nii2mnc $t1nii $t1mnc
	echo "-- converted and transferred $s"
done
	
