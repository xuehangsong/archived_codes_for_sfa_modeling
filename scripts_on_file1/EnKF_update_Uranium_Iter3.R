#This file is used for EnKF applied to assimilate uranium BTC 

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
#paths for ensemble of predictions
paths = c('Uranium_Mar2011_EnKF_Iter2/')
prior_path = 'Uranium_Mar2011_EnKF_Iter1'
npath = length(paths)
fields = c(1:200)
par_idx = c(1:200)
nfields = length(fields)     # number of random fields
#load the ensemble of parameters
prior_par = read.table(paste(prior_path,'/','InitialU_Post_Samples_100to200h_Err10_Iter2.txt',sep=''))
realization_by_row = F #whether realizations are presented in different rows
if(!realization_by_row)
        prior_par = t(prior_par)
par_dim = ncol(prior_par) #dimension of parameter set
prior_par = prior_par[par_idx,]
#check if prior_par has non_random initial U for any grid
for(i in 1:par_dim){
        var_temp = var(prior_par[,i])
        if(var_temp == 0)
                prior_par[,i] = prior_par[,i] + rnorm(nfields,0,0.1)
}

#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'
testvariable = 'UO2'
true_col = 2
DataSet = 'Mar2011TT'
NormConc_True = 1.0  # Mar2011 test
NormTime_True = 1.0
y_convert = 238.0 * 1000000.0 #Mar2011 test, injected tracer
time_start = 0.25 #Mar2011 test using kriged boundary condition


wells = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-25','3-28',
'3-29','3-30','3-31','3-32','3-35','2-37')

max_time_upper = 300.0
min_time = 200.0
if(min_time>=400.0)
	wells = c(wells,'2-34')
nwell = length(wells)
nt_obs = numeric(nwell)
t_obs = array(0,c(0,1))
BTC_obs = array(0,c(0,1))
err_cv='10'
err_cv_val=0.10

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
       id_t = which(true_t<=max_time_upper & true_t>min_time)
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
                meas_err[ii,ii] = (min(10,max(BTC_obs[ii] * err_cv_val,5.0*err_cv_val)))^2 # measurement error with upper and lower bounds
                meas_err_samp[ii,] = rnorm(nfields,0,sqrt(meas_err[ii,ii]))
                var_temp = var(sim_data[,ii])
                if(var_temp==0)
                        sim_data[,ii] = sim_data[,ii] + rnorm(nfields,0,5*err_cv_val)        
	}
        meas_err_samp = t(meas_err_samp)
        # realizations for observtions considering measurement errors
        obs_ensemble = matrix(rep(BTC_obs,times=nfields),nfields,sum(nt_obs),byrow=T) + meas_err_samp
        obs_ensemble[which(obs_ensemble<0)] = 0  #remove negative concentrations        
        #save the ensembles for observations
        write.table(obs_ensemble,file=paste(main_path,paths[ipath],'/obs_ensemble_',min_time,'to',max_time_upper,'h_Err',err_cv,'.txt',sep=''),row.names=F,col.names=F)

        #load the material ids for the domain
        material_ids = read.table('material_ids.txt')
	material_ids = material_ids[1:par_dim,1] # only extract the ids relevant to parameters
        ##update the parameter ensemble
        #calcualte the covariance matrix between parameter ensemble and data
        cov_yd_par = cov(prior_par,sim_data)
        cor_yd_par = cor(prior_par,sim_data)
        #make the correlations between simulated data and ringold formation U 0
        cor_yd_par[which(material_ids == 4),] = 0
        cov_yd_par[which(material_ids == 4),] = 0
        #set covarience to be 0 if its absolute value is less than 0.001*max(cov_yd_par)
        cov_yd_par[which(abs(cor_yd_par)<0.01*max(abs(cor_yd_par)))] = 0.0
        write.table(cor_yd_par,file=paste(main_path,paths[ipath],'/cor_yd_par_',min_time,'to',max_time_upper,'h_Err',err_cv,'.txt',sep=''),row.names=F,col.names=F)
        rm(cor_yd_par)
	#covariance between simulated data
        cov_dd = cov(sim_data,sim_data)
        cor_dd = cor(sim_data,sim_data)
	cov_dd[which(abs(cor_dd)<0.01*max(abs(cor_dd)))] = 0.0
        cov_dd_inv = solve(cov_dd + meas_err)
        gain_par = cov_yd_par %*% cov_dd_inv
        post_par = prior_par
        for (ipar in 1:nfields)
                post_par[ipar,] = prior_par[ipar,] + gain_par %*% (matrix(obs_ensemble[ipar,]-sim_data[ipar,],sum(nt_obs),1))
        post_par[which(post_par>=7.5)] = 7.5 + rnorm(length(which(post_par>=7.5)),0,0.1) #set an upper bound on initial U

        #save the updated parameter sets to text files
        write.table(t(post_par),file=paste(main_path,paths[ipath],'/InitialU_Post_Samples_',min_time,'to',max_time_upper,'h_Err',err_cv,'_Iter3.txt',sep=''),row.names=F,col.names=F)
}



