#!/bin/bash -l
#SBATCH -A m1800
#SBATCH -p regular
#SBATCH --qos premium
#SBATCH -N 1
#SBATCH -t 01:00:00
#SBATCH -L SCRATCH  
#SBATCH -J collect.obs
#SBATCH -C haswell

module load R

nreaz=6
for ireaz in $(seq 1 $nreaz)
do
    R CMD BATCH "--args ireaz=$ireaz" codes/collect.obs.R   R_obs$ireaz.out &
done

wait

