#!/bin/bash

# 1) Anterior/posterior hipp
for i in ${sbjs}; do
  tck2connectome  ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
  ${bids_dir}/derivatives/itk-snap/sub-${i}/ant_post_subfields.nii.gz \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_ant_post_connectome_stream.csv \
  -out_assignments ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_ant_post_assignments_stream.csv \
  -force
done

# Metric specific connectomes
metrics="FA MD AD RD"
for i in ${sbjs}; do
  for t in ${metrics}; do
    tck2connectome ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
    ${bids_dir}/derivatives/itk-snap/sub-${i}/ant_post_subfields.nii.gz \
    ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_ant_post_connectome_${t}.csv \
    -scale_file ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_${t}.csv \
    -stat_edge mean -force
  done
done

#################################
# 2) MTL + anterior/posterior hipp
for i in ${sbjs}; do
  tck2connectome  ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
  ${bids_dir}/derivatives/itk-snap/sub-${i}/ant_post_MTL_rois.nii.gz \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_ant_post_MTL_connectome_stream.csv \
  -out_assignments ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_ant_post_MTL_assignments_stream.csv \
  -force
done

# Metric specific connectomes
metrics="FA MD AD RD"
for i in ${sbjs}; do
  for t in ${metrics}; do
    tck2connectome ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
    ${bids_dir}/derivatives/itk-snap/sub-${i}/ant_post_MTL_rois.nii.gz \
    ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_ant_post_MTL_connectome_${t}.csv \
    -scale_file ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_${t}.csv \
    -stat_edge mean -force
  done
done

##############################
# 3) MTL + maget segmentation (no anterior/posteior)
for i in ${sbjs}; do
  tck2connectome  ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
  ${bids_dir}/derivatives/itk-snap/sub-${i}/MTL_hipp_subfields.nii.gz \
  ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_MTL_hipp_connectome_stream.csv \
  -out_assignments ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_MTL_hipp_assignments_stream.csv \
  -force
done

# Metric specific connectomes
metrics="FA MD AD RD"
for i in ${sbjs}; do
  for t in ${metrics}; do
    tck2connectome ${bids_dir}/derivatives/mrtrix/sub-${i}/2M_sift.tck \
    ${bids_dir}/derivatives/itk-snap/sub-${i}/MTL_hipp_subfields.nii.gz \
    ${bids_dir}/derivatives/mrtrix/sub-${i}/sub-${i}_MTL_hipp_connectome_${t}.csv \
    -scale_file ${bids_dir}/derivatives/mrtrix/sub-${i}/metrics_${t}.csv \
    -stat_edge mean -force
  done
done

# END
