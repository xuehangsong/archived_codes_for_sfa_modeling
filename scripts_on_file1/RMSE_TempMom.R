
#This file is used for calculating RMSE and temporal moments of BTC at each well

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
#paths = c('Tracer_Mar2011_UK_Binary_Modal','Tracer_Mar2011_UK_Binary_Rel5','Tracer_Mar2011_UK_Binary_Rel10')
paths = c('Tracer_Mar2011_UK_KrigeFields_Iter1')
npath = length(paths)
#fields = c(1:40000)
#fields = c(2001:2200,10801:11000,30001:33200)
fields = c(1:200)
nfields = length(fields)     # number of random fields
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
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')

nwell = length(wells)
nt_obs = numeric(nwell)
t_obs = array(0,c(0,1))
BTC_obs = array(0,c(0,1))
time_upper_list = c(200,500,1000)
n_time = length(time_upper_list)
data_ext = paste('upto1000hr.Rdata',sep="")
max_time_upper = max(time_upper_list)
#calculate the true temporal moments:m0,m1
trueM0 = array(0,c(nwell,n_time))
trueM1 = array(0,c(nwell,n_time))
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
       for(itime in 1:n_time){
              time_upper = time_upper_list[itime]
              id_t = which(true_t <= time_upper)
              time.pt = true_t[id_t]
              conc = trueBTC[id_t]	
              #calculate temporal moments
              for(m in 1:(length(id_t)-1)) {
               	     trueM0[ivar,itime] = trueM0[ivar,itime] + (time.pt[m+1]-time.pt[m]) * 0.5 * (conc[m+1] + conc[m])
               	     trueM1[ivar,itime] = trueM1[ivar,itime] + (time.pt[m+1]-time.pt[m]) * 0.5 * (conc[m+1] * time.pt[m+1] + conc[m] * time.pt[m])
              }
        } 
}


for (ipath in 1:npath)
{
	SE_all = array(0,c(nfields,nwell,n_time)) #squared error in all wells for all the realizations
	M0_all = array(0,c(nfields,nwell,n_time)) #squared error in all wells for all the realizations
	M1_all = array(0,c(nfields,nwell,n_time)) #squared error in all wells for all the realizations
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
       			for(itime in 1:n_time){
              			time_upper = time_upper_list[itime]
              			id_t = which(fixedt <= time_upper)
              			time.pt = fixedt[id_t]
              			conc = trueBTC[id_t]	
              			#calculate temporal moments
              			for(m in 1:(length(id_t)-1)) {
               	     			M0_all[which(fields==ifield),iw,itime] = M0_all[which(fields==ifield),iw,itime] + (time.pt[m+1]-time.pt[m]) * 0.5 * (conc[m+1] + conc[m])
               	     			M1_all[which(fields==ifield),iw,itime] = M1_all[which(fields==ifield),iw,itime] + (time.pt[m+1]-time.pt[m]) * 0.5 * (conc[m+1] * time.pt[m+1] + conc[m] * time.pt[m])
              			}
                        	SE_all[which(fields==ifield),iw,itime] = sum((interp[id_t]-trueBTC[id_t])^2,na.rm=T)
        		}		 
                        istart = istart + nt_obs[iw]
                }
        }
        save(fields,SE_all,M0_all,M1_all,nt_obs,wells,time_upper_list,trueM0,trueM1,file=paste(path_prefix,'SE_n_TempMom_',data_ext,sep=''))
}



