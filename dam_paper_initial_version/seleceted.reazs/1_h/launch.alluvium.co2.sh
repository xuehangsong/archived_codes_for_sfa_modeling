#!/bin/bash -l

reazs=$(seq 2 6)
years=$(seq 2 6)
years=6
for iyear in $years
do
    for ireaz in $reazs
    do
	R CMD BATCH "--args ireaz=$ireaz iyear=$iyear" codes/alluvium.onetoone.co2.R  R_allu$ireaz"_"$iyear.out 
    done
done    
