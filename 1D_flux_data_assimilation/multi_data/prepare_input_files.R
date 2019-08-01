rm(list=ls())
library(xts)
library(rhdf5)
source("dainput/parameter.sh")

args=(commandArgs(TRUE))
if(length(args)==0){
    print("no arguments supplied, use default value")
    isegment=1
    iter=0
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}
print(paste("isegment=",isegment))
print(paste("iter=",iter))

if (iter==0)
{

    ## Prepare the temperature boundary
    load("data/thermal.data.r")
    if (isegment==1)
    {
        thermal.data = thermal.data[0:restart.point[isegment]+1] ##isegment=1,will need spinup
    } else {
        thermal.data = thermal.data[restart.point[0:1+isegment]]
    }

    simu.time = as.numeric(difftime(index(thermal.data),index(thermal.data)[1],units="secs"))
    obs.index = which(abs(simu.time-tail(simu.time,1))<=time_window)
    obs_time = simu.time[obs.index]
    ntime  = length(obs.index)
    
    ###write the temperature boundary
    nthermistor = ncol(thermal.data)
    write.table(cbind(simu.time,thermal.data[,1]),file="template/temp_top.txt",
                col.names=FALSE,row.names=FALSE)

    write.table(cbind(simu.time,thermal.data[,nthermistor]),file="template/temp_bottom.txt",
                col.names=FALSE,row.names=FALSE)

    ## Prepre the observation file
    obs_true = as.matrix(thermal.data[obs.index,2:(nthermistor-1)])
    nobs = ncol(obs_true)
    obs_value = obs_true + array(c(rnorm(nobs,0,sqrt(obs_var))),dim(obs_true))
    save(thermal.data,obs_value,obs_true,nobs,obs_time,ntime,file="results/obs.data.r")


    ## Prepre the input file
    pflotranin = readLines("dainput/1dthermal.in")
    final_time_line = grep("FINAL_TIME",pflotranin)
    pflotranin[final_time_line] = paste("FINAL_TIME ",tail(simu.time,1),"s")
    observation_file_line = grep("OBSERVATION_FILE",pflotranin)+1
    pflotranin[observation_file_line] = paste("    TIMES s",paste(as.character(obs_time),collapse=" "))
    inital_temperature_line = grep("PRESSURE 101325",pflotranin)+1
    pflotranin[inital_temperature_line] = paste("  TEMPERATURE ",5)

    checkpoint.line = grep("CHECKPOINT",pflotranin)
    pflotranin[checkpoint.line] = paste("  CHECKPOINT")
    pflotranin[checkpoint.line+1] = paste("###    TIMES s",tail(simu.time,1))
    pflotranin[checkpoint.line+2] = paste("  /")
    
    if (isegment==1)
    {
        pflotranin[checkpoint.line+3] = paste("#  RESTART restart.chk 0.")
    } else {
        pflotranin[checkpoint.line+3] = paste("  RESTART restart.chk 0.")        
    }
    
    writeLines(pflotranin,"template/1dthermal.in")
    ####Generate initial flux
    if (isegment==1)
    {
        flux = array(1e-6,c(nreaz))
    } else {
        load(paste("results/",isegment-1,"/state.vector.",niter,sep=""))
        flux = state.vector
    }
    flux_sd = 1e-6
    flux = flux+c(rnorm(nreaz,0,flux_sd))

    state.vector = flux
    save(state.vector,file="results/state.vector.0")

} else {

    ## Prepare the obs file
    load("results/obs.data.r")
    obs_value = obs_true + array(c(rnorm(length(obs_true),0,sqrt(obs_var))),dim(obs_true))
    nobs = ncol(obs_true)
    save(thermal.data,obs_value,obs_true,nobs,obs_time,ntime,file="results/obs.data.r")

    ## Prepre flux
    load(file=paste("results/state.vector.",iter,sep=''))
    flux=state.vector
}
    


##Generate flux input
for (ireaz in 1:nreaz)
{
    fname = paste(mc_dir,"/",ireaz,"/","flux_top.txt",sep='')
    write.table(cbind(0,flux[ireaz]),file=fname,
            col.names=FALSE,row.names=FALSE)

    fname = paste(mc_dir,"/",ireaz,"/","flux_bottom.txt",sep='')
    write.table(cbind(0,-flux[ireaz]),file=fname,
            col.names=FALSE,row.names=FALSE)

}




## inital_temperature_line = grep("PRESSURE 101325",pflotranin)+2
## pflotranin[inital_temperature_line] = paste("  TEMPERATURE DATASET Temperature")

## dataset_line = grep("#===========================dataset=",pflotranin)
## pflotranin[dataset_line+1] = "DATASET Temperature"
## pflotranin[dataset_line+2] = "  FILENAME init_temp.h5"
## pflotranin[dataset_line+3] = "  HDF5_DATASET_NAME Temperature"
## pflotranin[dataset_line+4] = "END"

## fname = paste(mc_dir,"/",ireaz,"/",mc_name,".h5",sep='')
## h5.header = h5ls(fname)
## temp.index = tail(grep("Temperature",h5.header[[2]]),1)
## temp.value = h5read(fname,paste(h5.header[[1]][temp.index],"/",
##                                 h5.header[[2]][temp.index],sep=""))
## temp.value = as.numeric(unlist(temp.value))
## fname = paste(mc_dir,"/",ireaz,"/","init_temp.h5",sep='')
## file.remove(fname)
## h5createFile(fname)
## h5write(seq(1,length(temp.value)),fname,"Cell Ids",level=0)
## h5write(temp.value,fname,"Temperature",level=0)
## H5close()
