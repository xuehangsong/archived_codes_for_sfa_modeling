#!/bin/bash -l
# for i in $(seq 0 438)
# do
#     echo $i
#done

convert -delay 1 -quality 100 figures/velocity/vec.*jpg figures/vec.gif
