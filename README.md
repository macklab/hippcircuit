# hippcircuit
Welcome to the hippcircuit wiki!


* Data organization
* Project pipelines
* General tips for using Niagara

Software on Niagara
* fmriprep
* MRtrix3
* MAGeTbrain
* ASHS

## Setting Up Software

Python.2.7

### BIDS
more information and details can be found at https://github.com/UNFmontreal/Dcm2Bids 

install & create basic bid files and directories
    
    pip install dcm2bids
    dcm2bids_scaffold

### MRtrix3

    module load NiaEnv/2018a
    module load intel/2018.2
    module load ants/2.3.1
    module load openblas/0.2.20
    module load fsl/.experimental-6.0.0
    module load fftw/3.3.7
    module load eigen/3.3.4
    module load mrtrix/3.0.0

### Freesurfer 
(7.1. is not available in NiaEnv/2018a)

    module load freesurfer/6.0.0

***
