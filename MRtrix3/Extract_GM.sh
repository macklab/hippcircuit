# Extract gray matter ROIs from hipp-WM Atlas

# Custom directories
bids_dir="/data/hippcircuit"
work_dir="${bids_dir}/derivatives/mrtrix"
sbjs="sub-103212"
# sbjs=$(head -1 subjects.txt)

for i in ${sbjs}; do
  fslmaths ${work_dir}/${i}/${i}_T1w_labels.nii.gz -thr 1 -uthr 1 -bin ${work_dir}/${i}/${i}_T1w_GM_labels
  atlas=${work_dir}/${i}/${i}_T1w_GM_labels.nii.gz
  parcel=1

  count=`echo "$parcel+1" | bc`
  for r in 2 4 5 6 101 102 104 105 106
  do
    fslmaths ${work_dir}/${i}/${i}_T1w_labels.nii.gz -thr $r -uthr $r\
    -bin -mul $count ${work_dir}/${i}/${i}_tmp.nii.gz
    fslmaths ${work_dir}/${i}/${i}_tmp.nii.gz -binv ${work_dir}/${i}/${i}_tmp2.nii.gz
    fslmaths $atlas -mas ${work_dir}/${i}/${i}_tmp2.nii.gz -add ${work_dir}/${i}/${i}_tmp.nii.gz $atlas
    count=`echo "$count+1" | bc`
  done
done
