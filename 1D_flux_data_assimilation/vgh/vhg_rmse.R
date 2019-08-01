rm(list=ls())


source("./vhg_codes/parameter.sh")
load("vhg_case/results/vhg_data.r")
load(paste(output_dir,"simu.ensemble.r",sep=''))

obs1 = as.numeric(thermistor.output[,"-0.04"])
obs2 = as.numeric(thermistor.output[,"-0.24"])

vhg_square = array(NA,c(ntime,nobs,nreaz))
vhg_square[,1,] = replicate(nreaz,obs1)
vhg_square[,2,] = replicate(nreaz,obs2)
vhg_square = (vhg_square-simu.ensemble)^2
    
rmse = array(NA,c(nreaz,3))
rmse[,1] = colMeans(vhg_square[,1,])
rmse[,2] = colMeans(vhg_square[,2,])
rmse[,3] = (rmse[,1]+rmse[,1])/2
rmse = rmse^0.5
colnames(rmse) = c("-0.04 m","-0.24 m","all")

color_rmse = c("green","orange","black")
plot(hydro_cond,rmse[,1],col="red")
for (irmse in 1:3)
{
    lines(hydro_cond,rmse[,irmse],col=color_rmse[irmse])

}
