#!/bin/bash
#SBATCH -N 1
#SBATCH -c 40
#SBATCH --time=24:00:00
#SBATCH -o %x-%j.out

# modules
module load NiaEnv/2018a
module load intel/2018.2
module load ants/2.3.1
module load openblas/0.2.20
module load fsl/.experimental-6.0.0
module load fftw/3.3.7
module load eigen/3.3.4
module load mrtrix/3.0.0
module load freesurfer/6.0.0

# paths
bids_dir="/project/m/mmack/projects/hippcircuit"
# segmentation of your choice should be in working directory
work_dir="${bids_dir}/derivatives/itk-snap"
cd ${work_dir}

# subjects
sbjs="define_here"

# source
source ${work_dir}/configs/${your_file}