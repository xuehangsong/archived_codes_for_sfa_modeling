#This file is used for calculating RMSE and temporal moments of BTC at each well

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
paths = c('Tracer_Mar2011_Random_BC_191to291h')
npath = length(paths)
fields = c(1:200)
nfields = length(fields)     # number of random fields
#load the ensemble of parameters
par = read.table('FieldGeneration/input_files_anchor/input_par_newEBF2.txt')
par = par[seq(1,10000,50),] #200 parameter sets were used
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
data_ext = paste('upto1000hr.Rdata',sep="")
max_time_upper = 1000.0
 
for (ivar in 1:nwell)
{
       well_name = wells[ivar]
       true_file = paste('TrueData_',DataSet,'/Well_',well_name,'_',DataSet,'.txt',sep='')
       truedata = read.table(true_file,skip=1)
       true_t = truedata[,1]/NormTime_True #time units converted to hours
       trueBTC = truedata[,true_col]/NormConc_True
       if(length(grep('Tracer',testvariable)))
             trueBTC = (truedata[,true_col]-mean(truedata[which(truedata[,1]<0),true_col]))/NormConc_True
       id_t = which(true_t<=max_time_upper & true_t>=0)
       true_t = true_t[id_t]
       trueBTC = trueBTC[id_t]
       nt_obs[ivar] = length(id_t)
       t_obs = c(t_obs,true_t)
       BTC_obs = c(BTC_obs,trueBTC)
}


for (ipath in 1:npath)
{
	diff_ensemble = array(0,c(nfields,sum(nt_obs))) # difference between observation and simulated data
        path_prefix = paste(main_path,paths[ipath],'/',sep='')
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
                        diff_ensemble[which(fields==ifield),(istart:sum(nt_obs[1:iw]))] = trueBTC - interp
                        istart = istart + nt_obs[iw]
                }
        }
        #save(fields,diff_ensemble,nt_obs,t_obs,wells,file=paste(path_prefix,'diff_ensemble',data_ext,sep=''))
	#calcualte the covariance matrix between parameter ensemble and data
	sim_data = matrix(rep(BTC_obs,times=nfields),nfields,sum(nt_obs),byrow=T) - diff_ensemble
	cov_yd = cov(par,sim_data)   
	cov_dd = cov(sim_data,sim_data)
	#measurement error matrix
	meas_err = matrix(0,sum(nt_obs),sum(nt_obs))
	#generate realizations of measurement error
	meas_err_samp = matrix(0,sum(nt_obs),nfields)
	for (ii in 1:sum(nt_obs)){
		meas_err[ii,ii] = (max(BTC_obs[ii] * 0.05,0.02))^2
		meas_err_samp[ii,] = rnorm(nfields,0,sqrt(meas_err[ii,ii]))
	}
	gain = cov_yd %*% solve(cov_dd + meas_err)
	new_par = par 
	for (ipar in 1:nfields)
		new_par[ipar,] = par[ipar,] + gain %*% (matrix(diff_ensemble[ipar,],sum(nt_obs),1)+meas_err_samp[,ipar])
	#save the updated parameter sets to text files
	write.table(new_par,file=paste(main_path,paths[ipath],'/input_par_Iter1_new.txt',sep=''),row.names=F,col.names=F)	
}



