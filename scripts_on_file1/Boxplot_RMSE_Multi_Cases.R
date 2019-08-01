
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
#paths = c('Tracer_Mar2011_UK_Binary_Modal','Tracer_Mar2011_UK_Binary_Rel5','Tracer_Mar2011_UK_Binary_Rel10')
paths = c('Tracer_Mar2011_UK3_KrigeFields_Inj5','Tracer_Mar2011_Iter1','Tracer_Mar2011_Iter2','Tracer_Mar2011_Iter3','Tracer_Mar2011_Iter4','Tracer_Mar2011_Iter5','Tracer_Mar2011_Iter6','Tracer_Mar2011_Iter7','Tracer_Mar2011_Iter8')
npath = length(paths)
plot_titles = c('Prior','After Assimilating Data between 0 and 25 h','After Assimilating Data between 25 and 50 h',
		'After Assimilating Data between 50 and 75 h','After Assimilating Data between 75 and 100 h',
		'After Assimilating Data between 100 and 125 h','After Assimilating Data between 125 and 150 h',
		'After Assimilating Data between 150 and 175 h','After Assimilating Data between 175 and 200 h')
pwidth = 15 
pheight = 5
separate_plots = T
linwd = 2.5
tick_size = 15
fields = c(1:600)
nfields = length(fields)     # number of random fields
testvariable = 'Tracer'
wells_all = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')

well_set1 = c('2-07','2-11','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-21','2-23','2-24','2-26','2-27','2-29','2-30','2-37','3-25','3-28','3-29','3-30','3-32','3-35')
wells = well_set1
wells_idx = match(wells,wells_all)
nwell = length(wells_idx)
time_upper = 800
data_ext = paste('to',time_upper,'hr.Rdata',sep="")
if(!separate_plots)
{
	jpeg(plot_file_name, width = pwidth, height = pheight,units="in",res=200,quality=100)
	par(mfrow = c(npath,1))
}
for (ipath in 1:npath)
{
        path_prefix = paste(main_path,paths[ipath],'/',sep='')
        load(paste(path_prefix,'Square_error_',data_ext,sep=''))
	RMSE = matrix(0,nrow(SE_all),nwell) #squared error in all wells for all the realizations
	RMSE = SE_all[,wells_idx]
	nt_obs_1 = nt_obs[wells_idx]
	RMSE_vec = array(0,c(0,1))
	group_ids = array(0,c(0,1))
	for(iwell in 1:nwell)
	{
		RMSE_1well = sqrt(RMSE[,iwell] / nt_obs_1[iwell])
		RMSE_vec = c(RMSE_vec, RMSE_1well)
		group_ids = c(group_ids,rep(wells[iwell],times = nrow(SE_all)))
	}
	# all the wells together
	RMSE_all = sqrt(rowSums(RMSE)/sum(nt_obs_1))
	RMSE_vec = c(RMSE_vec, RMSE_all)
        group_ids = c(group_ids,rep('All',times = nrow(SE_all)))

	if(separate_plots)
		jpeg(paste(paths[ipath],'_RMSE_Boxplot_',testvariable, '.jpg', sep = ''), width = pwidth, height = pheight,units="in",res=200,quality=100)
	boxplot(RMSE_vec ~ group_ids,ylab="RMSE",main = plot_titles[ipath],ylim = c(0,0.55))
	if(separate_plots)
		dev.off()
}
if(!separate_plots)
	dev.off()


