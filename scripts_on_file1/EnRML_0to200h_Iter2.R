#This file is used for EnRML

rm(list=ls())
library(MASS) # library that includes general inverse
#set the path to the files
main_path = '/files2/scratch/chenxy/'
path_prev_iter_sample = 'Tracer_Mar2011_UK3_KrigeFields_Inj5/'
path_prev_iter_sim = 'Tracer_Mar2011_EnRML_0to200h_Iter1/'
prior_path = 'Field_Generation/'

fields = c(1:600)
fields_idx = c(1:600)     # realizations to be included in analyses
nfields = length(fields_idx)     # number of random fields
#load the ensemble of parameters
perm_par_prior = read.table(paste(prior_path,'logK_3D_Kriged_Samples_600.txt',sep=''))
perm_par_prev_iter = read.table(paste(path_prev_iter_sample,'logK_Post_Samples_EnRML_10to200h_Err10_Iter1_set1.txt',sep=''))
new_iter = 2
beta = 0.4     # reduced step size
realization_by_row = F #whether realizations are presented in different rows
if(!realization_by_row)
{
        perm_par_prior = t(perm_par_prior)
        perm_par_prev_iter = t(perm_par_prev_iter)
}

#load the material ids for each permeability
material_ids = read.table('material_ids.txt')
# only the cells in hanford formation need to be updated
ringold_idx = which(material_ids == 4)
hanford_idx = which(material_ids == 1)
npar_total = nrow(material_ids)

perm_par_prior_ringold = perm_par_prior[fields_idx,ringold_idx]
perm_par_prior = perm_par_prior[fields_idx,hanford_idx]
perm_par_prev_iter = perm_par_prev_iter[fields_idx,hanford_idx]
#check if perm_par has non_random perm for a grid
for(i in 1:ncol(perm_par_prior)){
        var_temp = var(perm_par_prior[,i])
        if(var_temp == 0)
                perm_par_prior[,i] = perm_par_prior[,i] + rnorm(nfields,0,0.1)
}

for(i in 1:ncol(perm_par_prev_iter)){
        var_temp = var(perm_par_prev_iter[,i])
        if(var_temp == 0)
                perm_par_prev_iter[,i] = perm_par_prev_iter[,i] + rnorm(nfields,0,0.1)
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
'3-29','3-30','3-31','3-32','3-35','2-37','2-34')

max_time_upper = 200.0
min_time = 10.0

nwell = length(wells)
nt_obs = array(0,c(0,1)) 
t_obs = array(0,c(0,1))
BTC_obs = array(0,c(0,1))
wells_data = array(0,c(0,1))
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
       id_t = which(true_t<=max_time_upper & true_t>=min_time)
       if(length(grep('3-24',well_name)))#well 3-24 may have intra-wellbore flow after 500 hours
		id_t = which(true_t<=min(500,max_time_upper) & true_t>=min_time)
       if(length(grep('2-34',well_name)))# excluding injection period for well 2-34 
		id_t = which(true_t<= max_time_upper & true_t>=400)
	if(length(id_t)<1)
		next
       true_t = true_t[id_t]
       trueBTC = trueBTC[id_t]
       nt_obs = c(nt_obs,length(id_t))
       t_obs = c(t_obs,true_t)
       BTC_obs = c(BTC_obs,trueBTC)
	wells_data = c(wells_data,well_name)
}
nwell_data = length(wells_data)

path_prefix = paste(main_path,path_prev_iter_sim,sep='')
sim_data = array(0,c(nfields,sum(nt_obs))) # ensemble of simulated data
for(ifield in fields)
{
	input_file = paste(path_prefix, prefix_file,'R',ifield,ext_file,sep='')
        a = readLines(input_file,n=1)
        b = unlist(strsplit(a,','))
        nvar = length(b)-1 #the first column is time
        varnames = b[-1]
        #find the columns needed
        varcols = array(NA,nwell_data,1)
        for (iw in 1:nwell_data)
                varcols[iw] = intersect(grep(wells_data[iw],varnames),grep(testvariable,varnames)) + 1 #the first column is time                
        #read from files
        data0 = read.table(paste(path_prefix, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
        t0 = data0[,1]-time_start
        #linearly interpolate the data at the given observation time points
        istart = 1
        for (iw in 1:nwell_data)
        {
		if(nt_obs[iw]>=1)
		{
                       	fixedt = t_obs[istart:sum(nt_obs[1:iw])]
                       	trueBTC = BTC_obs[istart:sum(nt_obs[1:iw])]
                       	ids = which(is.na(data0[,varcols[iw]]) == 0) #the points used for interpolation
                       	interp = approx(t0[ids],data0[ids,varcols[iw]],xout = fixedt,rule = 2)$y
                       	interp = interp * y_convert
                       	sim_data[which(fields==ifield),(istart:sum(nt_obs[1:iw]))] = interp
		}
                istart = istart + nt_obs[iw]
        }
}
	
#measurement error matrix
meas_err = matrix(0,sum(nt_obs),sum(nt_obs))
#generate realizations of measurement error
meas_err_samp = matrix(0,sum(nt_obs),nfields)
for (ii in 1:sum(nt_obs))
{
        meas_err[ii,ii] = (max(BTC_obs[ii] * err_cv_val,0.05*err_cv_val))^2
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
#write.table(obs_ensemble,file=paste(main_path,paths[ipath],'/obs_ensemble_',min_time,'to',max_time_upper,'h_Err',err_cv,'.txt',sep=''),row.names=F,col.names=F)
# calculate auto-covariance of prior parameters
#CM_prior = cov(perm_par_prior, perm_par_prior)
#calculate the deviation of parameters (previous iteration) from the mean
dev_par_prev = perm_par_prev_iter - matrix(rep(colMeans(perm_par_prev_iter),times=nfields),nfields,ncol(perm_par_prev_iter),byrow=T) 
dev_par_prior = perm_par_prior - matrix(rep(colMeans(perm_par_prior),times=nfields),nfields,ncol(perm_par_prior),byrow=T) 
# calculate the deviation of computed data (with parameters from previous iteration) from the mean
dev_d = sim_data - matrix(rep(colMeans(sim_data),times=nfields),nfields,sum(nt_obs),byrow=T)
# calculate the general inverse of dev_par
ginv_dev_par_prev = ginv(t(dev_par_prev))
Gl = t(dev_d) %*% ginv_dev_par_prev   #ensemble average sensitivity matrix that relates the changes in model parameters to changes in computed data
Al = Gl %*% t(dev_par_prior)/sqrt(nfields-1)
cov_dd_inv = solve(Al%*%t(Al) + meas_err)
gain_perm = (t(dev_par_prior)/sqrt(nfields-1)) %*% t(Al) %*% cov_dd_inv

##update the perm field
new_perm_par = matrix(0,length(hanford_idx),nfields)
for (irel in 1:nfields)
{
	innov = t(t(obs_ensemble[irel,])) + Gl %*% t(t(perm_par_prev_iter[irel,]-perm_par_prior[irel,])) - t(t(sim_data[irel,]))
        new_perm_par[,irel] = beta * t(t(perm_par_prior[irel,])) + (1.0 - beta) * t(t(perm_par_prev_iter[irel,])) + beta * gain_perm %*% innov 
}
#rm(CM_prior, dev_par,dev_d,Gl,cov_dd_inv,gain_perm)
#save the updated parameter sets to text files
new_perm_par_total = matrix(NA,npar_total,nfields)
new_perm_par_total[hanford_idx,] = new_perm_par
new_perm_par_total[ringold_idx,] = t(perm_par_prior_ringold)
write.table(new_perm_par_total,file=paste(main_path,path_prev_iter_sim,'/logK_Post_Samples_EnRML_',min_time,'to',max_time_upper,'h_Err',err_cv,'_Iter',new_iter,'_set1.txt',sep=''),row.names=F,col.names=F)




