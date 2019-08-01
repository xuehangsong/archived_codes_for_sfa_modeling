#!/bin/bash
#PBS -q debug
#PBS -A m1800
#PBS -N pflotran
#PBS -l mppwidth=1200
#PBS -l walltime=00:30:00
#PBS -j oe
cd $PBS_O_WORKDIR

for ireaz in $(seq 1 $nreaz)
do
    cd $PBS_O_WORKDIR/$ireaz
    aprun -n 120 ~/pflotran_latest -pflotranin 2duniform.in -realization_id 1 &
done

wait

