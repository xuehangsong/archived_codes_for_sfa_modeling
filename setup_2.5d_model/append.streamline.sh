#!/bin/bash -l
###for i in $(seq 1 1345)
for i in $(seq 1 400)
do
    echo $i

    convert "figures/2d.0."$i".png" "figures/2d.1."$i".png" -append 1.jpg
    convert "figures/3d_streamline"$i".png" 1.jpg +append 1.jpg
    convert "figures/flow.boundary2."$(($i+1))".jpg"  1.jpg  -append "figures/combined.streamline"$i".jpg"
done

