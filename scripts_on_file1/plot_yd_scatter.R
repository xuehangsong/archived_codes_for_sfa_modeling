#This file is used for scatter plot of simulated data and parameters in EnKF 

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
paths = c('Tracer_Mar2011_UK3_KrigeFields/')
prior_path = 'Field_Generation'

npath = length(paths)
fields = c(1:300)
par_idx = c(1:300)
nfields = length(fields)     # number of random fields
#load the ensemble of parameters
perm_par = read.table(paste(prior_path,'/','logK_3D_Kriged_Samples.txt',sep=''))
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
plotfile = '.jpg'
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
Well_obs = array(0,c(0,1))

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
       Well_obs = c(Well_obs,rep(well_name,times=nt_obs[ivar]))
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
	
        #load the material ids for each permeability
        material_ids = read.table('material_ids.txt')
        ##update the perm field
        #calcualte the covariance matrix between parameter ensemble and data
        cov_yd_perm = cov(perm_par,log(sim_data))
        cor_yd_perm = cor(perm_par,log(sim_data))
        #make the correlations between simulated data and ringold formation K 0
        cor_yd_perm[which(material_ids == 4),] = 0
        cov_yd_perm[which(material_ids == 4),] = 0
        #set covarience to be 0 if its absolute value is less than 0.05max(cov_yd_perm)
        id_highcor = which(abs(cor_yd_perm)>0.95*max(abs(cor_yd_perm)))
	n_high = length(id_highcor)
	jpeg(paste(main_path,paths[ipath],'/High_Corr_Log_',testvariable, plotfile, sep = ''), width = 15, height = 15,units="in",res=200,quality=100)
	par(mfrow=c(5,5))
	for(iobs in 40:44)
		for(ipar in 254699:254703)
			plot(perm_par[,ipar],log(sim_data[,iobs]),main=paste(Well_obs[iobs],', ',round(t_obs[iobs],2),'h, Cor=',round(cor_yd_perm[ipar,iobs],3),sep=''),xlab='Parameter Ensemble',ylab='Simulated Data',type='p')
	dev.off()
}



