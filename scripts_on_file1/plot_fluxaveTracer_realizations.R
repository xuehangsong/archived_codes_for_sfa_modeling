
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
paths = c('Tracer_Mar2011_EnRML_0to800h_Iter3')
npath = length(paths)
time_start = 0.25 #Mar2011 test
#time_start = 191.25 #Mar2011 test
fields =  seq(1,600) 
nfields = length(fields)     # number of random fields
testvariable = 'Tracer'

Mean_path = '' 
MeanData_exist = 0 #whether results from mean field exist
BC = 'Kriging'
DataSet = 'Mar2011TT'

plot_title = ''

#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 26 
pheight = 17
plot_legend = T
plotfile = '.jpg'
y_label = 'Tracer C/C0'
#y_convert = 1000.0/2.25 #Oct2009 test
#NormTime_True = 60.0
#NormConc_True = 180.0
#time_start = 255.5 #Oct2009 test
y_convert = 1000.0/5.9234 #Mar2011 test
NormTime_True = 1.0
NormConc_True = 210.0

wells_plot = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')
#wells_plot = c('2-11','2-14','2-18','2-26','2-28','3-29','3-31')
nwell = length(wells_plot)

plot_nrow = 5
plot_ncol = 8

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
			interp = approx(t0,data0[ids,varcols[iw]],xout = fixedt,rule = 1)$y
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
        	        interp = approx(t0[ids],data0[ids,varcols[iw]],xout = fixedt,rule = 2)$y
        	        #locations of the data will be stored
        	        locs = ((iw - 1) * nt + 1) : (iw * nt)
        	        meandata[locs,1] = interp
        	}
	}
	#plot
	jpeg(paste(main_path,paths[ipath],'_Realizations_',testvariable, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=200,quality=100)
	par(mfrow=c(plot_nrow,plot_ncol),mar=c(3,3,3,3))
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
				trueBTC = (truedata[,3]-mean(truedata[which(truedata[,1]<0),3]))/NormConc_True
		}

		data0=alldata[locs,]
		data0 = data0 * y_convert
		ymax = max(max(data0,na.rm=T),max(trueBTC,na.rm=T))
		ymin = min(min(data0,na.rm=T),min(trueBTC,na.rm=T))
		if(MeanData_exist)
		{
			ymax = max(ymax,max(meandata[locs,1]*y_convert))
			ymin = min(ymin,min(meandata[locs,1]*y_convert))
		}
		yrange = ymax - ymin
		ymax = ymax + 0.05*yrange
		ymax = max(ymax,0.1)
		ymin = ymin - 0.05*yrange
		plot(fixedt,data0[,1], main=paste(plot_title,well_name,sep=''), xlab = b[1], ylab = y_label,xlim=c(0,1200), ylim = c(0, ymax), type = "l",lwd = linwd1, col = 'darkred',lty = 'solid',bty="n",cex.lab=1.7,cex.axis=1.7,cex.main=1.8) 
		for (irel in 2:nfields)
			lines(fixedt,data0[,irel],lwd=linwd1,col='darkred',lty='solid')
           
		points(true_t,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
	}
	if(plot_legend)
		#plot(c(1,2),c(2,2),ylim=c(0,1),xlab="",ylab="",bty="n",axes = F)	
		legend("topright",c('Simulated','Observed'), lty=c('solid','solid'),col=c('darkred','black'),lwd=c(linwd1,linwd1),pch=c(-1,1), cex=1.7, bty='n')
	dev.off() 	
}
