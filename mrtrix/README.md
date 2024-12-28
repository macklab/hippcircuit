# Participant-specific white matter connections
In vivo reconstruction of hippocampal pathways in humans was possible with various tools and algorithms provided by [MRtrix3](https://www.mrtrix.org/)

## Implementing the pipeline in your own data
If you choose to implement this processing pipeline in your data, the following steps should be followed to create hippomcapus specific connectivity matrices. 

**1) Structural image processing** 
* 5 tissue type image is created based on preprocessed T1 weighted image.
   
**2) Diffusion weighted image processing**
* Estimate a response function. 
* Estimate fibre orientation distribution with constrained spherical deconvolution.
* Please note that the specific algorithms used in this pipeline were chosen because they performed better than all other vailable ones. These algorithms should be chosen based on the specifics of your diffusion data, for instance, single versus multi-shell. You should always inspect your results.

**3) Whole brain tractograhpy reconstruction**
* Subject specific whole brain tractrography images were created while seeding from gray matter-white matter interface and leveraging Anatomically-Constrained Tractography (ACT) framework. Please note that other seeding methods did not yield the reported results regarding the hippocampus. This could change depending on the brain structure of your interest as well as the specifics of your diffusion data.

**4) Subject specific connectomes**
* Subject specific whole brain tractography images can be masked by the hippocampal subfield and entorhinal cortex segmentation images. This creates a connectivity matrix for each subject. Each entry within a connectivity matrix represents the streamline density between the corresponding regions.

## Leveraging the processed hippocampal data 
If you are working on the Human Connectome Project Young Adult data, the connectivity matrices for all 831 participants can be downloaded from the `data/connectomes/` folder.


