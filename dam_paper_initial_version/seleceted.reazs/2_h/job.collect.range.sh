#!/bin/bash -l
#SBATCH -A m1800
#SBATCH -p regular
#SBATCH --qos premium
#SBATCH --gres=craynetwork:3
#SBATCH -N 2
#SBATCH -t 04:00:00
#SBATCH -L SCRATCH  
#SBATCH -J find.range
#SBATCH -C haswell

module load R

nreaz=6
for ireaz in $(seq 1 $nreaz)
do
    srun -N 1 -n 1 --mem=40960 --gres=craynetwork:1 R CMD BATCH "--args ireaz=$ireaz" codes/find.range.R   R_range$ireaz.out &
done

wait

