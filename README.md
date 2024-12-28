# HippCircuit
HippCircuit is a resource for _in vivo_ quantification of human white hippocampal white matter connections based on diffusion weighted imaging and various processing software. The processing pipeline includes 2 arms: a) quantification of white connections at the individual level, b) template creation based on the entire sample. 

This processing pipeline was developed on the [Human Connectome Project Young Adult](https://www.humanconnectome.org/study/hcp-young-adult) Sample (N=831). Each participant's white matter connectivity matrices are also available to download from this resource to answer various multimodal questions, leveraging the Human Connectome Project data. The pipeline can be applied to a sample of interest with certain modifications.

![Processing_Pipeline](https://github.com/user-attachments/assets/779ff9c3-2fe0-4eea-9162-ec192cd7f8d2)

## Contents
* Data organization
* Project pipelines
* General tips for using High Performance Computing clusters

Software on Niagara
* BIDS
* MRtrix3
* FSL
* Freesurfer
* MAGeTbrain
* ASHS
* ITK-SNAP

## Setting Up Environment
This pipeline was developed on [Compute Canada's](https://www.alliancecan.ca/en) resources at [SciNet](https://scinethpc.ca/), but can be adapted for other supercomputers. Most software is available as modules at SciNet. The necessary software can be  `Python.2.7` is compatible with the following software versions.

## BIDS
Data should be in [BIDS format](https://bids.neuroimaging.io/). Dicoms can be converted to BIDS format using [Dcm2Bids](https://github.com/UNFmontreal/Dcm2Bids).

To install & create basic BIDS files and directories:
    
    pip install dcm2bids
    dcm2bids_scaffold

## MRtrix3
[MRtrix](https://www.mrtrix.org/) provides advanced tools for processing of diffusion weighted imaging. The dependencies can be loaded as the following:

    module load NiaEnv/2018a
    module load intel/2018.2
    module load ants/2.3.1
    module load openblas/0.2.20
    module load fsl/.experimental-6.0.0
    module load fftw/3.3.7
    module load eigen/3.3.4
    module load mrtrix/3.0.0

If using supercomputers other than SciNet, please follow the instructions on the MRtrix website for software installation.

## FSL 
[FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs/#/) is loaded as part of the dependencies above. However, it can also be loaded separetely:

    module load fsl/.experimental-6.0.0
    
## Freesurfer 
The ideal version of [Freesurfer](https://surfer.nmr.mgh.harvard.edu/) 7.1. was not available in NiaEnv/2018a. Thus, we are using 6.0.0:

    module load freesurfer/6.0.0

## MAGeT brain
Hippocampus was segmentated into its subfields using [MAGeTbrain](https://github.com/CoBrALab/MAGeTbrain). The CobraLab has graciously given us access to their software stack on Niagara. If your Compute Canada account is associated with the mmack group, you will have access. You can activate MAGeTbrain as the following:

    module load cobralab/2019b
    source /project/m/mmack/software/MAGeTbrain/bin/activate
## ASHS
Entorhinal cortex was segmented using [ASHS](https://sites.google.com/view/ashs-dox/). Although not leveraged in this dataset, ASHS also provides hippocampal subfield segmentation. The segmentation software is user's choice. As long as there is no overlap between the segmentatations within an image, it will be compatible with the pipeline.

## ITK-SNAP
If you choose to use the cloud services of ASHS, you will also need to download [ITK-SNAP](http://www.itksnap.org/pmwiki/pmwiki.php). Users can submit their structural images to Distributed Segmentation System (DSS) for automatic segmentation.


## Citation
If you are any parts of this resource, please make sure to cite:

> Gumus, M; Bourganos, A; Mack, M.L. (Manuscript in preparation). _In vivo_ Quantification of White Matter Pathways in the Human Hippocampus. 


***



