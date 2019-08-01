
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/Mar2011/'
# paths = c(paste(main_path,'A_MR_Oct2009_0/',sep=''),paste(main_path,'A_MR_Oct2009_1/',sep=''),paste(main_path,'A_EQ_Oct2009_0/',sep=''),paste(main_path,'A_EQ_Oct2009_1/',sep=''))
testvariable = 'UO2'
BC = 'IFRC2'
DataSet = 'Mar2011TT'
paths = c(paste(BC,'_MR_0_Prior',sep=''))
npath = length(paths)
Mean_path = paste(paths[1],'/MeanField',sep='')
fields =  seq(1,600)
nfields = length(fields)     # number of random fields
#prefix and extension of files
prefix_file = 'OBS2_FluxAve'
ext_file = '.dat'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth =25 
pheight = 17
plotfile = '_Mar2011.jpg'

if(length(grep('UO2',testvariable)) > 0)
{
	true_col = 2
	NormConc_True = 1.0
	y_label = 'U(VI) [ug/L]'
	y_convert = 238.0*1000000
}
if(length(grep('Tracer',testvariable)) > 0)
{
	true_col = 3
	y_label = 'Tracer C/C0'
#	norm_true = 180.0 #Oct 2009 test
#	y_convert = 1000.0/2.25  #Oct2009 test
	NormConc_True = 210.0  # Mar2011 test
	y_convert = 1000.0/5.9234 #Mar2011 test, injected tracer
#	y_convert = 1000.0 #for boundary tracer
}

time_start = 191.25 #Mar2011 test
MeanData_exist = 1 #whether results from mean field exist
wells_plot = c('2-05','2-07','2-08','2-09','2-10','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-25','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-26','3-27','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')
nwell = length(wells_plot)

#read the headers in the first file and determine what variables are available
for (ipath in 1:npath)
{
	path_prefix = paste(main_path,paths[ipath],'/',sep='')
	#determine the times when the data are output and keep them consitent among realizations
	data0 = read.table(paste(path_prefix, prefix_file,'R',fields[1],ext_file,sep=''),skip=1) # the first line is skipped
	fixedt = data0[,1]- time_start 
	nt = length(fixedt)

	#initialize the data mtrix

	alldata = matrix(0,nwell*nt,nfields)

	#read in all the data
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
			varcols[iw] = intersect(grep(wells_plot[iw],varnames),grep(testvariable,varnames)) + 1 #the first column is time		
    	#read from files
		data0 = read.table(paste(path_prefix, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
		t0 = data0[,1]-time_start
		#linearly interpolate the data at the given time points
		for (iw in 1:nwell)
		{
			ids = which(is.na(data0[,varcols[iw]]) == 0) #the points used for interpolation
			interp = approx(t0,data0[ids,varcols[iw]],xout = fixedt,rule = 2)$y
			#locations of the data will be stored
			locs = ((iw - 1) * nt + 1) : (iw * nt)
			alldata[locs,which(fields == ifield)] = interp 
		}
	}
	#get data from mean field
	meandata = matrix(NA,nwell*nt,1)
	if(MeanData_exist)
	{
	        #read from file
	    	if(nchar(Mean_path)<1)
				Mean_path = paste(path_prefix, 'MeanField',sep='')
			meanfile = paste(Mean_path,'/',prefix_file,'R1',ext_file,sep='')
	        tempa = readLines(meanfile,n=1)
	        tempb = unlist(strsplit(tempa,','))
	        varnames_mean = tempb[-1]
			#find the columns needed
			varcols = array(NA,nwell,1)
			for (iw in 1:nwell)
				varcols[iw] = intersect(grep(wells_plot[iw],varnames_mean),grep(testvariable,varnames_mean)) + 1 #the first column is time	

	        data0 = read.table(meanfile,skip=1) # the first line is skipped
	        t0 = data0[,1]- time_start
	        #linearly interpolate the data at the given time points
	        for (iw in 1:nwell)
        	{
        	        ids = which(is.na(data0[,varcols[iw]]) == 0) #the points used for interpolation
        	        interp = approx(t0,data0[ids,varcols[iw]],xout = fixedt,rule = 2)$y
        	        #locations of the data will be stored
        	        locs = ((iw - 1) * nt + 1) : (iw * nt)
        	        meandata[locs,1] = interp
        	}
	}
	#plot
	jpeg(paste(main_path,paths[ipath],'_',prefix_file,'_CI_',testvariable, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
	par(mfrow=c(5,8))
 	for (ivar in 1:nwell)
	{
		#locations of the data stored
		locs = ((ivar - 1) * nt + 1) : (ivar * nt)
		well_name = wells_plot[ivar]
		truedata = matrix(NA,1,3)
		true_file = paste('TrueData_',DataSet,'/Well_',well_name,'_',DataSet,'.txt',sep='')
		true_exist = file.exists(true_file)
		true_t = NA
		trueBTC = NA
		if(true_exist)
		{
				truedata = read.table(true_file,skip=1)
        		true_t = truedata[,1]/NormTime_True #time units converted to hours
				trueBTC = truedata[,true_col]/NormConc_True
				if(length(grep('Tracer',testvariable)))
					trueBTC = (truedata[,true_col]-mean(truedata[which(truedata[,1]<0),true_col]))/NormConc_True
		}

		data0=alldata[locs,]
		data0 = data0 * y_convert
		data0.mean=rowMeans(data0)
		data0.025=apply(data0,1,quantile,0.025)
		data0.975=apply(data0,1,quantile,0.975)
		ymax = max(max(data0.975,na.rm=T),max(trueBTC,na.rm=T))
		ymin = min(min(data0.025,na.rm=T),min(trueBTC,na.rm=T))
		if(MeanData_exist)
		{
			ymax = max(ymax,max(meandata[locs,1]*y_convert))
			ymin = min(ymin,min(meandata[locs,1]*y_convert))
		}
		yrange = ymax - ymin
		ymax = ymax + 0.05*yrange
		ymin = ymin - 0.05*yrange
		plot(fixedt,data0.mean, main=paste(paths[ipath],': ',well_name,sep=''), xlab = b[1], ylab = y_label,xlim=c(0,1000), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid',bty="n") 
		lines(fixedt,data0.975,lwd=linwd1,col='blue',lty='dashed')
		lines(fixedt,data0.025,lwd=linwd1,col='blue',lty='dashed')
		lines(fixedt,meandata[locs,1]*y_convert,lwd=linwd1,col='darkgreen',lty='solid')
           
		points(true_t,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
	}
	plot(c(1,2),c(2,2),ylim=c(0,1),xlab="",ylab="",bty="n",axes = F)	
	legend("topleft",c("Mean","95% CI",'from Mean Field','True'), lty=c('solid','dashed','solid','solid'),col=c('red','blue','darkgreen','black'),lwd=c(linwd1,linwd1,linwd1,linwd1),pch=c(-1,-1,-1,1), cex=2.5, bty='n')
	dev.off() 	
}
