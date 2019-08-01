#!/bin/bash -l
source "dainput/parameter.sh"

###Clear former results
rm -r results pflotran_mc obsdata figures template
mkdir results pflotran_mc obsdata figures template

###First forecast
rm -r "$mc_dir"/*
for ireaz in $(seq 1 $nreaz)
do 
    mkdir "$mc_dir"/"$ireaz"
done
R CMD BATCH --slave R/prepare_input_files.R
for ireaz in $(seq 1 $nreaz)
do 
    cp template/* "$mc_dir"/"$ireaz"/
done
sh shell/mc.fuji.sh  >> /dev/null
sleep 15


#iteration
for iter in $(seq 1 4)
do 
   export iter
   #### Update state.vector
   R CMD BATCH --slave "--args iter=$iter" R/assemble.simulation.R
   R CMD BATCH --slave "--args iter=$iter alpha=4" R/mda.update.R


   # #####Run Forecast
   rm -r "$mc_dir"/*
   for ireaz in $(seq 1 $nreaz)
   do 
       mkdir "$mc_dir"/"$ireaz"
   done
   R CMD BATCH --slave "--args iter=$iter" R/prepare_forecast.R
   for ireaz in $(seq 1 $nreaz)
   do 
       cp template/* "$mc_dir"/"$ireaz"/
   done
   sh shell/mc.fuji.sh  >> /dev/null
   sleep 15

done
