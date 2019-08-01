#This file is used to update the boundary condition and permeability field using EnKF  
rm(list=ls())
#set the path to the files
main_path = '/files2/scratch/chenxy/'
paths = c('Tracer_Mar2011_Random_BC_191to237h')
BC_path = 'Mar2011_Random_BC_files'
BCfile_ext = '_Exp_drift0_Mar2011_192to291h.txt'
npath = length(paths)
fields = c(1:500)
nfields = length(fields)     # number of random fields
par_idx = 1:500
ensem_size = length(par_idx) #ensemble size
#load the ensemble of parameters
perm_par = read.table('Tracer_Mar2011_Random_BC_191to291h/logK_Post_Samples_19h.txt')
realization_by_row = F #whether realizations are presented in different rows
if(!realization_by_row)
	perm_par = t(perm_par)
perm_par = perm_par[par_idx,]

#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'
testvariable = 'Tracer'
true_col = 3
DataSet = 'Mar2011TT'
NormConc_True = 210.0  # Mar2011 test
NormTime_True = 1.0
y_convert = 1000.0/5.9234 #Mar2011 test, injected tracer
time_start = 0.25 #Mar2011 test using kriged boundary condition
#time_start = 191.25 #Mar2011 test using triangulated boundary condition


wells = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-25','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')

nwell = length(wells)
nt_obs = numeric(nwell)
t_obs = array(0,c(0,1))
BTC_obs = array(0,c(0,1))
wells_obs = array(0,c(0,1))

time_upper = 46.0
time_low = 19.0
#the start and end of boundary conditions to be updated
i_BC_start = 20
i_BC_end = 47
times_BC = 19:46 #corresponding beginning time for each boundary condition
#retrieve the samples for boundary conditions
ngrid_BC = 480
nt_BC = i_BC_end - i_BC_start + 1
BC_par = matrix(0,nfields,ngrid_BC*nt_BC)

for(ifield in fields)
{
	BC_filename = paste(BC_path,'/BC_Data_Rel',ifield,BCfile_ext,sep='')
	BC_temp = read.table(BC_filename)
	BC_par[which(fields == ifield),] = c(as.matrix(BC_temp[,i_BC_start:i_BC_end]))
}
 
#retrieve the observation data
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
	   id_t = which(true_t<=time_upper & true_t>time_low)
	   true_t = true_t[id_t]
	   trueBTC = trueBTC[id_t]
	   nt_obs[ivar] = length(id_t)
	   t_obs = c(t_obs,true_t)
	   BTC_obs = c(BTC_obs,trueBTC)
	wells_obs = c(wells_obs,rep(well_name,times=nt_obs[ivar]))
}

for (ipath in 1:npath)
{
        path_prefix = paste(main_path,paths[ipath],'/',sep='')
#	write.table(data.frame(wells_obs,t_obs,BTC_obs), file=paste(path_prefix,'OBS_points_upto',time_upper,'hr.txt',sep=""),quote=F,row.names=F)
	#ensemble for simulated data
	sim_data = array(0,c(nfields,sum(nt_obs)))
        for(ifield in fields)
        {
                input_file = paste(path_prefix, prefix_file,'R',ifield,ext_file,sep='')
                a = readLines(input_file,n=1)
                b = unlist(strsplit(a,','))
                nvar = length(b)-1 #the first column is time
                varnames = b[-1]
                #find the columns needed
                varcols = array(NA,nwell,1)
                for (iw in 1:nwell)
                        varcols[iw] = intersect(grep(wells[iw],varnames),grep(testvariable,varnames)) + 1 #the first column is time                
                #read from files
                data0 = read.table(paste(path_prefix, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
                t0 = data0[,1]-time_start
                #linearly interpolate the data at the given observation time points
                istart = 1
                for (iw in 1:nwell)
                {
                        fixedt = t_obs[istart:sum(nt_obs[1:iw])]
                        trueBTC = BTC_obs[istart:sum(nt_obs[1:iw])]
                        ids = which(is.na(data0[,varcols[iw]]) == 0) #the points used for interpolation
                        interp = approx(t0[ids],data0[ids,varcols[iw]],xout = fixedt,rule = 2)$y
                        interp = interp * y_convert
			sim_data[which(fields==ifield),(istart:sum(nt_obs[1:iw]))] = interp
                        istart = istart + nt_obs[iw]
                }
        }
        #save(fields,diff_ensemble,nt_obs,t_obs,wells,file=paste(path_prefix,'diff_ensemble',data_ext,sep=''))
	#measurement error matrix
	meas_err = matrix(0,sum(nt_obs),sum(nt_obs))
	#generate realizations of measurement error
	meas_err_samp = matrix(0,sum(nt_obs),nfields)
	for (ii in 1:sum(nt_obs))
	{
		meas_err[ii,ii] = (max(BTC_obs[ii] * 0.005,0.001))^2
		meas_err_samp[ii,] = rnorm(nfields,0,sqrt(meas_err[ii,ii]))
	}
	meas_err_samp = t(meas_err_samp)
	# realizations for observtions considering measurement errors
	obs_ensemble = matrix(rep(BTC_obs,times=nfields),nfields,sum(nt_obs),byrow=T) + meas_err_samp
	obs_ensemble[which(obs_ensemble<0)] = 0  #remove negative concentrations	
	obs_ensemble[which(obs_ensemble>1)] = 1  #remove normalized concentrations>1
	#save the ensembles for observations
	write.table(obs_ensemble,file=paste(main_path,paths[ipath],'/obs_ensemble_',time_upper,'h.txt',sep=''),row.names=F,col.names=F)	
	#load the material ids for each permeability
	material_ids = read.table('material_ids.txt')
	##update the perm field
	#calcualte the covariance matrix between parameter ensemble and data
	cov_yd_perm = cov(perm_par,sim_data)  
	cor_yd_perm = cor(perm_par,sim_data)
	#make the correlations between simulated data and ringold formation K 0
	cor_yd_perm[which(material_ids == 4),] = 0
	cov_yd_perm[which(material_ids == 4),] = 0
	#set covarience to be 0 if its absolute value is less than 0.001*max(cov_yd_perm)
	cov_yd_perm[which(abs(cor_yd_perm)<0.001*max(abs(cor_yd_perm)))] = 0.0 
	write.table(cor_yd_perm,file=paste(main_path,paths[ipath],'/cor_yd_perm_',time_upper,'h.txt',sep=''),row.names=F,col.names=F)	
	rm(cor_yd_perm)
	cov_dd = cov(sim_data,sim_data)
	cov_dd_inv = solve(cov_dd + meas_err)
	gain_perm = cov_yd_perm %*% cov_dd_inv
	new_perm_par = perm_par 
	for (ipar in 1:nfields)
		new_perm_par[ipar,] = perm_par[ipar,] + gain_perm %*% (matrix(obs_ensemble[ipar,]-sim_data[ipar,],sum(nt_obs),1))
	#save the updated parameter sets to text files
	write.table(t(new_perm_par),file=paste(main_path,paths[ipath],'/logK_Post_Samples_',time_upper,'h.txt',sep=''),row.names=F,col.names=F)
	rm(new_perm_par)
	
	##update the boundary conditions
	cov_yd_BC = cov(BC_par,sim_data)  
	cor_yd_BC = cor(BC_par,sim_data)  
#set covarience to be 0 if its absolute value is less than 0.05
	cov_yd_BC[which(abs(cor_yd_BC)<0.001*max(abs(cor_yd_BC)))] = 0.0 	
	#set the cov between simulated data and BC after the time point 0
	for(ii in 1:sum(nt_obs))
	{
		idx = which(times_BC > (t_obs[ii]+time_start))
		if(length(idx)>0)
		{
			cor_yd_BC[((min(idx)-1)*ngrid_BC+1):(ngrid_BC*nt_BC),ii] = 0.0
			cov_yd_BC[((min(idx)-1)*ngrid_BC+1):(ngrid_BC*nt_BC),ii] = 0.0
		}	
	}  
	write.table(cor_yd_BC,file=paste(main_path,paths[ipath],'/cor_yd_BC_',time_upper,'h.txt',sep=''),row.names=F,col.names=F)	
	rm(cor_yd_BC)
	gain_BC = cov_yd_BC %*% cov_dd_inv
	new_BC_par = BC_par 
	for (ipar in 1:nfields)
		new_BC_par[ipar,] = BC_par[ipar,] + gain_BC %*% (matrix(obs_ensemble[ipar,]-sim_data[ipar,],sum(nt_obs),1))
#save the updated parameter sets to text files
	write.table(t(new_BC_par),file=paste(main_path,paths[ipath],'/BC_Post_samples_',time_upper,'h.txt',sep=''),row.names=F,col.names=F)		
}



