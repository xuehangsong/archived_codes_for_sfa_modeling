#!/bin/bash 
#PBS -q debug
#PBS -A m1800
#PBS -N generate_material
#PBS -l mppwidth=100
#PBS -l walltime=0:30:00
#PBS -j oe
cd $PBS_O_WORKDIR
module load R
for ireaz in $(seq 1 $nreaz)
do
    aprun -n 1 R CMD BATCH --slave "--args $itime $ireaz" codes/generate.mc.input.R &    # material after update should be used for simulation of next steps    
done
wait
