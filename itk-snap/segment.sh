#!/bin/bash

# Download T1s
for i in $sbjs; do
  aws_dir="s3://hcp-openaccess/HCP_1200/${i}/T1w"
  mkdir ${seg_dir}/sub-${i}
  aws s3 cp ${aws_dir}/T1w_acpc_dc_restore_brain.nii.gz ${seg_dir}/sub-${i}
done

# Create a workspace
for i in ${sbjs}; do
  itksnap-wt -layers-set-main ${seg_dir}/sub-${i}/T1w_acpc_dc_restore_brain.nii.gz\
  -tags-add T1-MRI -layers-list -o ${seg_dir}/sub-${i}/${i}.itksnap
done

# Create a ticket
for i in ${sbjs}; do
  cd ${seg_dir}/sub-${i}
  ticket=$(itksnap-wt -i ${seg_dir}/sub-${i}/${i}.itksnap -dss-tickets-create 455103a0295cbf85b267d40b0350d12784b198cc)
  ticket_num=$(echo ${ticket} | tail -n1 | cut -d">" -f2)
  echo ${i} > "ticket_${i}.txt"
  echo $ticket_num >> "ticket_${i}.txt"
done

# Moninor ticket
for i in ${sbjs}; do
  itksnap-wt -dss-tickets-wait $(cat ${seg_dir}/sub-${i}/ticket_${i}.txt | tail -n1) 0
done

# Download results
for i in ${sbjs}; do
  itksnap-wt -dss-tickets-download $(cat ${seg_dir}/sub-${i}/ticket_${i}.txt | tail -n1) ${seg_dir}/sub-${i}
done
