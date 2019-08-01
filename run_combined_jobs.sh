#!/bin/bash -l
#SBATCH -A m1800
#SBATCH -q premium
#SBATCH -N 80
#SBATCH -t 12:00:00
#SBATCH -L SCRATCH  
#SBATCH -J enkf_sythetic

module load R/3.3.2
cd $SLURM_SUBMIT_DIR

nnode=80
export nnode

ncore=24
export ncore

###initial realization and observations was generated seperately
###this script only run the prediction and data assimilation
niter=4
export niter

nreaz=300
export nreaz

nfacies=3
export nfacies

##loop over iteration
for iter in $(seq 1 $(($niter+1)))            
do
    export iter
    rm outputs/*

    ###prediction
    cd  "./pflotran_mc/"
    for ireaz in $(seq 1 $(($nnode-1)))
    do
        srun -N 1 -n $ncore  ~/pflotran-edison -pflotranin pflotran.in \
             -output_prefix "RR"$ireaz -realization_id $ireaz -screen_output off &
	sleep 0.1        
    done

    for ireaz in $(seq $nnode $nreaz)
    do 
        while [ $(ls -ltr *restart* | wc -l) -lt $(($ireaz-$nnode+1)) ]
        do
	    sleep 0.1
        done
        srun -N 1 -n $ncore  ~/pflotran-edison -pflotranin pflotran.in \
             -output_prefix "RR"$ireaz -realization_id $ireaz -screen_output off &
    done
    cd  "../"        
    wait

    

    for ireaz in $(seq 1 $nreaz)
    do
        srun -N 1 -n 1 \
             R CMD BATCH  --no-save "--args ireaz=$ireaz" \
             codes/assemble_simulation.R outputs/R_obs$ireaz.out &
        sleep 0.1        
    done
    wait
    mkdir "pflotran_mc/mc"$(($iter-1))
    mv pflotran_mc/unit* pflotran_mc/mc_material.h5 pflotran_mc/R* "pflotran_mc/mc"$(($iter-1))"/" 

    
    ##update state.vector (use single node, mulitple cores)
    R CMD BATCH  --no-save "--args iter=$iter nreaz=$nreaz" codes/combine_simulation.R
    R CMD BATCH  --no-save "--args iter=$iter alpha=$niter"  codes/mda_update.R
    R CMD BATCH  --no-save "--args iter=$iter nreaz=$nreaz nfacies=$nfacies"  codes/state_to_material.R
done
