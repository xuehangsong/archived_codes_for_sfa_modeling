#!/bin/bash -l
source "dainput/parameter.sh"

###====Clear old results
rm -r results pflotran_mc obsdata figures template
mkdir results pflotran_mc obsdata figures template

###====Create folder for forecast
for ireaz in $(seq 1 $nreaz)
do 
    mkdir "$mc_dir"/"$ireaz"
done

###====Create thermal observation data
R CMD BATCH --slave  R/thermal.data.R

###====loop over different segments
for isegment in $(seq 1 $nsegment)
do

    ###First forecast
    iter=0
    export iter
    R CMD BATCH --slave "--args isegment=$isegment iter=$iter" R/prepare_input_files.R
    for ireaz in $(seq 1 $nreaz)
    do 
	cp template/* "$mc_dir"/"$ireaz"/
    done
    sh shell/mc.fuji.sh  >> /dev/null


    #iteration
    for iter in $(seq 1 $niter)
    do 
	export iter
	#### Update state.vector
	R CMD BATCH --slave "--args iter=$iter" R/assemble.simulation.R
	R CMD BATCH --slave "--args iter=$iter alpha=$niter" R/mda.update.R


	# #####Run Forecast
	R CMD BATCH --slave "--args isegment=$isegment iter=$iter" R/prepare_input_files.R
	sh shell/mc.fuji.sh  >> /dev/null
    done
    
    for ireaz in $(seq 1 $nreaz)
    do
	cp $mc_dir"/"$ireaz"/"$mc_name"-restart.chk"  $mc_dir"/"$ireaz"/restart.chk" 
    done

    mkdir "results/"$isegment
    find results/ -maxdepth 1 -type f -exec mv {} "results/"$isegment \; 

done
