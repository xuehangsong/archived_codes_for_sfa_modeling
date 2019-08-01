#!/bin/bash -l
for i in $(seq 1 2)
do
# convert "figures/level"$i".jpg" "figures/flow.boundary"$i".jpg" +append 1.jpg
# convert "figures/spc"$i".jpg" "figures/spc.temp"$i".jpg" +append 2.jpg
# convert spc$i.jpg spc.temp$i.jpg +append 2.jpg
# convert spc$i.jpg spc.temp$i.jpg +append i.jpg
    convert "figures/level"$i".jpg"  "figures/spc"$i".jpg" "figures/spc.temp"$i".jpg" +append 1.jpg
    convert "figures/flow.boundary"$i".jpg" 1.jpg -append "figures/combined"$i".jpg"
done

