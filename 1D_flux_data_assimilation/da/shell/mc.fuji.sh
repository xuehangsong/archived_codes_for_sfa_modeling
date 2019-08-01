#!/bin/bash -l
source "dainput/parameter.sh"

cd $mc_dir

for ireaz in $(seq 1 16)
do 
    (cd $ireaz ; 
	~/pflotran -pflotranin $mc_in -output_prefix "pflotran_mcR"$ireaz ; 
	cd ../ ;
	echo $ireaz > $ireaz.txt) &
done


for ireaz in $(seq 17 $nreaz)
do 
    while [ $(ls -ltr *.txt | wc -l) -lt $(($ireaz-16)) ]
    do
	sleep 0.1
    done

    (cd $ireaz ; 
	~/pflotran -pflotranin $mc_in -output_prefix "pflotran_mcR"$ireaz ; 
	cd ../ ;
	echo $ireaz > $ireaz.txt) &

done

cd ../
