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

# Define labels and label number
rois="CA4DG CA2CA3 CA1 SUB ERC"
R_labels="3 4 1 2 13"
L_labels="8 9 6 7 11"

# Extract tracts - Right Side
for i in 1,2 2,3 3,4 4,5 5,1 5,3 4,1; do
  IFS=","
  set -- $i

  roi_num1=$(echo $rois | awk '{print $'$1'}')
  roi_num2=$(echo $rois | awk '{print $'$2'}')

  label_num1=$(echo $R_labels| awk '{print $'$1'}')
  label_num2=$(echo $R_labels| awk '{print $'$2'}')

  connectome2tck \
  ${bids_dir}/derivatives/fixel-based/template/2M_sift_template.tck \
  ${bids_dir}/derivatives/fixel-based/template/assignments_stream_template_hipp_MTL.csv \
  ${bids_dir}/derivatives/fixel-based/hpc_tracks/R_${roi_num1}_${roi_num2}/tracks_R_${roi_num1}_${roi_num2}.tck \
  -nodes ${label_num1},${label_num2} -exclusive -files single -force
done

# Extract tracts - Left Side
for i in 1,2 2,3 3,4 4,5 5,1 5,3 4,1; do
  IFS=","
  set -- $i

  roi_num1=$(echo $rois | awk '{print $'$1'}')
  roi_num2=$(echo $rois | awk '{print $'$2'}')

  label_num1=$(echo $L_labels| awk '{print $'$1'}')
  label_num2=$(echo $L_labels| awk '{print $'$2'}')

  connectome2tck \
  ${bids_dir}/derivatives/fixel-based/template/2M_sift_template.tck \
  ${bids_dir}/derivatives/fixel-based/template/assignments_stream_template_hipp_MTL.csv \
  ${bids_dir}/derivatives/fixel-based/hpc_tracks/L_${roi_num1}_${roi_num2}/tracks_L_${roi_num1}_${roi_num2}.tck \
  -nodes ${label_num1},${label_num2} -exclusive -files single -force
done

##### dilate ####
# for i in 1,2 2,3 3,4 4,5 5,1 5,3 4,1; do
#   IFS=","
#   set -- $i
#
#   roi_num1=$(echo $rois | awk '{print $'$1'}')
#   roi_num2=$(echo $rois | awk '{print $'$2'}')
#
#   label_num1=$(echo $R_labels| awk '{print $'$1'}')
#   label_num2=$(echo $R_labels| awk '{print $'$2'}')
#
#   fslmaths \
#   ${bids_dir}/derivatives/fixel-based/hpc_tracks/R_${roi_num1}_${roi_num2}/R_${roi_num1}_${roi_num2}.nii.gz \
#   -kernel sphere 1 -dilM \
#   -thr 0.5 \
#   -bin \
#   ${bids_dir}/derivatives/fixel-based/hpc_tracks/R_${roi_num1}_${roi_num2}/R_${roi_num1}_${roi_num2}_dil_bin.nii.gz
# done
#
# for i in 1,2 2,3 3,4 4,5 5,1 5,3 4,1; do
#   IFS=","
#   set -- $i
#
#   roi_num1=$(echo $rois | awk '{print $'$1'}')
#   roi_num2=$(echo $rois | awk '{print $'$2'}')
#
#   label_num1=$(echo $L_labels| awk '{print $'$1'}')
#   label_num2=$(echo $L_labels| awk '{print $'$2'}')
#
#   fslmaths \
#   ${bids_dir}/derivatives/fixel-based/hpc_tracks/L_${roi_num1}_${roi_num2}/L_${roi_num1}_${roi_num2}.nii.gz \
#   -kernel sphere 1 -dilM \
#   -thr 0.5 \
#   -bin \
#   ${bids_dir}/derivatives/fixel-based/hpc_tracks/L_${roi_num1}_${roi_num2}/L_${roi_num1}_${roi_num2}_dil_bin.nii.gz
# done


# END
