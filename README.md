# HepMcFullSim

Basic scripts (Condor and SLURM) for running full dd4hep simulation and reconstruction with EICrecon with HepMc file input.

### Prepare directories

```Sh
./mkdirs.sh
```

## SLURM scripts

### Submit jobs

Useful at OSC and JLab (to be tested at JLab)

```Sh
sbatch --array=1-<Njobs> submitFullSim_SLURM.sh | tee submit.log
```

### Optional container selection

Download the container image first. Then specify it in the script with these 2 lines:

```Sh
srun -n $SLURM_JOB_NUM_NODES --ntasks-per-node=1 cp -r $HOME/eic/local/lib/jug_xl-testing.sif $TMPDIR/local/lib/
apptainer run $TMPDIR/local/lib/jug_xl-testing.sif -- ./runBatch_SLURM.sh ${SLURM_ARRAY_TASK_ID} $TMPDIR/data/files.list
```

## Condor scripts

###Submit scripts at BNL SDCC:

Make sure the file paths in the file list contain this prefix:

```Sh
s3https://dtn01.sdcc.bnl.gov:9000/
```

run to submit jobs:

```Sh
condor_submit submitFullSim_HepMC.job | tee sim.log
```

### Selecting a specific container image version

Replace the line in condor job description file: 

```Sh
+SingularityImage="/cvmfs/singularity.opensciencegrid.org/eicweb/eic_xl:nightly"
```

with the following to select version eg. `23.11-stable`:

```Sh
+SingularityImage="/cvmfs/singularity.opensciencegrid.org/eicweb/jug_xl:23.11-stable"
```

To list available image versions:

```Sh
ls /cvmfs/singularity.opensciencegrid.org/eicweb/
```

## Get container image for SLURM jobs

Get ``.sif`` Singularity Image Format (SIF) file  from docker repository

```Sh
singularity pull docker://eicweb/eic_xl:24.11.1-stable
```

Modify scripts to point to this file

### Access S3 files

Create ``S3setup.sh`` file with:

```Sh
export S3_ACCESS_KEY=<login>
export S3_SECRET_KEY=<password>
```

And use the list version of scripts ``*_list.job``.

## More info

[https://htcondor.readthedocs.io/en/lts/admin-manual/singularity-support.html](https://htcondor.readthedocs.io/en/lts/admin-manual/singularity-support.html)

[https://www.osc.edu/supercomputing/batch-processing-at-osc/job-scripts](https://www.osc.edu/supercomputing/batch-processing-at-osc/job-scripts)

