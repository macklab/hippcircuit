#!/bin/bash
#SBATCH -N 2
#SBATCH -c 40
#SBATCH --time=24:00:00
#SBATCH -o %x-%j.out

module load NiaEnv/2018a
module load intel/2018.2
module load ants/2.3.1
module load openblas/0.2.20
module load fsl/.experimental-6.0.0
module load fftw/3.3.7
module load eigen/3.3.4
module load mrtrix/3.0.0
module load freesurfer/6.0.0

# Define path
bids_dir="/project/m/mmack/projects/hippcircuit"

mkdir ${bids_dir}/derivatives/fixel-based/standard_space

# Create T1 template mask
fslmaths ${bids_dir}/derivatives/fixel-based/template/T1_template.nii.gz \
-bin ${bids_dir}/derivatives/fixel-based/template/T1_template_mask.nii.gz

# Define the files for ants
reference=$FSLDIR/data/standard/MNI152_T1_1mm_brain.nii.gz
reference_mask=$FSLDIR/data/standard/MNI152_T1_1mm_brain_mask.nii.gz
input=${bids_dir}/derivatives/fixel-based/template/T1_template.nii.gz
input_mask=${bids_dir}/derivatives/fixel-based/template/T1_template_mask.nii.gz
outpath=${bids_dir}/derivatives/fixel-based/standard_space

# Register an input/source image to a reference image
antsRegistration \
  --verbose 1 \
  --dimensionality 3 \
  --float 0 \
  --output [${outpath}/ants, ${outpath}/antsWarped.nii.gz, ${outpath}/antsInverseWarped.nii.gz] \
  --interpolation Linear \
  --use-histogram-matching 1 \
  --winsorize-image-intensities [0.005,0.995] \
  --transform Rigid[0.1] \
    --metric CC[${reference},${input},1,4,Regular,0.1] \
    --convergence [1000x500x250x100,1e-6,10] \
    --shrink-factors 8x4x2x1 \
    --smoothing-sigmas 3x2x1x0vox \
  --transform Affine[0.1] \
    --metric CC[${reference},${input},1,4,Regular,0.2] \
    --convergence [1000x500x250x100,1e-6,10] \
    --shrink-factors 8x4x2x1 \
    --smoothing-sigmas 3x2x1x0vox \
  --transform SyN[0.1,3,0] \
    --metric CC[${reference},${input},1,4] \
    --convergence [100x70x50x20,1e-6,10] \
    --shrink-factors 4x2x2x1 \
    --smoothing-sigmas 2x2x1x0vox \
  -x [${reference_mask},${input_mask}]

# Generate an identity (deformation field) warp
warpinit ${reference} ${outpath}/inv_identity_warp[].nii

# Transform this identity warp
for i in {0..2}; do
    antsApplyTransforms \
    --dimensionality 3 \
    --input-image-type 0 \
    --input ${outpath}/inv_identity_warp${i}.nii \
    --output ${outpath}/inv_mrtrix_warp${i}.nii \
    --reference-image ${reference} \
    --transform [${outpath}/ants0GenericAffine.mat, 1] \
    --transform ${outpath}/ants1InverseWarp.nii.gz
done

# Correct the warp
warpcorrect ${outpath}/inv_mrtrix_warp[].nii \
  ${outpath}/inv_mrtrix_warp_corrected.mif #-marker 2147483647

# Warp the image
mrtransform ${reference} \
  -warp ${outpath}/inv_mrtrix_warp_corrected.mif \
  ${outpath}/reference_warped.mif

# Check the warped image
mrview reference_warped.mif \
  -overlay.load antsInverseWarped.nii.gz \
  -overlay.opacity 0.3

# 1) Warp the tracts
tcktransform ${bids_dir}/derivatives/fixel-based/template/2M_sift_template.tck \
  ${outpath}/inv_mrtrix_warp_corrected.mif \
  ${outpath}/2M_sift_template_MNI.tck

# 2) Warm the wmfod template
mrtransform ${bids_dir}/derivatives/fixel-based/template/wmfod_template.mif \
  -warp ${outpath}/inv_mrtrix_warp_corrected.mif \
  -reorient_fod no \
  ${outpath}/wmfod_template_MNI.mif

# Check
mrview wmfod_template_MNI.mif \
  -overlay.load antsInverseWarped.nii.gz \
  -overlay.opacity 0.3

# 3) Transform/warp the node template
antsApplyTransforms \
  --dimensionality 3 \
  --input-image-type 3 \
  --float 0 \
  --input ${bids_dir}/derivatives/fixel-based/template/node_template.nii.gz \
  --output ${outpath}/node_template_MNI.nii.gz \
  --reference-image ${reference} \
  --interpolation NearestNeighbor \
  --transform [${outpath}/ants0GenericAffine.mat, 1] \
  --transform ${outpath}/ants1InverseWarp.nii.gz

# Check
mrview wmfod_template_MNI.mif \
  -overlay.load antsInverseWarped.nii.gz \
  -overlay.opacity 0.3
