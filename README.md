# ePICcondorScripts

Basic scripts for running condor simulation and reconstruction jobs. To run do following steps.

## Prepare directories

```Sh
./mkdirCondor.sh
```

## Submit simulation jobs

```Sh
condor_submit submitSim.job | tee sim.log
```

## Submit reconstruction jobs (remember to adjust input!)

```Sh
condor_submit submitReco.job | tee reco.log
```

## Selecting a specific container image version

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

## More info

[https://htcondor.readthedocs.io/en/lts/admin-manual/singularity-support.html](https://htcondor.readthedocs.io/en/lts/admin-manual/singularity-support.html)

