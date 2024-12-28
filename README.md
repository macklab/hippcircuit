# HippCircuit
HippCircuit is a resource for _in vivo_ quantification of human white hippocampal white matter connections based on diffusion weighted imaging. The processing pipeline includes 2 arms: a) quantification of white connections at the individual level, b) template creation based on the entire sample. 

This processing pipeline was developed based on the Human Connectome Project Young Adult Sample (N=831). Each participant's white matter connectivity matrices are also available to download from this resource to answer various multimodal questions, leveraging the Human Connectome Project data. 

![Processing_Pipeline](https://github.com/user-attachments/assets/779ff9c3-2fe0-4eea-9162-ec192cd7f8d2)

## Contents
* Data organization
* Project pipelines
* General tips for using High Performance Computing clusters (This pipeline is based on [Compute Canada's](https://www.alliancecan.ca/en) resources at [SciNet](https://scinethpc.ca/), but can be adapted for other supercomputers)

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

## Citation
If you are any parts of this resource, please make sure to cite:


> Gumus, M; Bourganos, A; Mack, M.L. (Manuscript in preparation). _In vivo_ Quantification of White Matter Pathways in the Human Hippocampus. 



***



