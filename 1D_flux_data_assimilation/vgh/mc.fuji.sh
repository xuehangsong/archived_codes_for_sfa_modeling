#!/bin/bash -l
source "vhg_codes/parameter.sh"

cd $mc_dir
rm *.txt


for ireaz in $(seq 1 $ncore)
do 
    (cd $ireaz ; 
	~/pflotran -pflotranin $mc_name".in" -screen_output off ; 
	cd ../ ;
	echo $ireaz > $ireaz.txt) &
done


for ireaz in $(seq $(($ncore+1)) $nreaz)
do 
    while [ $(ls -ltr *.txt | wc -l) -lt $(($ireaz-$ncore)) ]
    do
	sleep 0.01
    done

    (cd $ireaz ; 
	~/pflotran -pflotranin $mc_name".in"  -screen_output off ; 
	cd ../ ;
	echo $ireaz > $ireaz.txt) &

done

while [ ! -f $nreaz.txt ]
do
    sleep 1
done

cd ../
