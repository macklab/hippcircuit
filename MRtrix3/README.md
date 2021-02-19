# Structural Hippocampal Connectome on Niagara #

### 1) Extract ROIs from Maget Labels ###
Structural connectome should be generated based on gray matter (GM) atlas. To only select the GM ROIs and leave out the white matter (WM) in hippocampus-WM atlas, run the extract_GM_ROIs.sh 

GM_labels_original.txt includes the original labels for the parcellated image. We reorder the labels so that left and right SM/SL/SR would be the last columns/rows of the connectivity matrix. In the final connectivity matrix, the labels corresponds to:

1 - Right CA1  
2 - Right subiculum  
3 - Right CA4/dentate gyrus  
4 - Right CA2/CA3  
5 - Left CA1  
6 - Left subiculum  
7 - Left CA4/dentate gyrus  
8 - Left CA2/CA3  
9 - Right stratum radiatum/stratum lacunosum/stratum moleculare  
10 - Left stratum radiatum/stratum lacunosum/stratum moleculare    


**Associated scripts**:
*  exract_rois.sh : script for extracting ROIs
*  exract_rois_config.sh : define database specific paths
*  GM_labels_original.txt : original labels for parcellated maget brains
*  GM_labels_ordered.txt : labels are ordered so that lfet and right stratum would be the last entry


**Necessary modules**:
  ```
  module load NiaEnv/2018a
  module load openblas/0.2.20
  module load fsl/.experimental-6.0.0
  ```
