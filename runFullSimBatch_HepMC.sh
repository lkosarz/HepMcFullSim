#!/bin/bash


EICSHELL=./eic-shell


CONDOR_DIR=condorFull
OUT_DIR=outputSim
OUT_DIR_RECO=outputReco

mkdir ${CONDOR_DIR}
mkdir "${CONDOR_DIR}/${OUT_DIR}"

## Pass commands to eic-shell
#${EICSHELL} <<EOF

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
N_EVENTS=10000000

# Set seed based on date
SEED=$(date +%N)
#echo $SEED

# Split lists
LISTNAME="files_${5}_${4}.list"
NHEAD=$(($((${4}+1))*${3}))

echo "head -${NHEAD} ${1} | tail -${3} | tee ${LISTNAME}"
head -${NHEAD} ${1} | tail -${3} | tee ${LISTNAME}

echo ${LISTNAME}
cat ${LISTNAME}

INFILE=head -${3} ${LISTNAME}
DDSIM_FILE=${CONDOR_DIR}/${OUT_DIR}/${2}.edm4hep.root
EICRECON_FILE=${CONDOR_DIR}/${OUT_DIR_RECO}/${2}.edm4eic.root


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

eicrecon $DDSIM_FILE -Ppodio:output_file=${EICRECON_FILE}
	
exit

#EOF
