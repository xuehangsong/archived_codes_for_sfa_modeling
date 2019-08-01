
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
paths = c('Tracer_Oct2011_Iter3')
#paths = c('Tracer_Mar2011_UK_Binary_Modal','Tracer_Mar2011_UK_Binary_Rel5','Tracer_Mar2011_UK_Binary_Rel10')
npath = length(paths)
fields = c(1:600)
data_ext = '.Rdata'
#data_ext = 'par55.Rdata'
nfields = length(fields)     # number of random fields


path_prefix = paste(main_path,paths[1],'/',sep='')
load(paste(path_prefix,'Square_error_Tracer1.Rdata',sep='')) #including SE_all,nt_obs_orig,wells for tracer1
#load the data mainly to get the full list of wells
select_wells = c('2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-26','2-27','2-28')


nwell = length(wells)

nselect = length(select_wells)
idx_wells = match(select_wells,wells)
for (ipath in 1:npath)
{
	path_prefix = paste(main_path,paths[ipath],'/',sep='')
	load(paste(path_prefix,'Square_error_Tracer1.Rdata',sep='')) #including SE_all,nt_obs_orig,wells for tracer1
	SE_select_1 = rowSums(SE_all[,idx_wells])
	total_obs_1 = sum(nt_obs_orig[idx_wells])
	SE_select_1 = sqrt(SE_select_1/total_obs_1)
	load(paste(path_prefix,'Square_error_Tracer2.Rdata',sep='')) #including SE_all,nt_obs_orig,wells for Tracer2
	SE_select_2 = rowSums(SE_all[,idx_wells])
	total_obs_2 = sum(nt_obs_orig[idx_wells])
	SE_select_2 = sqrt(SE_select_2/total_obs_2)
	load(paste(path_prefix,'Square_error_Tracer3.Rdata',sep='')) #including SE_all,nt_obs_orig,wells for Tracer3
	SE_select_3 = rowSums(SE_all[,idx_wells])
	total_obs_3 = sum(nt_obs_orig[idx_wells])
	SE_select_3 = sqrt(SE_select_3/total_obs_3)
	SE_select_12 = sqrt((SE_select_1 + SE_select_2)/(total_obs_1 + total_obs_2))
	SE_select_123 = sqrt((SE_select_1 + SE_select_2 + SE_select_3)/(total_obs_1 + total_obs_2 + total_obs_3))	
	idx_best_fit_1 = which.min(SE_select_1)
	idx_best_fit_2 = which.min(SE_select_2)
	idx_best_fit_12 = which.min(SE_select_12)
        idx_best_fit_123 = which.min(SE_select_123)
}

