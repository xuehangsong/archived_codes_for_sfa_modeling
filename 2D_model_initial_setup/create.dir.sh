#!/bin/bash -l
nreaz=100
case=rate.doc

for ireaz in $(seq 1 $nreaz)
do
    rm -r $case"/"$ireaz
    cp -r $case/reference/ $case"/"$ireaz/
done    


#    rm -r $case"/"$ireaz
