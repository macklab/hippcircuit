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

# Define subjects
sbjs=$(sed -n 1,85p ${bids_dir}/subjects.txt)

# Tissue segmention of T1 template
5ttgen fsl ${bids_dir}/derivatives/fixel-based/template/T1_template.mif \
  ${bids_dir}/derivatives/fixel-based/template/5TT_template.mif -premasked -force

# Mask for gray matter - white matter interface
5tt2gmwmi ${bids_dir}/derivatives/fixel-based/template/5TT_template.mif \
  ${bids_dir}/derivatives/fixel-based/template/gmwmi_template.mif -force

source /scinet/conda/etc/profile.d/scinet-conda.sh
scinet-conda create -n mrtrix3 -c mrtrix3 mrtrix3
scinet-conda activate mrtrix3

# Create whole-brain tractography
tckgen ${bids_dir}/derivatives/fixel-based/template/wmfod_template.mif \
  ${bids_dir}/derivatives/fixel-based/template/10M_template.tck \
  -act ${bids_dir}/derivatives/fixel-based/template/5TT_template.mif \
  -backtrack -crop_at_gmwmi -seed_gmwmi ${bids_dir}/derivatives/fixel-based/template/gmwmi_template.mif \
  -maxlength 250 -select 10M -cutoff 0.1 -angle 45 -force

# Apply spherical-deconvolution informed filtering of tractograms (SIFT) algorithm
tcksift ${bids_dir}/derivatives/fixel-based/template/10M_template.tck \
  ${bids_dir}/derivatives/fixel-based/template/wmfod_template.mif \
  ${bids_dir}/derivatives/fixel-based/template/2M_sift_template.tck \
  -act ${bids_dir}/derivatives/fixel-based/template/5TT_template.mif \
  -term_number 2M -force
