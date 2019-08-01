#!/bin/bash -l
#SBATCH -A m1800
#SBATCH -p debug
#SBATCH --qos premium
#SBATCH -N 8
#SBATCH -t 00:30:00
#SBATCH -L SCRATCH  
#SBATCH -J coll.1
#SBATCH -C haswell

module load R

srun -N 1 -n 1 R CMD BATCH codes/dam.stage.onetoone.o2.5.R &
srun -N 1 -n 1 R CMD BATCH codes/dam.stage.onetoone.no2.5.R &
srun -N 1 -n 1 R CMD BATCH codes/dam.stage.onetoone.no3.5.R &
srun -N 1 -n 1 R CMD BATCH codes/dam.stage.onetoone.co2.5.R &


srun -N 1 -n 1 R CMD BATCH codes/dam.stage.onetoone.o2.4.R &
srun -N 1 -n 1 R CMD BATCH codes/dam.stage.onetoone.no2.4.R &
srun -N 1 -n 1 R CMD BATCH codes/dam.stage.onetoone.no3.4.R &
srun -N 1 -n 1 R CMD BATCH codes/dam.stage.onetoone.co2.4.R &


wait
