#!/bin/bash -l
#SBATCH -A m1800
#SBATCH -q premium
#SBATCH --gres=craynetwork:4
#SBATCH -N 1
#SBATCH -t 2:00:00
#SBATCH -L SCRATCH  
#SBATCH -J pre
#SBATCH -C haswell

nreaz=300
nfacies=3
iter=0
ncore=32

###prior data is used for generated initial
hard_data="dainput/prior_data.eas"  
gameas_in_x="dainput/gameas_x.par"               
gameas_in_y="dainput/gameas_y.par"              
gameas_in_z="dainput/gameas_z.par"              
mcmod_in="dainput/mcmod.par"                    
tsim_in="dainput/tsim.par"                      
mc_dir="pflotran_mc"


rm outputs/*
rm tprogs/*
rm results/*
rm figures/*

R CMD BATCH  --no-save codes/well_screen.R
R CMD BATCH  --no-save codes/process_lithofacies.R  
R CMD BATCH  --no-save codes/tracer_data.R
./exe/gameas $gameas_in_x $hard_data
./exe/gameas $gameas_in_y $hard_data
./exe/gameas $gameas_in_z $hard_data
R CMD BATCH  --no-save codes/prior_transition_prob.R 
./exe/mcmod $mcmod_in "tprogs/tp_x.eas"
##run tsim 
for ireaz in $(seq 1 $ncore)
do
    ("./exe/tsim_multi" $tsim_in $mcmod_in $hard_data $(($ireaz+2000)) "tprogs/"$ireaz".r" ;
     touch outputs/tsim_$ireaz.txt)  &
done
for ireaz in $(seq $(($ncore+1)) $nreaz)
do 
    while [ $(ls -ltr outputs/tsim_*.txt | wc -l) -lt $(($ireaz-$ncore)) ]
    do
	sleep 0.1
    done
    ("./exe/tsim_multi" $tsim_in $mcmod_in $hard_data $(($ireaz+2000)) "tprogs/"$ireaz".r" ;
     touch outputs/tsim_$ireaz.txt)  &
done
while [ $(ls -ltr outputs/tsim_*.txt | wc -l) -lt $ireaz ]
do
    sleep 0.1
done
wait

R CMD BATCH  --no-save "--args nreaz=$nreaz" codes/init_perm.R
R CMD BATCH  --no-save "--args iter=$iter nreaz=$nreaz nfacies=$nfacies"  codes/tprogs_to_material.R
R CMD BATCH  --no-save "--args iter=$iter nreaz=$nreaz nfacies=$nfacies"  codes/tprogs_to_state.R 

mv tprogs/mcmod.dbg "./results/mcmod."$iter
mv tprogs/tp_x.eas "./results/tp_x."$iter
mv tprogs/tp_y.eas "./results/tp_y."$iter
mv tprogs/tp_z.eas "./results/tp_z."$iter
mv tprogs/tp_x_m.eas "./results/tp_x_m."$iter
mv tprogs/tp_y_m.eas "./results/tp_y_m."$iter
mv tprogs/tp_z_m.eas "./results/tp_z_m."$iter

wait
