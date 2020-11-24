# Structural Hippocampal Connectome on Niagara #

Structural connectome should be generated based on gray matter (GM) atlas. To only select the GM ROIs and leave out the white matter (WM) in hippocampus-WM atlas, run the extract_GM_ROIs.sh 

GM_labels_original.txt includes the original labels for the parcellated image. We reorder the labels so that left and right SM/SL/SR would be the last columns/rows of the connectivity matrix. In the final connectivity matrix, the labels corresponds to:

1 - 
