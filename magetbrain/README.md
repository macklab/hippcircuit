# MAGeTbrain on Niagara
The CobraLab has graciously given us access to their software stack on Niagara. If your Compute Canada account is associated with the mmack group, you will have access. 
## Update your .bashrc
Add the following lines to your ~/.bashrc:

    export QUARANTINE_PATH=/project/m/mchakrav/quarantine
    module use ${QUARANTINE_PATH}/modules
Every time you log in, these commands will be automatically run and provide access to the CobraLab resources.

## Activating MAGeTbrain
Everytime you use MAGeTbrain, the following two commands must be run:

    > module load cobralab/2019b
    > source /project/m/mmack/mmack/project/software/MAGeTbrain/bin/activate
    
These commands can be entered in the command line or they can included at the beginning of a script. After 

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTMxOTI5MTIxNV19
-->