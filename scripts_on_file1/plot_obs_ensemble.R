#This file is used for calculating RMSE and temporal moments of BTC at each well

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
paths = c('Tracer_Mar2011_UK3_KrigeFields')

npath = length(paths)

#prefix and extension of files
testvariable = 'Tracer'
true_col = 3
DataSet = 'Mar2011TT'
NormConc_True = 210.0  # Mar2011 test
NormTime_True = 1.0
y_convert = 1000.0/5.9234 #Mar2011 test, injected tracer
time_start = 0.25 #Mar2011 test using kriged boundary condition
#time_start = 191.25 #Mar2011 test using triangulated boundary condition


wells = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
'3-29','3-30','3-31','3-32','3-35','2-37')

max_time_upper = 800.0
min_time = 0.0

nwell = length(wells)
nt_obs = numeric(nwell)
t_obs = array(0,c(0,1))
BTC_obs = array(0,c(0,1))
err_cv = '30'
err_cv_val = 0.30
obs_ensemble_file = 'obs_ensemble_0to800h_Err30'
pwidth = 25
pheight = 25
for (ivar in 1:nwell)
{
       well_name = wells[ivar]
       true_file = paste('TrueData_',DataSet,'/Well_',well_name,'_',DataSet,'.txt',sep='')
       truedata = read.table(true_file,skip=1)
       true_t = truedata[,1]/NormTime_True #time units converted to hours
       trueBTC = truedata[,true_col]/NormConc_True
       if(length(grep('Tracer',testvariable)))
             trueBTC = (truedata[,true_col]-mean(truedata[which(truedata[,1]<0),true_col]))/NormConc_True
       trueBTC[which(trueBTC<0)] = 0
       id_t = which(true_t<=max_time_upper & true_t>=min_time)
       if(length(grep('3-24',well_name)))#well 3-24 may have intra-wellbore flow after 500 hours
		id_t = which(true_t<=500 & true_t>=min_time)
       true_t = true_t[id_t]
       trueBTC = trueBTC[id_t]
       nt_obs[ivar] = length(id_t)
       t_obs = c(t_obs,true_t)
       BTC_obs = c(BTC_obs,trueBTC)
}


for (ipath in 1:npath)
{
        path_prefix = paste(main_path,paths[ipath],'/',sep='')
	
        obs_ensemble = read.table(paste(main_path,paths[ipath],'/',obs_ensemble_file,'.txt',sep='')) 
	#plot the histogram
	jpeg(paste(main_path,paths[ipath],'_',obs_ensemble_file,'.jpg', sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
	par(mfrow=c(7,7))
	for(iplot in 5:5:240)
	{
		hist(obs_ensemble[,iplot])
		abline(v = BTC_obs[iplot],col='red')
	}
	dev.off()
}


