#!/bin/bash -l

for ipoint in $(seq 0 71)
do
echo $(printf "%04d" $ipoint)

convert \
"/home/song884/john_paper/figures/2013_river/wl"$ipoint".jpg" \
"/files1/song884/bpt/new_simulation_13_5/pathlines/45960/sections/45960_"$ipoint".jpg" \
-append  \
"/files1/song884/bpt/new_simulation_13_5/pathlines/animation_combined/"$(printf "%04d" $ipoint)".jpg" 
done


# ipoint=71
# convert \
# "/home/song884/john_paper/figures/2013_river/wl"$ipoint".jpg" \
# "/files1/song884/bpt/new_simulation_13_5/46776/.jpg" \
# -append  \
# "/files1/song884/bpt/new_simulation_13_5/pathlines/3line47520.jpg" 


# ipoint=71
# convert \
# "/home/song884/john_paper/figures/2013_river/wl"$ipoint".jpg" \
# "/files1/song884/bpt/new_simulation_13_5/pathlines/47520_full.jpg" \
# -append  \
# "/files1/song884/bpt/new_simulation_13_5/pathlines/3line47520_full.jpg" 

