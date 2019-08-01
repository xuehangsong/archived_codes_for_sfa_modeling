
#This file is used for calculating RMSE and temporal moments of BTC at each well

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
#paths = c('Tracer_Mar2011_UK_Binary_Modal','Tracer_Mar2011_UK_Binary_Rel5','Tracer_Mar2011_UK_Binary_Rel10')
baseline_path = 'Tracer_Mar2011_UK_KrigeFields'
Comp_paths = c('Tracer_Mar2011_UK_KrigeFields_Iter1')
#Comp_paths = c('Tracer_Mar2011_UK_Inv_NewHR','Tracer_Mar2011_UK_Binary_Rel5','Tracer_Mar2011_plane_Inv')
npath = length(Comp_paths)
#fields = c(1:40000)
#fields_comp = c(2001:2200,10801:11000,30001:33200)
fields_comp = c(1:200)
#fields_comp = c(2001:2200,10801:11000)
nfields = length(fields_comp)     # number of random fields

#wells_all = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
#'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
#'3-29','3-30','3-31','3-32','3-35','2-34','2-37')
wells_comp = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-25','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')

#nwell_all = length(wells_all)
newll_comp = length(wells_comp)
#wells_idx = match(wells_comp,wells_all)
time_upper_list = c(200,500,1000)
n_time = length(time_upper_list)
max_time_upper = max(time_upper_list)

#load the squared errors for baseline case
# the data package include fields (not for the baseline case),SE_all,M0_all,M1_all,nt_obs,wells,time_upper_list,trueM0,trueM1
fields_baseline = 1:200
fields_idx = match(fields_comp,fields_baseline)
if(sum(is.na(fields_idx))>0) stop('not all the fields for comparison found in the baseline database!')

 
load(paste(baseline_path,'/SE_n_TempMom_upto1000hr.Rdata',sep=''))
wells_idx_base = match(wells_comp,wells)
if(sum(is.na(wells_idx_base))>0) stop('Not all the wells for comparison found in the baseline database!')
SSE_baseline = apply(SE_all[fields_idx,wells_idx_base,],c(1,3),sum)

#sum of square errors from the comparison cases
SSE_comp = array(0,c(nfields,n_time,npath))
for (ipath in 1:npath)
{
	load(paste(Comp_paths[ipath],'/SE_n_TempMom_upto1000hr.Rdata',sep=''))
	fields_idx = match(fields_comp,fields)
	wells_idx = match(wells_comp,wells)
	SSE_comp[,,ipath] = apply(SE_all[fields_idx,wells_idx,],c(1,3),sum)
}

#generate plots
jpeg('Compare_Tracer_Mar2011_SE_KrigeFields_Iter1.jpg',width = 5*n_time, height = 5*npath,units="in",res=250,quality=100)
par(mfrow=c(npath,n_time))
for (ipath in 1:npath)
{
	for (itime in 1:n_time)
	{
		plot_low = min(min(SSE_baseline[,itime]),min(SSE_comp[,itime,ipath]))
		plot_upp = max(max(SSE_baseline[,itime]),max(SSE_comp[,itime,ipath]))
		plot_lim = c(plot_low,plot_upp)
		plot(SSE_baseline[,itime],SSE_comp[,itime,ipath],pch=1,col='red',main = paste('Sum of Errors up to ',time_upper_list[itime],'hr',sep=''),xlab = baseline_path,ylab = Comp_paths[ipath],xlim = plot_lim,ylim = plot_lim)
		lines(plot_lim,plot_lim,col='black')
	}
}
dev.off()

