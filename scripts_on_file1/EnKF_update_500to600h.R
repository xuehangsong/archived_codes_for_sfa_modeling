#This file is used for calculating RMSE and temporal moments of BTC at each well

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
#path for the simulated results
paths = c('Tracer_Mar2011_UK_EnKF_Batch_400to500h_Err10_Iter5/')
npath = length(paths)
fields = c(1:200)
par_idx = c(1:200)
nfields = length(fields)     # number of random fields
min_time = 500
max_time_upper = 600
err_cv='10'
err_cv_val=0.10
#load the prior ensemble of parameters
perm_par = read.table('Tracer_Mar2011_UK_EnKF_Batch_300to400h_Err10_Iter4/logK_Post_Samples_400to500h_Err10_Iter5.txt')
#file name for post par
post_par_file = paste('logK_Post_Samples_',min_time,'to',max_time_upper,'h_Err',err_cv,'_Iter6.txt',sep='')
realization_by_row = F #whether realizations are presented in different rows
if(!realization_by_row)
        perm_par = t(perm_par)
perm_par = perm_par[par_idx,]
#check if perm_par has non_random perm for a grid
for(i in 1:ncol(perm_par)){
	var_temp = var(perm_par[,i])
	if(var_temp == 0)
		perm_par[,i] = perm_par[,i] + rnorm(nfields,0,0.1)
}
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
       true_t = true_t[id_t]
       trueBTC = trueBTC[id_t]
       nt_obs[ivar] = length(id_t)
       t_obs = c(t_obs,true_t)
       BTC_obs = c(BTC_obs,trueBTC)
}


for (ipath in 1:npath)
{
        path_prefix = paste(main_path,paths[ipath],'/',sep='')
	sim_data = array(0,c(nfields,sum(nt_obs))) # ensemble of simulated data
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
	
        #measurement error matrix
        meas_err = matrix(0,sum(nt_obs),sum(nt_obs))
        #generate realizations of measurement error
        meas_err_samp = matrix(0,sum(nt_obs),nfields)
        for (ii in 1:sum(nt_obs))
        {
                meas_err[ii,ii] = (max(BTC_obs[ii] * err_cv_val,0.1*err_cv_val))^2
                meas_err_samp[ii,] = rnorm(nfields,0,sqrt(meas_err[ii,ii]))
		var_temp = var(sim_data[,ii])
		if(var_temp==0)
			sim_data[,ii] = sim_data[,ii] + rnorm(nfields,0,0.1*err_cv_val)
        }
        meas_err_samp = t(meas_err_samp)
        # realizations for observtions considering measurement errors
        obs_ensemble = matrix(rep(BTC_obs,times=nfields),nfields,sum(nt_obs),byrow=T) + meas_err_samp
        obs_ensemble[which(obs_ensemble<0)] = 0  #remove negative concentrations        
        #save the ensembles for observations
        write.table(obs_ensemble,file=paste(main_path,paths[ipath],'/obs_ensemble_',min_time,'to',max_time_upper,'h_Err',err_cv,'.txt',sep=''),row.names=F,col.names=F)

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
        cov_yd_perm[which(abs(cor_yd_perm)<0.01*max(abs(cor_yd_perm)))] = 0.0
        write.table(cor_yd_perm,file=paste(main_path,paths[ipath],'/cor_yd_perm_',min_time,'to',max_time_upper,'h.txt',sep=''),row.names=F,col.names=F)
        rm(cor_yd_perm)
        cov_dd = cov(sim_data,sim_data)
        cor_dd = cor(sim_data,sim_data)
	cov_dd[which(abs(cor_dd)<0.01*max(abs(cor_dd)))] = 0.0
        cov_dd_inv = solve(cov_dd + meas_err)
        gain_perm = cov_yd_perm %*% cov_dd_inv
        new_perm_par = perm_par
        for (ipar in 1:nfields)
                new_perm_par[ipar,] = perm_par[ipar,] + gain_perm %*% (matrix(obs_ensemble[ipar,]-sim_data[ipar,],sum(nt_obs),1))
        new_perm_par[which(new_perm_par<=-11.0)] = -11.0 + rnorm(length(which(new_perm_par<=-11.0)),0,0.1)
        new_perm_par[which(new_perm_par>=1)] = 1.0 + rnorm(length(which(new_perm_par>=1.0)),0,0.1)

	#save the updated parameter sets to text files
	write.table(t(new_perm_par),file=paste(main_path,paths[ipath],'/',post_par_file,sep=''),row.names=F,col.names=F)	
}



