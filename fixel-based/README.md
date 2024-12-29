# Hipppocampal circuit - template creation
The second arm of the processing pipeline is specific to creating a template based on the entire sample. The steps involved in this arm of the pipeline is the same as creating participant specific white matter connections. However, the main difference is that all necessary images are warped into the template space. 

* Intensity normalization of the individual FOD images. 
* Create symbolic links for FOD images to an input folder.
* Create study-specific unbiased FOD template based on ~30 participants.
* Register the remaining subjects to the FOD template.
* Compute a template mask.
* Based on this template, create a fixel mask.
* Warp all FOD images into template space.
* Use created warps to transform participant specific T1 weighted images and segmentations into template space. 
* Based on these template images, the whole brain tratography can be generated and hippocampal white matter connections can be isolated.
