#!/bin/bash

# 1) Structural image processing
# Tissue segmented image
# Uses a single core
for i in ${sbjs}; do
  5ttgen fsl ${bids_dir}/sub-${i}/anat/T1w_acpc_dc_restore_brain.nii.gz\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif -premasked -force
done

# Convert multi-tissue image into 3D greyscale
# Visualize vis.mif for mislabels
for i in ${sbjs}; do
  5tt2vis ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/vis.mif -force
done

# Assign the right labels to connectome with respect to the parcellated image
for i in ${sbjs}; do
  labelconvert ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_T1w_GM_labels.nii.gz\
  ${bids_dir}/derivatives/mrtrix/configs/GM_labels_original.txt\
  ${bids_dir}/derivatives/mrtrix/configs/GM_labels_ordered.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/hipp_nodes.mif -force
done

# 2) DWI Processing
# Convert diffusion image into non-compressed format
for i in ${sbjs}; do
  mrconvert ${bids_dir}/sub-${i}/dwi/data.nii.gz\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/DWI.mif -fslgrad\
  ${bids_dir}/sub-${i}/dwi/bvecs ${bids_dir}/sub-${i}/dwi/bvals\
  -datatype float32 -strides 0,0,0,1 -force
done

# Generate b=0 image
for i in ${sbjs}; do
  dwiextract ${bids_dir}/derivatives/mrtrix/sub-${i}/DWI.mif - -bzero | mrmath - mean\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/meanb0.mif -axis 3 -force
done

# Estimate multi-shell, multi-tissue response function
for i in ${sbjs}; do
  dwi2response msmt_5tt ${bids_dir}/derivatives/mrtrix/sub-${i}/DWI.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_WM.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_GM.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_CSF.txt\
  -voxels ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_voxels.mif -force
done
# Check mrview meanb0.mif -overlay.load RF_voxels.mif -overlay.opacity 0.5

# Fibre Orientation Distribution estimation
# Perform multi-shell, multi-tissue constrained spherical deconvolution
# BRANCH OUT HERE FOR FIXEL ANALYSES
for i in ${sbjs}; do
  dwi2fod msmt_csd ${bids_dir}/derivatives/mrtrix/sub-${i}/DWI.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_WM.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/WM_FODs.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_GM.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/GM.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/RF_CSF.txt\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/CSF.mif\
  -mask ${bids_dir}/sub-${i}/dwi/nodif_brain_mask.nii.gz -force
done

# 3) Connectome Generation
# Mask for gray matter - white matter interface
for i in ${sbjs}; do
  5tt2gmwmi ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/gmwmi.mif -force
done

source /scinet/conda/etc/profile.d/scinet-conda.sh
scinet-conda create -n mrtrix3 -c mrtrix3 mrtrix3
scinet-conda activate mrtrix3

# Create whole-brain tractography
for i in ${sbjs}; do
  tckgen ${bids_dir}/derivatives/mrtrix/sub-${i}/WM_FODs.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/10M.tck\
  -act ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif\
  -backtrack -crop_at_gmwmi -seed_gmwmi ${bids_dir}/derivatives/mrtrix/sub-${i}/gmwmi.mif\
  -maxlength 250 -select 10M -cutoff 0.1 -angle 45 -force
done

# Apply spherical-deconvolution informed filtering of tractograms (SIFT) algorithm
for i in ${sbjs}; do
  tcksift ${bids_dir}/derivatives/mrtrix/sub-${i}/10M.tck\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/WM_FODs.mif\
  ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck\
  -act ${bids_dir}/derivatives/mrtrix/sub-${i}/5TT.mif -term_number 2M -force
done

# Create connectome for hipp subfields
# Use -assignment_forward_search 10 for tracking more fibers
for i in ${sbjs}; do
  tck2connectome  ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/hipp_nodes.mif \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_hipp_connectome_stream.csv \
  -out_assignments ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_hipp_assignments_stream.csv \
  -force
done

# FA/MD/RD/AD Connectomes #
# Create a mask
for i in ${sbjs};do
  dwi2mask ${bids_dir}/sub-${i}/dwi/data.nii.gz \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/tempmask.mif \
  -fslgrad ${bids_dir}/sub-${i}/dwi/bvecs \
  ${bids_dir}/sub-${i}/dwi/bvals -force
done

# Create tensor images
for i in ${sbjs}; do
  dwi2tensor ${bids_dir}/sub-${i}/dwi/data.nii.gz \
  -mask ${bids_dir}/derivatives/mrtrix/sub-${i}/tempmask.mif \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/tensor.mif \
  -fslgrad ${bids_dir}/sub-${i}/dwi/bvecs \
  ${bids_dir}/sub-${i}/dwi/bvals -force
done

# Create metric specific images
for i in ${sbjs}; do
  tensor2metric ${bids_dir}/derivatives/mrtrix/sub-${i}/tensor.mif \
  -fa ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_FA.mif \
  -adc ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_MD.mif \
  -ad ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_AD.mif \
  -rd ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_RD.mif -force
done

# Metric specific connectomes
metrics="FA MD AD RD"
for i in ${sbjs}; do
  for t in ${metrics}; do
    tcksample ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
    ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_${t}.mif \
    ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_${t}.csv -stat_tck mean

    tck2connectome ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
    ${bids_dir}/derivatives/mrtrix/sub-${i}/hipp_nodes.mif \
    ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_hipp_connectome_${t}.csv \
    -scale_file ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_${t}.csv \
    -stat_edge mean -force
  done
done

#### END ####
