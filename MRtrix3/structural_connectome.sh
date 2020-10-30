
sbjs="sub-103212"
for i in ${sbjs}; do
  5ttgen fsl /data/hippcircuit/${i}/anat/T1w_acpc_dc_restore_brain.nii.gz\
  /data/hippcircuit/derivatives/mrtrix/${i}/5TT.mif -premasked
done

# Visualize vis.mif for mislabels
for i in ${sbjs}; do
  5tt2vis /data/hippcircuit/derivatives/mrtrix/${i}/5TT.mif\
  /data/hippcircuit/derivatives/mrtrix/${i}/vis.mif
done

for i in ${sbjs}; do
  labelconvert /data/hippcircuit/${i}/anat/aparc+aseg.nii.gz\
  /usr/local/freesurfer/FreeSurferColorLUT.txt\
  /data/hippcircuit/code/fs_default.txt\
  /data/hippcircuit/derivatives/mrtrix/${i}/nodes.mif
done

for i in ${sbjs}; do
  labelsgmfix /data/hippcircuit/derivatives/mrtrix/${i}/nodes.mif\
  /data/hippcircuit/${i}/anat/T1w_acpc_dc_restore_brain.nii.gz\
  /data/hippcircuit/code/fs_default.txt\
  /data/hippcircuit/derivatives/mrtrix/${i}/nodes_fixSGM.mif -premasked
done

## DWI Processing
for i in ${sbjs}; do
  mrconvert /data/hippcircuit/${i}/dwi/data.nii.gz\
  /data/hippcircuit/derivatives/mrtrix/${i}/DWI.mif -fslgrad\
  /data/hippcircuit/${i}/dwi/bvecs /data/hippcircuit/${i}/dwi/bvals\
  -datatype float32 -strides 0,0,0,1
done

for i in ${sbjs}; do
  dwiextract /data/hippcircuit/derivatives/mrtrix/${i}/DWI.mif - -bzero | mrmath - mean\
  /data/hippcircuit/derivatives/mrtrix/${i}/meanb0.mif -axis 3
done

for i in ${sbjs}; do
  dwi2response msmt_5tt /data/hippcircuit/derivatives/mrtrix/${i}/DWI.mif\
  /data/hippcircuit/derivatives/mrtrix/${i}/5TT.mif\
  /data/hippcircuit/derivatives/mrtrix/${i}/RF_WM.txt\
  /data/hippcircuit/derivatives/mrtrix/${i}/RF_GM.txt\
  /data/hippcircuit/derivatives/mrtrix/${i}/RF_CSF.txt\
  -voxels /data/hippcircuit/derivatives/mrtrix/${i}/RF_voxels.mif -nthreads 30
done
# Check mrview meanb0.mif -overlay.load RF_voxels.mif -overlay.opacity 0.5

for i in ${sbjs}; do #msdwi2fod?
  dwi2fod msmt_csd /data/hippcircuit/derivatives/mrtrix/${i}/DWI.mif\
  /data/hippcircuit/derivatives/mrtrix/${i}/RF_WM.txt\
  /data/hippcircuit/derivatives/mrtrix/${i}/WM_FODs.mif\
  /data/hippcircuit/derivatives/mrtrix/${i}/RF_GM.txt\
  /data/hippcircuit/derivatives/mrtrix/${i}/GM.mif\
  /data/hippcircuit/derivatives/mrtrix/${i}/RF_CSF.txt\
  /data/hippcircuit/derivatives/mrtrix/${i}/CSF.mif\
  -mask /data/hippcircuit/${i}/dwi/nodif_brain_mask.nii.gz
done

# Connectome Generation
for i in ${sbjs}; do
  5tt2gmwmi /data/hippcircuit/derivatives/mrtrix/${i}/5TT.mif \
  /data/hippcircuit/derivatives/mrtrix/${i}/gmwmi.mif
done

for i in ${sbjs}; do
  tckgen /data/hippcircuit/derivatives/mrtrix/${i}/WM_FODs.mif\
  /data/hippcircuit/derivatives/mrtrix/${i}/10M.tck\
  -act /data/hippcircuit/derivatives/mrtrix/${i}/5TT.mif\
  -backtrack -crop_at_gmwmi -seed_gmwmi /data/hippcircuit/derivatives/mrtrix/${i}/gmwmi.mif\
  -maxlength 250 -select 10M -cutoff 0.1 -angle 45 -nthreads 30 -force
done

for i in ${sbjs}; do
  tcksift /data/hippcircuit/derivatives/mrtrix/${i}/10M.tck\
  /data/hippcircuit/derivatives/mrtrix/${i}/WM_FODs.mif\
  /data/hippcircuit/derivatives/mrtrix/${i}/2M_sift.tck\
  -act /data/hippcircuit/derivatives/mrtrix/${i}/5TT.mif -term_number 2M -nthreads 15
done

for i in ${sbjs}; do
  tck2connectome  /data/hippcircuit/derivatives/mrtrix/${i}/2M_sift.tck\
  /data/hippcircuit/derivatives/mrtrix/${i}/nodes_fixSGM.mif\
  /data/hippcircuit/derivatives/mrtrix/${i}/${i}_connectome.csv\
  -out_assignments /data/hippcircuit/derivatives/mrtrix/${i}/${i}_assignments.csv\
  -assignment_forward_search 50 -force -nthreads 30
done






#### END #####
