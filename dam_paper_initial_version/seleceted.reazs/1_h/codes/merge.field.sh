#!/bin/bash 
IFS=$'\n'

cd 1/
jpgfile=$(ls *$ivari.jpg)
cd ../

for ijpg in $jpgfile
do
    echo "$ijpg"
    convert 1/"$ijpg" 2/"$ijpg" 3/"$ijpg" 4/"$ijpg" 5/"$ijpg" -append merged/"$ijpg"

done
