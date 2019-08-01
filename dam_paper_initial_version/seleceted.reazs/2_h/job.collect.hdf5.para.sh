#!/bin/bash -l
#SBATCH -A m1800
#SBATCH -p regular
#SBATCH --qos premium
#SBATCH --gres=craynetwork:3
#SBATCH -N 36
#SBATCH -t 2:00:00
#SBATCH -L SCRATCH  
#SBATCH -J coll.2
#SBATCH -C haswell

module load R

nreaz=6
npara=18
for ireaz in $(seq 1 $nreaz)
do
    for ipara in $(seq 1 $npara)
    do
	srun -N 1 -n 1 --mem=40960 --gres=craynetwork:1 R CMD BATCH "--args ireaz=$ireaz ipara=$ipara" codes/collect.hdf5.para.R   R_field$ireaz"_"$ipara.out &
    done
done

wait

