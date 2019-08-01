#!/bin/bash -l

#SBATCH -A m1800
#SBATCH -p regular
#SBATCH --qos premium
#SBATCH -N 2
#SBATCH -t 48:00:00
#SBATCH -L SCRATCH  
#SBATCH -J 1_12
#SBATCH -C haswell

cd $SLURM_SUBMIT_DIR
BDIR=$PWD

for J in 1 2 
do 
cd $BDIR/$J 
srun -n 32 -N 1-1 ~/pflotran-cori -pflotranin 2duniform.in -realization_id 1 2>&1 > ${BDIR}/${J}.out & 
done 

wait

