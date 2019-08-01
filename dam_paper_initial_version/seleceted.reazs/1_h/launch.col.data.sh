#!/bin/bash -l

nreaz=6
ivari=15
ix=228
for ireaz in $(seq 1 $nreaz)
do
    R CMD BATCH "--args ireaz=$ireaz ivari=$ivari ix=$ix" codes/col.data.R  R_col$ireaz"_"$ivari.out &
done
wait
