#!/bin/bash -l

#SBATCH -A m1800
#SBATCH -q regular
#SBATCH -N 750
#SBATCH -t 48:00:00
#SBATCH -L SCRATCH  
#SBATCH -J regular


##--#SBATCH --qos premium
##  cd $SLURM_SUBMIT_DIR

module load python/3.6-anaconda-4.4

cd /global/cscratch1/sd/chenxy/Xuehang/npt/simu_base/
for i in $(seq 1 250)
do
    srun -N 1 -n 24 python3 /global/homes/x/xhsong/github/particle_tracking/pt_packages/pt_main.py $i &
done

cd /global/cscratch1/sd/renh686/Xuehang/npt/simu_homo/
for i in $(seq 1 250)
do
    srun -N 1 -n 24 python3 /global/homes/x/xhsong/github/particle_tracking/pt_packages/pt_main.py $i &
done

cd /global/cscratch1/sd/hd09/Xuehang/npt/simu_base_smooth/
for i in $(seq 1 250)
do
    srun -N 1 -n 24 python3 /global/homes/x/xhsong/github/particle_tracking/pt_packages/pt_main.py $i &
done

wait

