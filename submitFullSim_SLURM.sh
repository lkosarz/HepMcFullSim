#!/bin/bash

#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=FullSim
#SBATCH --account=PAS2524
#####SBATCH --mail.type=BEGIN,END,FAIL
#SBATCH --output=outputFull/stdout/%j.out
#SBATCH --error=outputFull/stderr/%j.err

mkdir $TMPDIR/data

####sbcast $HOME/eic/local/lib/jug_xl-nightly/ $TMPDIR/local/lib/jug_xl-nightly
sbcast $HOME/eic/eic-shell $TMPDIR/eic-shell
sbcast $SLURM_SUBMIT_DIR/runBatch_SLURM.sh $TMPDIR/runBatch_SLURM.sh
sbcast $SLURM_SUBMIT_DIR/data/files.list $TMPDIR/data/files.list

#mkdir $TMPDIR/output
#mkdir $TMPDIR/tree

module load singularity 
cd $TMPDIR
mkdir $TMPDIR/local
mkdir $TMPDIR/local/lib
#srun -n $SLURM_JOB_NUM_NODES --ntasks-per-node=1 cp -r $HOME/eic/local/lib/jug_xl-nightly $TMPDIR/local/lib/
srun -n $SLURM_JOB_NUM_NODES --ntasks-per-node=1 cp -r $HOME/eic/local/lib/jug_xl-testing.sif $TMPDIR/local/lib/
ls
ls $TMPDIR/local/
ls $TMPDIR/local/*
#./eic-shell -- ./runBatch_SLURM.sh $SLURM_ARRAY_TASK_ID
#./eic-shell -- ./runBatch_SLURM.sh
apptainer run $TMPDIR/local/lib/jug_xl-testing.sif -- ./runBatch_SLURM.sh ${SLURM_ARRAY_TASK_ID} $TMPDIR/data/files.list

cp $TMPDIR/outputFull/outputSim/output.edm4hep.root $SLURM_SUBMIT_DIR/outputFull/outputSim/output_${SLURM_ARRAY_TASK_ID}.edm4hep.root
cp $TMPDIR/outputFull/outputReco/output.edm4eic.root $SLURM_SUBMIT_DIR/outputFull/outputReco/output_${SLURM_ARRAY_TASK_ID}.edm4eic.root
#cp $TMPDIR/diffractiveDiJets_ep_18x275GeV.hepmc3 $SLURM_SUBMIT_DIR/outputFull/hepmc/diffractiveDiJets_ep_18x275GeV_${SLURM_ARRAY_TASK_ID}.hepmc3


#sgather -k $TMPDIR/output/outputSim/diffractiveDiJets_ep_18x275GeV_hist.root $SLURM_SUBMIT_DIR/output/outputSim/diffractiveDiJets_ep_18x275GeV_${SLURM_ARRAY_TASK_ID}_hist.root
#sgather -k $TMPDIR/output/outputReco/diffractiveDiJets_ep_18x275GeV_tree.root $SLURM_SUBMIT_DIR/output/outputReco/diffractiveDiJets_ep_18x275GeV_${SLURM_ARRAY_TASK_ID}_tree.root
## #sgather -k $TMPDIR/diffractiveDiJets_ep_18x275GeV.hepmc3 $SLURM_SUBMIT_DIR/output/hepmc/diffractiveDiJets_ep_18x275GeV_${SLURM_ARRAY_TASK_ID}.hepmc3

#sgather -k $TMPDIR/diffractiveDiJets_ep_18x275GeV_$SLURM_ARRAY_TASK_ID_hist.root $SLURM_SUBMIT_DIR/output/outputSim/diffractiveDiJets_ep_18x275GeV_$SLURM_ARRAY_TASK_ID_hist.root
#sgather -k $TMPDIR/diffractiveDiJets_ep_18x275GeV_$SLURM_ARRAY_TASK_ID_tree.root $SLURM_SUBMIT_DIR/output/outputReco/diffractiveDiJets_ep_18x275GeV_$SLURM_ARRAY_TASK_ID_tree.root
## #sgather -k $TMPDIR/diffractiveDiJets_ep_18x275GeV_$SLURM_ARRAY_TASK_ID.hepmc3 $SLURM_SUBMIT_DIR/output/hepmc/diffractiveDiJets_ep_18x275GeV_$SLURM_ARRAY_TASK_ID.hepmc3

#sbatch --array=1-200 --account=PAS2524 submitFullSim_SLURM.sh | tee submit.log