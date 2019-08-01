rm(list=ls())
library(xts)
source("dainput/parameter.sh")

## Prepare the temperature boundary
load("dainput/filtered.thermal.r") 
start_time = 1+(ntime-overlap-spin_up)*(da_index-1)
end_time = start_time+ntime-1

thermal.data = thermal.data[start_time:end_time,]
obs_time = as.numeric(difftime(index(thermal.data),index(thermal.data)[1],units="secs"))
nthermistor = ncol(thermal.data)
write.table(cbind(obs_time,thermal.data[,1]),file="template/temp_top.txt",
            col.names=FALSE,row.names=FALSE)

write.table(cbind(obs_time,thermal.data[,nthermistor]),file="template/temp_bottom.txt",
            col.names=FALSE,row.names=FALSE)

## Prepre the observation file
obs_true = as.matrix(thermal.data[,2:(nthermistor-1)])
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

##Generate initial flux
diff_level = level.data[,"river"] -level.data[,"inland"]
diff_level_norm= diff_level/max(abs(diff_level),na.rm=TRUE)
diff_level_norm = diff_level_norm[start_time:end_time]
flux = array(0,c(nreaz,ntime))
for (itime in 1:ntime)
{
##    flux_sd = abs(diff_level_norm)*0.0000005
    flux_sd = rep(0.0000002,ntime)
    flux[,itime] = diff_level_norm[itime]*1e-6+c(rnorm(nreaz,0,flux_sd[itime]))
}
#plot(index(diff_level_norm),diff_level_norm,type='l')
##plot(1:ntime,flux[2,],type="l")

state.vector = flux
save(state.vector,file="results/state.vector.0")



for (ireaz in 1:nreaz)
{
    fname = paste(mc_dir,"/",ireaz,"/","flux_top.txt",sep='')
    write.table(cbind(obs_time,flux[ireaz,]),file=fname,
            col.names=FALSE,row.names=FALSE)

    fname = paste(mc_dir,"/",ireaz,"/","flux_bottom.txt",sep='')
    write.table(cbind(obs_time,-flux[ireaz,]),file=fname,
            col.names=FALSE,row.names=FALSE)

}
