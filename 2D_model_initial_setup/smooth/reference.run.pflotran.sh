#!/bin/bash
#PBS -q debug
#PBS -A m1800
#PBS -N reference.pflotran
#PBS -l mppwidth=1024
#PBS -l walltime=00:30:00
#PBS -j oe
module load R
cd $PBS_O_WORKDIR"/reference"
aprun -n 1024 ~/pflotran_latest -pflotranin 2duniform.in -realization_id 1
aprun -n 1 R CMD BATCH --slave  ./codes/reference.assemble.simulation.R 

