#!/bin/bash -l
source "vhg_codes/parameter.sh"
rm -r $mc_dir
mkdir $mc_dir
for ireaz in $(seq 1 $nreaz)
do
    mkdir $mc_dir$ireaz
    cp $output_dir/*in $output_dir/*dat $mc_dir$ireaz
done

