# Entorhinal cortex segmentation 
Medial temporal regions were segmented using cloud based ASHS through ITK-SNAP. If you are using the Distributed Segmentation System (DSS), please note that you can only submit 10 subjects at a time. Segmented images were then transferred to SciNet compute clusters. Please store the segmented images in the following directory for to run the rest of the scripts:

```
$bids_dir/derivatives/itk-snap/sub-* 
```

You can extract the regions of your interest from the segmented images. In this project, we specifically isolated the entorhinal cortex to combine it with hippocampal subfields from MAGeTbrain.
