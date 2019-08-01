#!/bin/bash 
#SBATCH -A m1800
#SBATCH -p regular
#SBATCH --qos premium
#SBATCH --gres=craynetwork:3
#SBATCH -N 360
#SBATCH -t 02:00:00
#SBATCH -L SCRATCH  
#SBATCH -J p_field_pa
#SBATCH -C haswell



module load R

nreaz=6
nvari=30
years=$(seq 1 6)
for ireaz in $(seq 1 $nreaz)
do
    for ivari in $(seq 1 $nvari)
    do
	for iyear in $years
	do
            srun -N 1 -n 1 --mem=40960 --gres=craynetwork:1 R CMD BATCH  "--args ireaz=$ireaz ivari=$ivari iyear=$iyear" codes/plot.field.para.R   R_plotfield$ireaz"_"$ivari"_"$iyear.out &	
	done
    done
done
wait



