#!/bin/bash -l

nreaz=6
ivari=2
for ireaz in $(seq 1 $nreaz)
do
     R CMD BATCH "--args ireaz=$ireaz ivari=$ivari" codes/col.data.R  R_col$ireaz"_"$ivari.out &
done
wait
