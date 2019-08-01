#This file is used for calculating RMSE and temporal moments of BTC at each well

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
paths = c('Tracer_Oct2011_Iter2/')
prior_path = 'Tracer_Oct2011_Iter1'

npath = length(paths)
fields = c(1:600)
par_idx = c(1:600)
nfields = length(fields)     # number of random fields
#load the ensemble of parameters
perm_par = read.table(paste(prior_path,'/','logK_Post_Samples_50to75h_Err10_Iter2_NearSet.txt',sep=''))
new_iter = 3
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
testvariable = 'Tracer2'
DataSet = 'Oct2011'
time_start = 168.0 #Oct2011 tests with test0 flushing included
#read in true data
data_true = read.csv(paste(main_path,'TracerData_Oct2011.csv',sep=''),header=T)
# the columns are Well Name[1],Sample Time PDT[2],Elapsed Hr T1[3],Elapsed Hr T2[4],Temp- C[5],SpC- mS/cm[6],pH[7],U (ug/L)[8],F (mg/L)[9],Cl (mg/L)[10],
# NO2 (mg/L)[11],Br (mg/L)[12],SO4 (mg/L)[13],NO3 (mg/L)[14],Ca (ug/L)[15]
#filter data between time_low and time_upper

#convert the character strings
data_true[,1] = paste(data_true[,1]) # well names
data_true[,2] = paste(data_true[,2]) # sample time
# to force the well IDs to have the same format, e.g., change 2-5 to 2-05 
idx = which(nchar(data_true[,1]) < 4)
if(length(idx)>0)
{
        for (i in idx)
        {
                ctemp = substring(data_true[i,1],nchar(data_true[i,1]),nchar(data_true[i,1]))
                data_true[i,1] = paste(data_true[i,1],'0',sep='')
                substring(data_true[i,1],3,3)='0'
                substring(data_true[i,1],4,4)=ctemp
        }
}

NormTime_True = 1.0
if(length(grep('Tracer1',testvariable))>0)
{
        true_col = 10
        NormConc_True = 110.0
        y_convert = 1000.0
        y_label = 'Cl- C/C0'
}

if(length(grep('Cl-',testvariable))>0)
{
        true_col = 10
        NormConc_True = 110.0
        y_convert = 1000.0*35.5/110.0
        y_label = 'Cl- C/C0'
}

if(length(grep('Tracer2',testvariable))>0)
{
        true_col = 12
        NormConc_True = 110.0
        y_convert = 1000.0
        y_label = 'Br- C/C0'
}

if(length(grep('Br-',testvariable))>0)
{
        true_col = 12
        NormConc_True = 110.0
        y_convert = 1000.0*80.0/110.0
        y_label = 'Br- C/C0'
}

if(length(grep('Tracer3',testvariable))>0)
{
        true_col = 9
        NormConc_True = 73.0
        y_convert = 1000.0
        y_label = 'F- C/C0'
}

if(length(grep('F-',testvariable))>0)
{
        true_col = 9
        NormConc_True = 73.0
        y_convert = 1000.0 * 19.0/73.0
        y_label = 'F- C/C0'
}

if(length(grep('UO2',testvariable))>0)
{
        true_col = 8
        NormConc_True = 1.0
        y_convert = 238.0*1000000.0
        y_label = 'U(VI) [ug/L]'
}

#wells selected for conditioning

wells_Tracer1 = c('2-34','2-07','2-08','2-09','2-11','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-26','2-27','2-28')
wells_Tracer2 = c('2-34','2-07','2-08','2-09','2-11','2-13','2-14','2-16','2-17','2-18','2-26','2-27','2-28')
wells = wells_Tracer2
max_time_upper = 300.0
min_time = 275.0

nwell = length(wells)
nt_obs = numeric(nwell)
t_obs = array(0,c(0,1))
BTC_obs = array(0,c(0,1))
err_cv='10'
err_cv_val=0.10

for (ivar in 1:nwell)
{
       well_name = wells[ivar]
        true_idx = grep(well_name,data_true[,1])
        if(length(true_idx)>0)
        {
                true_exist = T
                true_t = data_true[true_idx,3]/NormTime_True #time units converted to hours
                trueBTC = data_true[true_idx,true_col]/NormConc_True
                if(length(grep('Tracer2',testvariable))>0)
                        trueBTC[which(true_t <191.6)] = 0.0
                if(length(which(true_t<0))>0&&length(grep('Tracer',testvariable))>0)
                        trueBTC = trueBTC - mean(trueBTC[which(true_t <0)],na.rm=T)
        }
        idx_nonNA = which(!is.na(trueBTC))
        true_t = true_t[idx_nonNA]
        trueBTC = trueBTC[idx_nonNA]
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

        #load the material ids for each permeability
        material_ids = read.table('material_ids.txt')
        ##update the perm field
        #calcualte the covariance matrix between parameter ensemble and data
        cov_yd_perm = cov(perm_par,sim_data)
        cor_yd_perm = cor(perm_par,sim_data)
        #make the correlations between simulated data and ringold formation K 0
        cor_yd_perm[which(material_ids == 4),] = 0
        cov_yd_perm[which(material_ids == 4),] = 0
        #set covarience to be 0 if its absolute value is less than 0.05max(cov_yd_perm)
        cov_yd_perm[which(abs(cor_yd_perm)<0.05*max(abs(cor_yd_perm)))] = 0.0
        #write.table(cor_yd_perm,file=paste(main_path,paths[ipath],'/cor_yd_perm_',min_time,'to',max_time_upper,'h_Err',err_cv,'.txt',sep=''),row.names=F,col.names=F)
        rm(cor_yd_perm)
        cov_dd = cov(sim_data,sim_data)
        cor_dd = cor(sim_data,sim_data)
	cov_dd[which(abs(cor_dd)<0.05*max(abs(cor_dd)))] = 0.0
        cov_dd_inv = solve(cov_dd + meas_err)
        gain_perm = cov_yd_perm %*% cov_dd_inv
        new_perm_par = perm_par
        for (ipar in 1:nfields)
                new_perm_par[ipar,] = perm_par[ipar,] + gain_perm %*% (matrix(obs_ensemble[ipar,]-sim_data[ipar,],sum(nt_obs),1))
        new_perm_par[which(new_perm_par<=-11.0)] = -11.0 + rnorm(length(which(new_perm_par<=-11.0)),0,0.1)
        new_perm_par[which(new_perm_par>=1)] = 1.0 + rnorm(length(which(new_perm_par>=1.0)),0,0.05)

        #save the updated parameter sets to text files
        write.table(t(new_perm_par),file=paste(main_path,paths[ipath],'/logK_Post_Samples_',min_time,'to',max_time_upper,'h_Err',err_cv,'_Iter',new_iter,'_NearSet.txt',sep=''),row.names=F,col.names=F)
}



