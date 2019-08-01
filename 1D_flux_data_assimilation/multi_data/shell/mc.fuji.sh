#!/bin/bash -l
source "dainput/parameter.sh"

cd $mc_dir
rm *.txt


for ireaz in $(seq 1 16)
do 
    (cd $ireaz ; 
	~/pflotran -pflotranin $mc_name".in" -screen_ouput off ; 
	cd ../ ;
	echo $ireaz > $ireaz.txt) &
done


for ireaz in $(seq 17 $nreaz)
do 
    while [ $(ls -ltr *.txt | wc -l) -lt $(($ireaz-16)) ]
    do
	sleep 0.01
    done

    (cd $ireaz ; 
	~/pflotran -pflotranin $mc_name".in"  -screen_ouput off ; 
	cd ../ ;
	echo $ireaz > $ireaz.txt) &

done

while [ ! -f $nreaz.txt ]
do
    sleep 1
done

cd ../
