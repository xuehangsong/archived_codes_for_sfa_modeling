#!/bin/bash -l
#SBATCH -A m1800
#SBATCH -p regular
#SBATCH --qos premium
#SBATCH --gres=craynetwork:3
#SBATCH -N 10
#SBATCH -t 10:00:00
#SBATCH -L SCRATCH  
#SBATCH -J merge.jpg
#SBATCH -C haswell

module load R

nvari=30
for ivari in $(seq 1 $nvari)
do
    export ivari
    srun -N 1 -n 1 --mem=40960 --gres=craynetwork:1 sh codes/merge.field.sh &
done

wait

