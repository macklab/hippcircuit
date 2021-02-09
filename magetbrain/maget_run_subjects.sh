export QBATCH_PPJ=40                    # requested processors per job
export QBATCH_BATCHSIZE=$QBATCH_PPJ     # commands to run per job
export QBATCH_CORES=$QBATCH_PPJ         # commands to run in parallel per job
export QBATCH_NODES=1                   # number of compute nodes to request for the job, typically for MPI jobs
export QBATCH_MEM="0"
export QBATCH_MEMVARS="mem"
export QBATCH_SYSTEM="slurm"            # queuing system to use ("pbs", "sge","slurm", or "local")
export QBATCH_QUEUE=""                  # Name of submission queue
export QBATCH_OPTIONS="--mail-user=michael.mack@utoronto.ca"
export QBATCH_OPTIONS="--mail-type=ALL"
export QBATCH_SCRIPT_FOLDER=".qbatch/"  # Location to generate jobfiles for submission
export QBATCH_SHELL="/bin/sh"

# check of MAGeTbrain modules loaded and activated
if [[ ! $(module is-loaded cobralab/2019b) ]]
then
	module load cobralab/2019b
	source /project/m/mmack/software/MAGeTbrain/bin/activate
fi

# change to scratch directory
scratch_dir='/scratch/m/mmack/mmack/projects/hcp_maget'
cd $scratch_dir

# run MAGeTbrain
mb --save run -n --stage-voting-procs 1
