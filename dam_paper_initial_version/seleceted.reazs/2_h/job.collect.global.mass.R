#!/bin/bash -l
#SBATCH -A m1800
#SBATCH -p debug
#SBATCH --qos premium
#SBATCH --gres=craynetwork:3
#SBATCH -N 60
#SBATCH -t 00:30:00
#SBATCH -L SCRATCH  
#SBATCH -J global.mass
#SBATCH -C haswell

module load R
nreaz=6
nvari=30
for ireaz in $(seq 1 $nreaz)
do
    for ivari in $(seq 1 $nvari)
    do
	srun -N 1 -n 1 --mem=40960 --gres=craynetwork:1 R CMD BATCH "--args ireaz=$ireaz ivari=$ivari ix=178" codes/global.mass.data.R   R_global$ireaz"_"$ivari.out &
    done
done

wait
