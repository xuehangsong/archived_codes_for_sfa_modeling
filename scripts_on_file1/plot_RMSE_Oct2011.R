
#This file is used for plotting RMSE in selected wells for all parameter sets and find the best-fit realization

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
paths = c('Tracer_Oct2011_Iter3')
#paths = c('Tracer_Mar2011_UK_Binary_Modal','Tracer_Mar2011_UK_Binary_Rel5','Tracer_Mar2011_UK_Binary_Rel10')
npath = length(paths)
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'
testvariable = 'Tracer3'
DataSet = 'Oct2011'
fields = 1:600
nfields = length(fields)
data_ext = '.Rdata'
#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 26
pheight = 17
#pwidth = 10.5
#pheight = 7.5
time_start = 168 #Oct2011 test
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


wells = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')
nwell = length(wells)
select_wells = wells  #selected wells for calculating RMSE
nselect = length(select_wells)
#wells_plot = c('2-07','2-08','2-14','2-26','2-27','2-28','3-23','3-25','3-35')
wells_plot = select_wells
nplot = length(wells_plot)
nt_obs_orig = numeric(nwell)
t_obs = array(0,c(0,1))
BTC_obs = array(0,c(0,1))
time_upper = 600
for (ivar in 1:nselect)
{
	well_name = select_wells[ivar]
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
    nt_obs_orig[ivar] = length(true_t)
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
			fixedt = t_obs[istart:sum(nt_obs_orig[1:iw])]
			trueBTC = BTC_obs[istart:sum(nt_obs_orig[1:iw])]
			ids = which(!is.na(data0[,varcols[iw]])) #the points used for interpolation
			interp = approx(t0[ids],data0[ids,varcols[iw]],xout = fixedt,rule = 2)$y
			interp = interp * y_convert
			SE_all[which(fields==ifield),iw] = sum((interp-trueBTC)^2,na.rm=T)
			istart = istart + nt_obs_orig[iw]
		}
	}
	save(SE_all,nt_obs_orig,wells,file=paste(path_prefix,'Square_error_',testvariable,data_ext,sep=''))
}

#the ids of each selected well
idx_wells = array(0,c(nselect,1))
for (iw in 1:nselect)
	idx_wells[iw] = grep(select_wells[iw],wells)
 
#the ids of each selected well for plotting
idx_plotwells = array(0,c(nplot,1))
for (iw in 1:nplot)
	idx_plotwells[iw] = grep(wells_plot[iw],wells)
for (ipath in 1:npath)
{
	path_prefix = paste(main_path,paths[ipath],'/',sep='')
	load(paste(path_prefix,'Square_error_',testvariable,data_ext,sep=''))
	SE_select = rowSums(SE_all[,idx_wells])
	total_obs = sum(nt_obs_orig[idx_wells])
	SE_select = sqrt(SE_select/total_obs)
	# boxplot of RMSE for each parameter set
	jpeg(paste(main_path,paths[ipath],'BoxPlot_RMSE_',testvariable,'.jpg',sep=""),width=pwidth,height=pheight,units="in",res=150,quality=100)         
	boxplot(SE_select,ylab="RMSE")
	dev.off()
	#find the realization with smallest RMSE
	idx_best_fit = which.min(SE_select)
	#plot the best fit
	#read in data
	input_file = paste(path_prefix, prefix_file,'R',fields[idx_best_fit],ext_file,sep='')
	a = readLines(input_file,n=1)
	b = unlist(strsplit(a,','))
	nvar = length(b)-1 #the first column is time
	varnames = b[-1]
	#find the columns needed
	varcols = array(NA,nplot,1)
	for (iw in 1:nplot)
			varcols[iw] = intersect(grep(wells_plot[iw],varnames),grep(testvariable,varnames)) + 1 #the first column is time                
	#read from files
	data0 = read.table(input_file,skip=1) # the first line is skipped
	t0 = data0[,1]-time_start
	#plotting
	jpeg(paste(main_path,paths[ipath],'_Best_Fit_',testvariable,'.jpg',sep=""),width=pwidth,height=pheight,units="in",res=250,quality=100)         
	par(mfrow=c(5,7))
#	par(mfrow=c(3,3))
	k=1
	for (iw in idx_plotwells)
	{
		if(iw == 1)
			istart = 1
		else
			istart = sum(nt_obs_orig[1:(iw-1)])+1
		fixedt = t_obs[istart:sum(nt_obs_orig[1:iw])]
		trueBTC = BTC_obs[istart:sum(nt_obs_orig[1:iw])]
		simulated = data0[,varcols[k]] * y_convert
		ymax = max(c(max(trueBTC,na.rm=T),max(simulated,na.rm=T)),na.rm=T)
		#ymax = 1.05
		#plot(t0,simulated, main=wells[iw], xlab = b[1], ylab = y_label,xlim=c(0,1200), ylim = c(0, ymax), type = "l",lwd = linwd1, col = 'DarkGreen',lty = 'solid',cex.axis=1.7,cex.lab=1.7,cex.main=1.7,bty = 'n')
		plot(t0,simulated, main=wells[iw], xlab = b[1], ylab = y_label,xlim=c(0,time_upper), ylim = c(0, ymax), type = "l",lwd = linwd1, col = 'DarkGreen',lty = 'solid',bty = 'n')
		points(fixedt,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
		k = k + 1
	}
	dev.off()
	
	if(FALSE)
	{
		#find the worst fit
		idx_worst_fit = which.max(SE_select)
		#read in data
        input_file = paste(path_prefix, prefix_file,'R',fields[idx_worst_fit],ext_file,sep='')
        a = readLines(input_file,n=1)
        b = unlist(strsplit(a,','))
        nvar = length(b)-1 #the first column is time
        varnames = b[-1]
        #find the columns needed
        varcols = array(NA,nplot,1)
        for (iw in 1:nplot)
                varcols[iw] = intersect(grep(wells_plot[iw],varnames),grep(testvariable,varnames)) + 1 #the first column is time                
        #read from files
        data0 = read.table(input_file,skip=1) # the first line is skipped
        t0 = data0[,1]-time_start
 
        jpeg(paste(path_prefix,'Worst_Fit_',testvariable,'.jpg',sep=""),width=pwidth,height=pheight,units="in",res=250,quality=100)         
		par(mfrow=c(5,7))
	#	par(mfrow=c(3,3))
		k=1
        for (iw in idx_plotwells)
        {
			if(iw == 1)
				istart = 1
			else
				istart = sum(nt_obs_orig[1:(iw-1)])+1
			fixedt = t_obs[istart:sum(nt_obs_orig[1:iw])]
			trueBTC = BTC_obs[istart:sum(nt_obs_orig[1:iw])]
			simulated = data0[,varcols[k]] * y_convert
			ymax = max(c(max(trueBTC,na.rm=T),max(simulated,na.rm=T)),na.rm=T)
			#ymax = 1.05
			plot(t0,simulated, main=wells[iw], xlab = b[1], ylab = y_label,xlim=c(0,1200), ylim = c(0, ymax), type = "l",lwd = linwd1, col = 'DarkGreen',lty = 'solid',bty='n')
			#plot(t0,simulated, main=wells[iw], xlab = b[1], ylab = y_label,xlim=c(0,1200), ylim = c(0, ymax), type = "l",lwd = linwd1, col = 'DarkGreen',lty = 'solid',cex.axis=1.7,cex.lab=1.7,cex.main=1.7,bty='n')
			points(fixedt,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
        	k = k + 1
		}
		dev.off()
	}
}
