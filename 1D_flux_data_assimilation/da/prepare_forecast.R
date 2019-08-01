rm(list=ls())
library(xts)
source("dainput/parameter.sh")

args=(commandArgs(TRUE))
if(length(args)==0){
    print("no arguments supplied, use default value")
    iter=1
}else{
    for(i in 1:length(args)){
        eval(parse(text=args[[i]]))
    }
}
print(paste("iter=",iter))

## Prepre the input file
load("results/obs.data.r")
obs_value = obs_true + array(c(rnorm(length(obs_true),0,sqrt(obs_var))),dim(obs_true))
nobs = ncol(obs_true)
save(thermal.data,obs_value,obs_true,nobs,obs_time,file="results/obs.data.r")

## Prepre the input file
pflotranin = readLines("dainput/1dthermal.in")
final_time_line = grep("FINAL_TIME",pflotranin)
pflotranin[final_time_line] = paste("FINAL_TIME ",obs_time[ntime],"s")
inital_temperature_line = grep("  PRESSURE 101325.d0",pflotranin)+1
pflotranin[inital_temperature_line] = paste("  TEMPERATURE ",rowMeans(thermal.data[1,]))
writeLines(pflotranin,"template/1dthermal.in")


##Generate file
load(paste("results/state.vector.",iter,sep=""))
flux=state.vector
for (ireaz in 1:nreaz)
{
    fname = paste(mc_dir,"/",ireaz,"/","flux_top.txt",sep='')
    write.table(cbind(obs_time,flux[ireaz,]),file=fname,
            col.names=FALSE,row.names=FALSE)

    fname = paste(mc_dir,"/",ireaz,"/","flux_bottom.txt",sep='')
    write.table(cbind(obs_time,-flux[ireaz,]),file=fname,
            col.names=FALSE,row.names=FALSE)

}
