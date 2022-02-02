#!/bin/bash
#SBATCH -N 1
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

cd ${bids_dir}/derivatives/FBA
mkdir -p template/fod_input
mkdir -p template/mask_input

#Symbolic link all FOD images (and masks) into a single input folder
cd ${bids_dir}
#sbjs=$(ls -R -d sub-*)
sbjs=$(sed -n 64,85p ${bids_dir}/subjects.txt)

# for i in $sbjs; do
#   mv $i.mif ../fod_input_all
# done

for i in $sbjs; do
  ln -sr ${bids_dir}/derivatives/mrtrix/${i}/WM_FODs.mif \
  ${bids_dir}/derivatives/FBA/template/fod_input/${i}.mif
done

for i in $sbjs; do
  dwi2mask ${bids_dir}/derivatives/mrtrix/${i}/DWI.mif \
  ${bids_dir}/derivatives/FBA/template/mask_input/${i}.mif
done

population_template ${bids_dir}/derivatives/FBA/template/fod_input \
    -mask_dir ${bids_dir}/derivatives/FBA/template/mask_input/ \
    ${bids_dir}/derivatives/FBA/template/wmfod_template.mif \
    -voxel_size 1.25 -warp_dir ${bids_dir}/derivatives/FBA/template/warps

# Register all subjects FOD images to the FOD fa_template
for i in $sbjs; do
  mrregister ${bids_dir}/derivatives/mrtrix/sub-${i}/WM_FODs.mif \
  -mask1 ${bids_dir}/derivatives/FBA/template/mask_input/sub-${i}.mif \
  ${bids_dir}/derivatives/FBA/template/wmfod_template.mif \
  -nl_warp ${bids_dir}/derivatives/FBA/template/warps/sub-${i}_subject2template_warp.mif \
  ${bids_dir}/derivatives/FBA/template/warps/sub-${i}_template2subject_warp.mif
done

# 12) Compute the template mask (intersection of all subject masks in template space)
#wrap all masks into template space
mkdir ${bids_dir}/derivatives/FBA/template/template_space
for i in $sbjs; do
  mrtransform ${bids_dir}/derivatives/FBA/template/mask_input/sub-${i}.mif \
  -warp ${bids_dir}/derivatives/FBA/template/warps/sub-${i}_subject2template_warp.mif \
  -interp nearest -datatype bit ${bids_dir}/derivatives/FBA/template/template_space/sub-${i}_mask_in_template_space.mif
done

# Compute the template mask as the intersection of all wraped dti_mask_upsampled
# Don't add any regions at this stage!!
#for i in $sbjs; do
mrmath ${bids_dir}/derivatives/FBA/template/template_space/sub-*_mask_in_template_space.mif \
min ${bids_dir}/derivatives/FBA/template/template_mask.mif -datatype bit
#done

# 13) Compute a white matter template analysis fixel mask
#compute a template AFD peaks fixel image
fod2fixel ${bids_dir}/derivatives/FBA/template/wmfod_template.mif \
-mask ${bids_dir}/derivatives/FBA/template/template_mask.mif \
${bids_dir}/derivatives/FBA/template/fixel_temp -peak peaks.mif

#threshold the peaks fixel image
#threshold has to be determined manually so open up the peaks.mif
mrthreshold ${bids_dir}/derivatives/FBA/template/fixel_temp/peaks.mif \
-abs 0.10 ${bids_dir}/derivatives/FBA/template/fixel_temp/mask.mif

#generate an analysis voxel mask from the fixel mask
fixel2voxel ${bids_dir}/derivatives/FBA/template/fixel_temp/mask.mif \
max - | mrfilter - median ${bids_dir}/derivatives/FBA/template/voxel_mask.mif
#rm -rf ${bids_dir}/derivatives/FBA/template/fixel_temp

#Recompute the fixel mask using the analysis voxel mask (0.2??)
fod2fixel -mask ${bids_dir}/derivatives/FBA/template/voxel_mask.mif -fmls_peak_value 0.10 \
${bids_dir}/derivatives/FBA/template/wmfod_template.mif \
${bids_dir}/derivatives/FBA/template/fixel_mask

# 14) Warp FOD images to template dti_mask_in_template_space
for i in ${sbjs}; do
  mrtransform ${bids_dir}/derivatives/mrtrix/sub-${i}/WM_FODs.mif -warp \
  ${bids_dir}/derivatives/FBA/template/warps/sub-${i}_subject2template_warp.mif \
  -reorient_fod no ${bids_dir}/derivatives/FBA/template/template_space/sub-${i}_fod_in_template_space_NOT_REORIENTED.mif
done

# 15) Segment FOD images to estimate fixels and their apparent fibre density (FD)
for i in ${sbjs}; do
  fod2fixel -mask ${bids_dir}/derivatives/FBA/template/template_mask.mif \
  ${bids_dir}/derivatives/FBA/template/template_space/sub-${i}_fod_in_template_space_NOT_REORIENTED.mif \
  ${bids_dir}/derivatives/FBA/template/template_space/sub-${i}_fod_in_template_space_NOT_REORIENTED -afd fd.mif
done

# 16) Reorient fixels
for i in ${sbjs}; do
  fixelreorient ${bids_dir}/derivatives/FBA/template/template_space/sub-${i}_fod_in_template_space_NOT_REORIENTED \
  ${bids_dir}/derivatives/FBA/template/warps/sub-${i}_subject2template_warp.mif \
  ${bids_dir}/derivatives/FBA/template/template_space/sub-${i}_fixel_in_template_space
done

# for i in ${sbjs}; do
#   rm -rf ${bids_dir}/derivatives/FBA/template/template_space/sub-${i}_fod_in_template_space_NOT_REORIENTED
# done

# 17) Assign subject fixel to template fixels
for i in ${sbjs}; do
  fixelcorrespondence ${bids_dir}/derivatives/FBA/template/template_space/sub-${i}_fixel_in_template_space/fd.mif \
  ${bids_dir}/derivatives/FBA/template/fixel_mask ${bids_dir}/derivatives/FBA/template/fd sub-${i}.mif
done

# 18) Compute the fibre cross-section (FC) metric
for i in ${sbjs}; do
  warp2metric ${bids_dir}/derivatives/FBA/template/warps/sub-${i}_subject2template_warp.mif \
  -fc ${bids_dir}/derivatives/FBA/template/fixel_mask \
  ${bids_dir}/derivatives/FBA/template/fc sub-${i}.mif
done

#for group statistical analysis of FC, calculate log(FC) to ensure data are centres around zero and normally distributed
mkdir ${bids_dir}/derivatives/FBA/template/log_fc
cp ${bids_dir}/derivatives/FBA/template/fc/index.mif \
${bids_dir}/derivatives/FBA/template/fc/directions.mif \
${bids_dir}/derivatives/FBA/template/log_fc

for i in ${sbjs}; do
  mrcalc ${bids_dir}/derivatives/FBA/template/fc/sub-${i}.mif \
  -log ${bids_dir}/derivatives/FBA/template/log_fc/sub-${i}.mif
done

# 19) Compute a combined measure of fibre density and cross-section (FDC)
mkdir ${bids_dir}/derivatives/FBA/template/fdc
cp ${bids_dir}/derivatives/FBA/template/fc/index.mif \
${bids_dir}/derivatives/FBA/template/fdc
cp ${bids_dir}/derivatives/FBA/template/fc/directions.mif \
${bids_dir}/derivatives/FBA/template/fdc

# ERROR - [WARNING] header transformations of input images do not match
for i in ${sbjs}; do
  mrcalc ${bids_dir}/derivatives/FBA/template/fd/sub-${i}.mif \
  ${bids_dir}/derivatives/FBA/template/fc/sub-${i}.mif \
  -mult ${bids_dir}/derivatives/FBA/template/fdc/sub-${i}.mif
done

# 20) Perform whole-brain fibre tractography on the FOD template
# the commands from here executed from the template directory
cd ${bids_dir}/derivatives/FBA/template/
tckgen -angle 22.5 -maxlen 250 -minlen 10 -power 1.0 \
${bids_dir}/derivatives/FBA/template/wmfod_template.mif \
-seed_image ${bids_dir}/derivatives/FBA/template/template_mask.mif \
-mask ${bids_dir}/derivatives/FBA/template/template_mask.mif \
-select 10M -cutoff 0.06 ${bids_dir}/derivatives/FBA/template/10M.tck



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

# tckgen ${bids_dir}/derivatives/FBA/template/wmfod_template.mif \
# ${bids_dir}/derivatives/FBA/template/tracts.tck \
# -seed_grid_per_voxel ${bids_dir}/derivatives/FBA/template/template_mask.mif \
# 3 -mask ${bids_dir}/derivatives/FBA/template/template_mask.mif -cutoff 0.25 \
# -angle 45 -step 1.25

tcksift ${bids_dir}/derivatives/FBA/template/10M.tck \
${bids_dir}/derivatives/FBA/template/wmfod_template.mif \
${bids_dir}/derivatives/FBA/template/2M_sift.tck \
-term_number 2M

fixelconnectivity ${bids_dir}/derivatives/FBA/template/fixel_mask/ \
${bids_dir}/derivatives/FBA/template/2M_sift.tck \
${bids_dir}/derivatives/FBA/template/matrix/

fixelfilter ${bids_dir}/derivatives/FBA/template/fd \
smooth ${bids_dir}/derivatives/FBA/template/fd_smooth \
-matrix ${bids_dir}/derivatives/FBA/template/matrix

fixelfilter ${bids_dir}/derivatives/FBA/template/log_fc \
smooth ${bids_dir}/derivatives/FBA/template/log_fc_smooth \
-matrix ${bids_dir}/derivatives/FBA/template/matrix

fixelfilter ${bids_dir}/derivatives/FBA/template/fdc \
smooth ${bids_dir}/derivatives/FBA/template/fdc_smooth \
-matrix ${bids_dir}/derivatives/FBA/template/matrix

# Get stats
fixelcfestats fd files.txt design.txt contrast.txt tracts_sift.tck stats_fd

tcksample ${bids_dir}/derivatives/FBA/template/2M_sift.tck \
${bids_dir}/derivatives/FBA/template/wmfod_template.mif \
${bids_dir}/derivatives/FBA/template/wmfod_template.txt




# END #
