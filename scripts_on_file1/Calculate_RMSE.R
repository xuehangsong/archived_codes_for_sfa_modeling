
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
paths = c('Tracer_Mar2011_Iter8','Tracer_Mar2011_EnRML_0to200h_Iter2','Tracer_Mar2011_EnRML_0to800h_Iter2')
#paths = c('Tracer_Mar2011_Iter2','Tracer_Mar2011_Iter3','Tracer_Mar2011_Iter4','Tracer_Mar2011_Iter5','Tracer_Mar2011_Iter6','Tracer_Mar2011_Iter7','Tracer_Mar2011_0to200h_Iter1','Tracer_Mar2011_0to100h_Iter1','Tracer_Mar2011_EnRML_0to200h_Iter1','Tracer_Mar2011_200to400h_Iter2','Tracer_Mar2011_EnRML_0to800h_Iter1','Tracer_Mar2011_0to400h_Iter1','Tracer_Mar2011_100to200h_Iter2')
npath = length(paths)
fields = c(1:600)
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
time_start = 0.25 #Mar2011 test

wells = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')

well_set1 = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-26','2-27','2-28')
well_set2 = c('2-15','2-16','2-17','2-18','2-19','2-20','3-35','2-37')
well_set3 = c('2-21','2-22','2-23','2-24','3-25','3-26','3-28','3-29','3-30','3-31','3-32','2-29','2-30','2-31')
#wells = well_set1
nwell = length(wells)
nt_obs = numeric(nwell)
t_obs = array(0,c(0,1))
BTC_obs = array(0,c(0,1))
time_upper = 800
data_ext = paste('to',time_upper,'hr.Rdata',sep="")
for (ivar in 1:nwell)
{
       well_name = wells[ivar]
       true_file = paste('TrueData_',DataSet,'/Well_',well_name,'_',DataSet,'.txt',sep='')
       truedata = read.table(true_file,skip=1)
       true_t = truedata[,1]/NormTime_True #time units converted to hours
       trueBTC = truedata[,true_col]/NormConc_True
       if(length(grep('Tracer',testvariable)))
             trueBTC = (truedata[,true_col]-mean(truedata[which(truedata[,1]<0),true_col]))/NormConc_True
       id_t = which(true_t<=time_upper & true_t>=0)
       true_t = true_t[id_t]
       trueBTC = trueBTC[id_t]
       nt_obs[ivar] = length(id_t)
       t_obs = c(t_obs,true_t)
       BTC_obs = c(BTC_obs,trueBTC) 
}

for (ipath in 1:npath)
{
	SE_all = matrix(0,nfields,nwell) #squared error in all wells for all the realizations
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
                        SE_all[which(fields==ifield),iw] = sum((interp-trueBTC)^2,na.rm=T)
                        istart = istart + nt_obs[iw]
                }
        }
        save(wells,BTC_obs,SE_all,nt_obs,file=paste(path_prefix,'Square_error_',data_ext,sep=''))
}




