#!/bin/bash -l
source "dainput/parameter.sh"
###First forecast

# rm -r results pflotran_mc obsdata figures template
# mkdir results pflotran_mc obsdata figures template
# R CMD BATCH --slave  R/thermal.data.R
# for ireaz in $(seq 1 $nreaz)
# do 
#     mkdir "$mc_dir"/"$ireaz"
# done



# iter=0
# isegment=1
# R CMD BATCH --slave "--args isegment=$isegment iter=$iter" R/prepare_input_files.R

# for ireaz in $(seq 1 $nreaz)
# do 
#     cp template/* "$mc_dir"/"$ireaz"/
# done
# sh shell/mc.fuji.sh  >> /dev/null



# iter=1
# isegment=1
# export iter
# R CMD BATCH --slave "--args iter=$iter" R/assemble.simulation.R
# R CMD BATCH --slave "--args iter=$iter alpha=$niter" R/mda.update.R


# iter=1
# isegment=1
# R CMD BATCH --slave "--args isegment=$isegment iter=$iter" R/prepare_input_files.R
# sh shell/mc.fuji.sh  >> /dev/null


# iter=2
# isegment=1
# export iter
# R CMD BATCH --slave "--args iter=$iter" R/assemble.simulation.R
# R CMD BATCH --slave "--args iter=$iter alpha=$niter" R/mda.update.R


# iter=2
# isegment=1
# R CMD BATCH --slave "--args isegment=$isegment iter=$iter" R/prepare_input_files.R
# sh shell/mc.fuji.sh  >> /dev/null

# iter=2
# isegment=1
# mkdir "results/"$isegment
# find results/* -maxdepth 1 -type f -exec mv {} "results/"$isegment \; 

iter=2
isegment=1
for ireaz in $(seq 1 $nreaz)
do
    a=$mc_dir"/"$ireaz"/"$mc_name*".chk"
    echo $a
    cp $mc_dir"/"$ireaz"/"$mc_name"-restart.chk"  $mc_dir"/"$ireaz"/restart.chk" 
done


# iter=0
# isegment=2
# R CMD BATCH --slave "--args isegment=$isegment iter=$iter" R/prepare_input_files.R

# iter=0
# isegment=2
# for ireaz in $(seq 1 $nreaz)
# do 
#     cp template/* "$mc_dir"/"$ireaz"/
# done


# sh shell/mc.fuji.sh  >> /dev/null
