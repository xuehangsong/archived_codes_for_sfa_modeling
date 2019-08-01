#!/bin/bash -l

nreaz=6
##for ireaz in $(seq 1 $nreaz)
for ireaz in 6
do
    R CMD BATCH "--args ireaz=$ireaz " codes/vec.data.R  R_vec$ireaz.out 
done
