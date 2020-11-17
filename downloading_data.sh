# Set up awscli
pip install --upgrade --user awscli

# Check version
aws -v

# Setup credentials
aws configure

# ls folders in HCP
aws s3 ls hcp-openaccess

# Set up the BIDS directory
dcm2bids_scaffold -o /home/m/mmack/mmack/scratch/projects/hippcircuit
#bids_dir="/home/m/mmack/mmack/scratch/projects/hippcircuit"
bids_dir="/project/m/mmack/projects/hippcircuit"

# save the nth line in the file as a list
sbjs=$(head -1 subjects.txt)
sbjs="100307"

# Create anat and dwi folders to save data
for i in ${sbjs}; do
  mkdir ${bids_dir}/sub-${i}
  mkdir ${bids_dir}/sub-${i}/dwi
  mkdir ${bids_dir}/sub-${i}/anat
done

# Download necessary files
for i in ${sbjs}; do
  aws_dir="s3://hcp-openaccess/HCP_1200/${i}/T1w"
  aws s3 cp ${aws_dir}/aparc+aseg.nii.gz ${bids_dir}/sub-${i}/anat
  aws s3 cp ${aws_dir}/T1w_acpc_dc_restore_brain.nii.gz ${bids_dir}/sub-${i}/anat
  aws s3 cp ${aws_dir}/T2w_acpc_dc_restore_brain.nii.gz ${bids_dir}/sub-${i}/anat

  aws s3 cp ${aws_dir}/Diffusion/bvals ${bids_dir}/sub-${i}/dwi
  aws s3 cp ${aws_dir}/Diffusion/bvecs ${bids_dir}/sub-${i}/dwi
  aws s3 cp ${aws_dir}/Diffusion/data.nii.gz ${bids_dir}/sub-${i}/dwi
  aws s3 cp ${aws_dir}/Diffusion/nodif_brain_mask.nii.gz ${bids_dir}/sub-${i}/dwi
done
