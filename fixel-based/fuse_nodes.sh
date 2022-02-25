#!/bin/bash
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --time=30:00
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

# Define subjects
sbjs=$(sed -n 1,85p ${bids_dir}/subjects.txt)

# Warp nodes to T1 template
for i in $sbjs; do
  mrtransform ${bids_dir}/derivatives/mrtrix/sub-${i}/hipp_nodes.mif \
  -warp ${bids_dir}/derivatives/fixel-based/warps/sub-${i}_subject2template_warp.mif \
  -interp nearest -datatype UInt32LE \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/nodes_in_template_space.mif \
  -template ${bids_dir}/derivatives/mrtrix/sub-${i}/hipp_nodes.mif -force
done

# Convert T1 template to nifti for ants
mrconvert ${bids_dir}/derivatives/fixel-based/template/T1_template.mif \
  ${bids_dir}/derivatives/fixel-based/template/T1_template.nii.gz

# Convert mifs to nifti for ants
for i in $sbjs; do
  mrconvert ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/T1_in_template_space.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/T1_in_template_space.nii.gz

  mrconvert ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/nodes_in_template_space.mif \
  ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/nodes_in_template_space.nii.gz
done

# Fuse nodes into a template
antsJointFusion \
  -a 0.1 \
  -g ${bids_dir}/derivatives/fixel-based/fixels/sub-*/T1_in_template_space.nii.gz \
  -l ${bids_dir}/derivatives/fixel-based/fixels/sub-*/nodes_in_template_space.nii.gz \
  -b 2.0 \
  -o ${bids_dir}/derivatives/fixel-based/template/node_template.nii.gz \
  -s 3x3x3 \
  -t ${bids_dir}/derivatives/fixel-based/template/T1_template.nii.gz \
  -v

# OTHER OPTIONS
# Option 1
ImageMath 3 ${bids_dir}/derivatives/fixel-based/template/majorityvote.nii.gz \
  MajorityVoting ${bids_dir}/derivatives/fixel-based/fixels/sub-*/nodes_in_template_space.nii.gz
# include pearson correlation

# Option 2
cp ${bids_dir}/derivatives/fixel-based/fixels/sub-792564/nodes_in_template_space.nii.gz \
  ${bids_dir}/derivatives/fixel-based/template/nodes_mask.nii.gz

tmp_sbjs=$(sed -n 1,30p ${bids_dir}/template_sbjs.txt)
for i in $tmp_sbjs; do
  fslmaths ${bids_dir}/derivatives/fixel-based/template/nodes_mask.nii.gz \
  -add ${bids_dir}/derivatives/fixel-based/fixels/sub-${i}/nodes_in_template_space.nii.gz \
  ${bids_dir}/derivatives/fixel-based/template/nodes_mask.nii.gz
done

fslmaths ${bids_dir}/derivatives/fixel-based/template/nodes_mask.nii.gz \
  -bin ${bids_dir}/derivatives/fixel-based/template/nodes_mask_bin.nii.gz

fslmaths ${bids_dir}/derivatives/fixel-based/template/nodes_mask_bin.nii.gz \
  -kernel sphere 2.5 -dilM ${bids_dir}/derivatives/fixel-based/template/nodes_mask_bin_dil.nii.gz

antsJointFusion \
  -a 0.1 \
  -g ${bids_dir}/derivatives/fixel-based/fixels/sub-10*/T1_in_template_space.nii.gz \
  -l ${bids_dir}/derivatives/fixel-based/fixels/sub-10*/nodes_in_template_space.nii.gz \
  -b 2.0 \
  -o ${bids_dir}/derivatives/fixel-based/template/node_template.nii.gz \
  -s 3x3x3 \
  -t ${bids_dir}/derivatives/fixel-based/template/T1_template_with_mask.nii.gz \
  -x ${bids_dir}/derivatives/fixel-based/template/nodes_mask_bin_dil.nii.gz \
  -v







# END
