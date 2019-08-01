#!/bin/bash -l

nreaz=6

for ireaz in $(seq 1 $nreaz)
do
    mkdir $ireaz
    cp ../32_2_h/"$ireaz"/*txt $ireaz/
    cp ../32_2_h/"$ireaz"/2duniform.in $ireaz/
    cp ../32_2_h/"$ireaz"/cybernetic.dat $ireaz/
    cp ../Hanford_perm_2d_adaptive.h5  $ireaz/
    cp ../Alluvium_perm_2d_adaptive.h5 $ireaz/
    cp ../T3_Slice_material.h5  $ireaz/            
done    
	 
