#!/bin/bash 
#SBATCH -A m1800
#SBATCH --qos premium
#SBATCH -p regular
#SBATCH --gres=craynetwork:3
#SBATCH -N 50
#SBATCH -t 00:45:00
#SBATCH -L SCRATCH  
#SBATCH -J year2_5
#SBATCH -C haswell



module load R

nreaz=6
nvari=30
years=$(seq 2 6)
for ireaz in 5
do
    for ivari in $(seq 1 $nvari)
    do
	for iyear in $years
	do
            srun -N 1 -n 1 --mem=40960 --gres=craynetwork:1 R CMD BATCH  "--args ireaz=$ireaz ivari=$ivari iyear=$iyear" codes/output.time.hdf5.R   R_hdf$ireaz"_"$ivari"_"$iyear".out" &
	done
    done
done

wait


####SBATCH --qos premium
