# Connectome Generation

# Custom directories
bids_dir="/data/hippcircuit"
sbjs="sub-103212"
# sbjs=$(head -1 subjects.txt)

# 1) Structural image processing
# Tissue segmented image
for i in ${sbjs}; do
  5ttgen fsl ${bids_dir}/${i}/anat/T1w_acpc_dc_restore_brain.nii.gz\
  ${bids_dir}/derivatives/mrtrix/${i}/5TT.mif -premasked
done

# Convert multi-tissue image into 3D greyscale
# Visualize vis.mif for mislabels
for i in ${sbjs}; do
  5tt2vis ${bids_dir}/derivatives/mrtrix/${i}/5TT.mif\
  ${bids_dir}/derivatives/mrtrix/${i}/vis.mif
done

# Assign the right labels to connectome with respect to the parcellated image
for i in ${sbjs}; do
  labelconvert ${bids_dir}/derivatives/mrtrix/${i}/${i}_T1w_GM_labels.nii.gz\
  ${bids_dir}/derivatives/mrtrix/${i}/GM_labels_original.txt\
  ${bids_dir}/derivatives/mrtrix/${i}/GM_labels_order.txt\
  ${bids_dir}/derivatives/mrtrix/${i}/hipp_nodes.mif -force
done

# Replace sub-cortical gray matter estimates
for i in ${sbjs}; do
  labelsgmfix ${bids_dir}/derivatives/mrtrix/${i}/hipp_nodes.mif\
  ${bids_dir}/${i}/anat/T1w_acpc_dc_restore_brain.nii.gz\
  ${bids_dir}/derivatives/mrtrix/${i}/GM_labels_order.txt\
  ${bids_dir}/derivatives/mrtrix/${i}/hipp_nodes_fixSGM.mif -premasked -nthreads 20 -force
done

# 2) DWI Processing
# Convert diffusion image into non-compressed format
for i in ${sbjs}; do
  mrconvert ${bids_dir}/${i}/dwi/data.nii.gz\
  ${bids_dir}/derivatives/mrtrix/${i}/DWI.mif -fslgrad\
  ${bids_dir}/${i}/dwi/bvecs ${bids_dir}/${i}/dwi/bvals\
  -datatype float32 -strides 0,0,0,1
done

# Generate b=0 image
for i in ${sbjs}; do
  dwiextract ${bids_dir}/derivatives/mrtrix/${i}/DWI.mif - -bzero | mrmath - mean\
  ${bids_dir}/derivatives/mrtrix/${i}/meanb0.mif -axis 3
done

# Estimate multi-shell, multi-tissue response function
for i in ${sbjs}; do
  dwi2response msmt_5tt ${bids_dir}/derivatives/mrtrix/${i}/DWI.mif\
  ${bids_dir}/derivatives/mrtrix/${i}/5TT.mif\
  ${bids_dir}/derivatives/mrtrix/${i}/RF_WM.txt\
  ${bids_dir}/derivatives/mrtrix/${i}/RF_GM.txt\
  ${bids_dir}/derivatives/mrtrix/${i}/RF_CSF.txt\
  -voxels ${bids_dir}/derivatives/mrtrix/${i}/RF_voxels.mif -nthreads 30
done
# Check mrview meanb0.mif -overlay.load RF_voxels.mif -overlay.opacity 0.5

# Perform multi-shell, multi-tissue constrained spherical deconvolution
for i in ${sbjs}; do #msdwi2fod?
  dwi2fod msmt_csd ${bids_dir}/derivatives/mrtrix/${i}/DWI.mif\
  ${bids_dir}/derivatives/mrtrix/${i}/RF_WM.txt\
  ${bids_dir}/derivatives/mrtrix/${i}/WM_FODs.mif\
  ${bids_dir}/derivatives/mrtrix/${i}/RF_GM.txt\
  ${bids_dir}/derivatives/mrtrix/${i}/GM.mif\
  ${bids_dir}/derivatives/mrtrix/${i}/RF_CSF.txt\
  ${bids_dir}/derivatives/mrtrix/${i}/CSF.mif\
  -mask ${bids_dir}/${i}/dwi/nodif_brain_mask.nii.gz
done

# 3) Connectome Generation
# Mask for gray matter - white matter interface
for i in ${sbjs}; do
  5tt2gmwmi ${bids_dir}/derivatives/mrtrix/${i}/5TT.mif \
  ${bids_dir}/derivatives/mrtrix/${i}/gmwmi.mif
done

# Create whole-brain tractography
for i in ${sbjs}; do
  tckgen ${bids_dir}/derivatives/mrtrix/${i}/WM_FODs.mif\
  ${bids_dir}/derivatives/mrtrix/${i}/10M.tck\
  -act ${bids_dir}/derivatives/mrtrix/${i}/5TT.mif\
  -backtrack -crop_at_gmwmi -seed_gmwmi ${bids_dir}/derivatives/mrtrix/${i}/gmwmi.mif\
  -maxlength 250 -select 10M -cutoff 0.1 -angle 45 -nthreads 30 -force
done

# Apply spherical-deconvolution informed filtering of tractograms (SIFT) algorithm
for i in ${sbjs}; do
  tcksift ${bids_dir}/derivatives/mrtrix/${i}/10M.tck\
  ${bids_dir}/derivatives/mrtrix/${i}/WM_FODs.mif\
  ${bids_dir}/derivatives/mrtrix/${i}/2M_sift.tck\
  -act ${bids_dir}/derivatives/mrtrix/${i}/5TT.mif -term_number 2M -nthreads 15
done

# Create connectome for hipp subfields
# Use -assignment_forward_search 10 for tracking more fibers
for i in ${sbjs}; do
  tck2connectome  ${bids_dir}/derivatives/mrtrix/${i}/2M_sift.tck\
  ${bids_dir}/derivatives/mrtrix/${i}/hipp_nodes_fixSGM.mif\
  ${bids_dir}/derivatives/mrtrix/${i}/${i}_hipp_connectome.csv\
  -out_assignments ${bids_dir}/derivatives/mrtrix/${i}/${i}_hipp_assignments.csv -force -nthreads 30
done


#### END ####