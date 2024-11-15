#!/bin/bash

EICSHELL=./eic-shell

CONDOR_DIR=outputFull
OUT_DIR=outputSim
OUT_DIR_RECO=outputReco

mkdir ${CONDOR_DIR}
mkdir "${CONDOR_DIR}/${OUT_DIR}"
mkdir "${CONDOR_DIR}/${OUT_DIR_RECO}"

## Pass commands to eic-shell
## #${EICSHELL} <<EOF

## Set environment
source /opt/detector/epic-main/bin/thisepic.sh
#source /opt/detector/setup.sh
#source epic/install/setup.sh

#cd epic
#rm -rf build
#cmake -B build -S . -DCMAKE_INSTALL_PREFIX=install
#cmake --build build -j8 -- install
#cd ../

#export LOCAL_PREFIX=/gpfs/mnt/gpfs02/eic/lkosarzew/Calorimetry/Simulations/HepMcSim
#export LOCAL_PREFIX=.
#source ${LOCAL_PREFIX}/epic/install/bin/thisepic.sh
#source ${LOCAL_PREFIX}/epic/install/setup.sh
#export DETECTOR_PATH=${LOCAL_PREFIX}/epic/install/share/epic

## Export detector libraries
#export LD_LIBRARY_PATH=${LOCAL_PREFIX}/epic/install/lib:$LD_LIBRARY_PATH

## Set geometry and events to simulate
DETECTOR_CONFIG=epic_full
N_EVENTS=300

# Set seed based on date
SEED=$(date +%N)
#echo $SEED

ls
ls data

#NHEAD=$((${1}+1))
NHEAD=${1}

echo "head -${NHEAD} ${2} | tail -1"
head -${NHEAD} ${2} | tail -1


INFILE=`head -${NHEAD} ${2} | tail -1`
DDSIM_FILE=${CONDOR_DIR}/${OUT_DIR}/output.edm4hep.root
EICRECON_FILE=${CONDOR_DIR}/${OUT_DIR_RECO}/output.edm4eic.root

echo "infile"
echo ${INFILE}


#cd EICrecon
#rm -rf build
#cmake -B build -S . -DCMAKE_INSTALL_PREFIX=install
#cmake --build build
#cmake --install build
#cd ../

#source ${LOCAL_PREFIX}/EICrecon/install/bin/eicrecon-this.sh
#source ${LOCAL_PREFIX}/EICrecon/bin/eicrecon-this.sh


OPTIONS="--compactFile ${DETECTOR_PATH}/${DETECTOR_CONFIG}.xml --numberOfEvents ${N_EVENTS} --random.seed ${SEED} --inputFiles ${INFILE} --outputFile ${DDSIM_FILE}"

echo $OPTIONS
npsim $OPTIONS

eicrecon $DDSIM_FILE -Ppodio:output_file=${EICRECON_FILE} -Pjana:nevents=${N_EVENTS}
	
exit

## #EOF
