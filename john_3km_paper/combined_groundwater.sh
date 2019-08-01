#!/bin/bash -l
# for i in $(seq 0 438)
# do
#     echo $i
#done

convert -delay 1 -quality 100 figures/groundwater_2/groundwater.*jpg figures/groundwater_2.gif
