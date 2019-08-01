#!/bin/bash -l
#PBS -q debug
#PBS -A m1800
#PBS -N generate_material
#PBS -l mppwidth=1
#PBS -l walltime=0:30:00
#PBS -j oe
cd $PBS_O_WORKDIR
module load R
if [ $itime -gt 1 ]
then
   aprun -n 1 R CMD BATCH --slave "--args $itime" codes/assemble.simulation.R 
fi     
aprun -n 1 R CMD BATCH --slave "--args $itime" codes/update.ensemble.R 
