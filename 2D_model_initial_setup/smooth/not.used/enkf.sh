#!/bin/bash

#number of data assimilation step
ntime=2
nreaz=10

#reference
rm -r reference
cp -r seed reference
for ireaz in $(seq 1 $nreaz)
do
    rm -r $ireaz
    cp -r seed $ireaz
done    
mkdir figures
mkdir results
    
#create material grid for all realizations
R CMD BATCH --slave codes/create.material.grid.R

#reference
R CMD BATCH --slave codes/reference.generate.input.R
job_id=$(qsub ./codes/run.reference.sh)
echo $job_id > jobs.list

#intial
itime=0
job_id=$(qsub -v itime=$itime,ntime=$ntime,nreaz=$nreaz -W depend=afterok:$job_id ./codes/run.da.sh)
echo $job_id >> jobs.list

for itime in $(seq 1 $ntime)
do  
    #update
    job_id=$(qsub -v itime=$itime,ntime=$ntime,nreaz=$nreaz -W depend=afterok:$job_id ./codes/run.input.sh)
    echo $job_id >> jobs.list

    #Forecast
    job_id=$(qsub -v itime=$itime,ntime=$ntime,nreaz=$nreaz -W depend=afterok:$job_id ./codes/run.pflotran.sh)
    echo $job_id >> jobs.list

    #Forecast
    job_id=$(qsub -v itime=$itime,ntime=$ntime,nreaz=$nreaz -W depend=afterok:$job_id ./codes/run.da.sh)
    echo $job_id >> jobs.list
done
