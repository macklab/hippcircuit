#!/bin/bash

if [[ ! $(module is-loaded cobralab/2019b) ]]
then
	module load cobralab/2019b
	source /project/m/mmack/software/MAGeTbrain/bin/activate
fi

proj_dir='/project/m/mmack/projects/hippcircuit'
maget_dir='/scratch/m/mmack/mmack/projects/hcp_maget'
fusion_dir='output/fusion/majority_vote'

labels=$(ls ${maget_dir}/${fusion_dir}/sub-*_labels.mnc)

for l in $labels;
do
	fname=$(basename $l .mnc)
	label_mnc=${proj_dir}/derivatives/maget/${fusion_dir}/${fname}.mnc
	label_nii=${proj_dir}/derivatives/maget/${fusion_dir}/${fname}.nii
	if [[ ! -e $label_mnc ]]
	then
		cp $l $label_mnc
		mnc2nii $label_mnc $label_nii
		gzip $label_nii
		echo "-- label converted and transferred: $fname"
	fi
done
	
