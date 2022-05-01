#!/bin/bash

#######################
#### Configuration ####
#######################
# Please change these paths for your directory of interest
maget_dir='/scratch/m/mmack/mmack/projects/hcp_maget'
fusion_dir='output/fusion/majority_vote'
#######################

# Load Modules
if [[ ! $(module is-loaded cobralab/2019b) ]]
then
	module load cobralab/2019b
	source /project/m/mmack/software/MAGeTbrain/bin/activate
fi

labels=$(ls ${maget_dir}/${fusion_dir}/sub-*_labels.mnc)

for l in $labels;
do
	fname=$(basename $l .mnc)
	fsize=$(wc -c $l | awk '{print $1}')
	if [[ $fsize -eq 0 ]]
	then
		echo $fname
	fi
done
