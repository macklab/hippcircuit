# MAGeTbrain on Niagara
The [CobraLab](https://www.cobralab.ca/) has graciously given us access to their software stack on Niagara. If your Compute Canada account is associated with the mmack group, you will have access. For more information, please visit [MAGeTbrain](https://github.com/CobraLab/MAGeTbrain) page.

## Update your .bashrc
Add the following lines to your ~/.bashrc:

    export QUARANTINE_PATH=/project/m/mchakrav/quarantine
    module use ${QUARANTINE_PATH}/modules
Every time you log in, these commands will be automatically run and provide access to the CobraLab resources.

## Activating MAGeTbrain
Everytime you use MAGeTbrain, the following two commands must be run:

    module load cobralab/2019b
    source /project/m/mmack/software/MAGeTbrain/bin/activate
    
These commands can be entered in the command line or they can included at the beginning of a script. After running them, you will have access to the main MAGeTbrain commands (e.g., mb). 

## Data structure in MAGeTbrain
The directory for MAGeTbrain should follow this structure:
    
    input/
    input/subjects
    input/subjects/brains
    input/templates
    input/templates/brains
    input/atlases
    input/atlases/labels
    input/atlases/brains
    
`input/subjects` should include the subjects whose images you would like to segment. input/templates is where you need to place ~21 template subjects and input/atlases is for storing the atlases to be used in the segmentation. For more information, please refer to [MAGeTbrain](https://github.com/CobraLab/MAGeTbrain) page.

## Voting
Segmenting T1 weighted images in large samples could take a long time, especially when the images are high resolution. The voting/fusion stage should be run with the following parameters: `--stage-votoing-procs 1`. This will submit 1 participant per job and it typically finishes within the default 12h wall time. If this does not work, you may need to increase the wall time.

## Processing details
The scripts in this folder will take you through the following steps:

1) Converting nifti files to minc.
2) Segmenting these minc files using MAGeTbrain.
3) Checking the output (i.e., segmentations).
4) Converting these minc files nifti.
5) Extracting the regions of interest from the segmented images.


<!--stackedit_data:
eyJoaXN0b3J5IjpbODY3Mzk2NTRdfQ==
-->
