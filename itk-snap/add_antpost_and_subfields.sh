#!/bin/bash
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --time=24:00:00

#######################
#### Configuration ####
#######################
# Where logs stored - Change this for your directory
#SBATCH -o /project/m/mmack/projects/hippcircuit/code/logs/%x-%j.out

# Please also change these paths for your directory
bids_dir="/project/m/mmack/projects/hippcircuit"
work_dir="${bids_dir}/derivatives/itk-snap"  # where segmentations stored
#######################

# Define subjects
sbjs=$1
# OR define subjects here:
# sbjs=$(sed -n 1p ${bids_dir}/subjects_rest.txt)
cd ${work_dir}

# Upload modules
module load NiaEnv/2018a
module load intel/2018.2
module load ants/2.3.1
module load openblas/0.2.20
module load fsl/.experimental-6.0.0
module load fftw/3.3.7
module load eigen/3.3.4
module load mrtrix/3.0.0
module load freesurfer/6.0.0

# Extract roi from maget
num=$(cat ${bids_dir}/derivatives/labels/subfield_labels.txt | awk '{print $1}' | tail -n 10)
var=$(cat ${bids_dir}/derivatives/labels/subfield_labels.txt | awk '{print $8}' | tail -n 10)
for k in ${sbjs}; do
  for i in ${num}; do
    roi=$(echo $var | awk "{print \$$i}" | tr -d '"')

    fslmaths ${bids_dir}/derivatives/mrtrix/sub-${k}/sub-${k}_T1w_GM_labels.nii.gz \
    -thr ${i} -uthr ${i} -bin ${work_dir}/sub-${k}/${roi}.nii.gz
  done
done

# Create an atlas
for i in ${sbjs}; do
  fslmaths ${work_dir}/sub-${i}/R_CA1.nii.gz \
  -mas ${work_dir}/sub-${i}/Right_Anterior_dil_thr_mask.nii.gz \
  -bin -mul 1 ${work_dir}/sub-${i}/ant_post_subfields.nii.gz

  fslmaths ${work_dir}/sub-${i}/R_CA1.nii.gz \
  -mas ${work_dir}/sub-${i}/Right_Posterior_dil_thr_mask.nii.gz \
  -bin -mul 2 ${work_dir}/sub-${i}/tmp3.nii.gz

  fslmaths ${work_dir}/sub-${i}/tmp3.nii.gz -binv ${work_dir}/sub-${i}/tmp4.nii.gz
  fslmaths ${work_dir}/sub-${i}/ant_post_subfields.nii.gz \
  -mas ${work_dir}/sub-${i}/tmp4.nii.gz \
  -add ${work_dir}/sub-${i}/tmp3.nii.gz ${work_dir}/sub-${i}/ant_post_subfields.nii.gz
done

# Right side
for i in ${sbjs}; do
  parcel=1
  countRant=`echo "$parcel+2" | bc`
  countRpost=`echo "$parcel+6" | bc`
  atlas=${work_dir}/sub-${i}/ant_post_subfields.nii.gz
  for r in R_subiculum.nii.gz R_CA4DG.nii.gz R_CA2CA3.nii.gz R_stratum.nii.gz; do
    fslmaths ${work_dir}/sub-${i}/${r} -mas ${work_dir}/sub-${i}/Right_Anterior_dil_thr_mask.nii.gz \
    -bin -mul $countRant ${work_dir}/sub-${i}/tmp_ant1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_ant1.nii.gz -binv ${work_dir}/sub-${i}/tmp_ant2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_ant2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_ant1.nii.gz $atlas
    countRant=`echo "$countRant+1" | bc`

    fslmaths ${work_dir}/sub-${i}/${r} -mas ${work_dir}/sub-${i}/Right_Posterior_dil_thr_mask.nii.gz \
    -bin -mul $countRpost ${work_dir}/sub-${i}/tmp_post1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_post1.nii.gz -binv ${work_dir}/sub-${i}/tmp_post2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_post2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_post1.nii.gz $atlas
    countRpost=`echo "$countRpost+1" | bc`
  done
done

# Left side
for i in ${sbjs}; do
  parcel=1
  countLant=`echo "$parcel+10" | bc`
  countLpost=`echo "$parcel+15" | bc`
  atlas=${work_dir}/sub-${i}/ant_post_subfields.nii.gz
  for k in L_CA1.nii.gz L_subiculum.nii.gz L_CA4DG.nii.gz L_CA2CA3.nii.gz L_stratum.nii.gz; do
    fslmaths ${work_dir}/sub-${i}/${k} -mas ${work_dir}/sub-${i}/Left_Anterior_dil_thr_mask.nii.gz \
    -bin -mul $countLant ${work_dir}/sub-${i}/tmp_ant1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_ant1.nii.gz -binv ${work_dir}/sub-${i}/tmp_ant2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_ant2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_ant1.nii.gz $atlas
    countLant=`echo "$countLant+1" | bc`

    fslmaths ${work_dir}/sub-${i}/${k} -mas ${work_dir}/sub-${i}/Left_Posterior_dil_thr_mask.nii.gz \
    -bin -mul $countLpost ${work_dir}/sub-${i}/tmp_post1.nii.gz
    fslmaths ${work_dir}/sub-${i}/tmp_post1.nii.gz -binv ${work_dir}/sub-${i}/tmp_post2.nii.gz
    fslmaths $atlas -mas ${work_dir}/sub-${i}/tmp_post2.nii.gz \
    -add ${work_dir}/sub-${i}/tmp_post1.nii.gz $atlas
    countLpost=`echo "$countLpost+1" | bc`
  done
done
