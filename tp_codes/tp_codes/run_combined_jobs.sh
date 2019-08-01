#!/bin/bash -l
#SBATCH -A m1800
#SBATCH -q premium
#SBATCH -N 60
#SBATCH -t 9:00:00
#SBATCH -L SCRATCH  
#SBATCH -J collect.obs
#SBATCH -C haswell

module load R/3.3.2
cd $SLURM_SUBMIT_DIR

nnode=60
export nnode

ncore=32
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
        srun -N 1 -n $ncore  ~/pflotran-cori -pflotranin pflotran.in \
             -output_prefix "RR"$ireaz -realization_id $ireaz -screen_output off &
	sleep 0.1        
    done

    for ireaz in $(seq $nnode $nreaz)
    do
        while [ $(ls -ltr *restart* | wc -l) -lt $(($ireaz-$nnode+1)) ]        
        do
	    sleep 0.1
        done
        srun -N 1 -n $ncore  ~/pflotran-cori -pflotranin pflotran.in \
             -output_prefix "RR"$ireaz -realization_id $ireaz -screen_output off &
    done
    cd  "../"        
    wait

    
    ##collect observation results (use mulitple node, 4 task per node)
    for ireaz in $(seq 1 $nreaz)
    do
        srun -N 1 -n 1 \
             R CMD BATCH  --no-save "--args ireaz=$ireaz" \
             codes/assemble_simulation.R outputs/R_obs$ireaz.out &
	sleep 0.1        
    done
    wait

    ##update state.vector (use single node, mulitple cores)
    R CMD BATCH  --no-save "--args iter=$iter nreaz=$nreaz" codes/combine_simulation.R
    R CMD BATCH  --no-save "--args iter=$iter alpha=$niter"  codes/mda_update.R

    R CMD BATCH  --no-save "--args iter=$iter nreaz=$nreaz nfacies=$nfacies"  codes/produce_condition_data.R 
    #---------------------------------------
    hard_data="dainput/all_data.eas"  ###updated_prior
    gameas_in_x="dainput/gameas_x.par"               
    gameas_in_y="dainput/gameas_y.par"              
    gameas_in_z="dainput/gameas_z.par"              
    mcmod_in="dainput/mcmod.par"                    
    tsim_in="dainput/tsim.par"                      
    mc_dir="pflotran_mc"

    rm outputs/*
    rm tprogs/*
    ./exe/gameas $gameas_in_x $hard_data
    ./exe/gameas $gameas_in_y $hard_data
    ./exe/gameas $gameas_in_z $hard_data
    R CMD BATCH  --no-save codes/da_transition_prob.R     
    ./exe/mcmod $mcmod_in "tprogs/tp_x.eas"    

    for ireaz in $(seq 1 $nnode)
    do
        ("./exe/tsim_multi" $tsim_in $mcmod_in $hard_data $ireaz "tprogs/"$ireaz".r" ;
         touch outputs/tsim_$ireaz.txt)  &
	sleep 0.1        
    done

    for ireaz in $(seq $(($nnode+1)) $nreaz)
    do 
        while [ $(ls -ltr outputs/tsim_*.txt | wc -l) -lt $(($ireaz-$nnode)) ]
        do
	    sleep 0.1
        done
        ("./exe/tsim_multi" $tsim_in $mcmod_in $hard_data $ireaz "tprogs/"$ireaz".r" ;
         touch outputs/tsim_$ireaz.txt)  &
    done
    
    while [ $(ls -ltr outputs/tsim_*.txt | wc -l) -lt $ireaz ]
    do
	sleep 0.1
    done
    wait
    mkdir "pflotran_mc/mc"$(($iter-1))
    mv pflotran_mc/unit* pflotran_mc/mc_material.h5 pflotran_mc/R* "pflotran_mc/mc"$(($iter-1))"/"

    
    ####need revsion on this scripts
    R CMD BATCH  --no-save "--args iter=$iter nreaz=$nreaz nfacies=$nfacies"  codes/tprogs_to_material.R
    R CMD BATCH  --no-save "--args iter=$iter nreaz=$nreaz nfacies=$nfacies"  codes/tprogs_to_state.R &

    mv tprogs/mcmod.dbg "./results/mcmod."$iter
    mv tprogs/tp_x.eas "./results/tp_x."$iter
    mv tprogs/tp_y.eas "./results/tp_y."$iter
    mv tprogs/tp_z.eas "./results/tp_z."$iter
    mv tprogs/tp_x_m.eas "./results/tp_x_m."$iter
    mv tprogs/tp_y_m.eas "./results/tp_y_m."$iter
    mv tprogs/tp_z_m.eas "./results/tp_z_m."$iter
done
wait
  
