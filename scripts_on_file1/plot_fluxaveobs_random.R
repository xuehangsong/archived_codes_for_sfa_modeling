
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files1/scratch/chenxy/120x120x30/Oct2009/'
# paths = c(paste(main_path,'A_MR_Oct2009_0/',sep=''),paste(main_path,'A_MR_Oct2009_1/',sep=''),paste(main_path,'A_EQ_Oct2009_0/',sep=''),paste(main_path,'A_EQ_Oct2009_1/',sep=''))

#paths = c('A_MR_1','A_EQ_0','A_EQ_1','B_EQ_0','B_EQ_1','B_MR_0','B_MR_1')
paths = c('IFRC_MR_0')
npath = length(paths)
nfields = 500     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.0
pwidth = 360
pheight = 300
plotfile = '.png'
#pwidth = 4.5
#pheight = 4
#plotfile = '.eps'


#read the headers in the first file and determine what variables are available
for (ipath in 1:npath)
{
	path_prefix = paste(main_path,paths[ipath],'/',sep='')
	a = readLines(paste(path_prefix, prefix_file,'R1',ext_file,sep=''),n=1)
	b = unlist(strsplit(a,','))
	nvar = length(b)-1 #the first column is time
	varnames = b[-1]

	#determine the times when the data are output and keep them consitent among realizations
	data0 = read.table(paste(path_prefix, prefix_file,'R1',ext_file,sep=''),skip=1) # the first line is skipped
	fixedt = data0[,1] 
	nt = length(fixedt)

	#initialize the data mtrix

	alldata = matrix (0,nvar*nt,nfields)

	#read in all the data
	for(ifield in 1:nfields)
	{
    	#read from files
		data0 = read.table(paste(path_prefix, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
		t0 = data0[,1]
    		#linearly interpolate the data at the given time points
    		for (icol in 2:(nvar+1))
    		{
			ids = which(is.na(data0[,icol]) == 0) #the points used for interpolation
			interp = approx(t0,data0[ids,icol],xout = fixedt,rule = 2)$y
			#locations of the data will be stored
			locs = ((icol - 2) * nt + 1) : ((icol-1) * nt)
			alldata[locs,ifield] = interp 
		}
	}
	fixedt = fixedt - 255.0 #time zeroed at beginning of injection
	#plots 
	for (ivar in 1:nvar)
	{
		#locations of the data stored
		locs = ((ivar - 1) * nt + 1) : (ivar * nt)
		data0 = alldata[locs,]
		#read in true data
		varsplit = unlist(strsplit(varnames[ivar],' '))
		well_name = varsplit[1]
		species = varsplit[2]
		truedata = matrix(NA,1,3)
		true_exist = file.exists(paste(well_name,'_Oct2009TT.txt',sep=''))
		if(true_exist)
			truedata = read.table(paste(well_name,'_Oct2009TT.txt',sep=''),skip=1)
		true_t = truedata[,1]/60.0 #time units converted to hours
		if(length(grep('U',species)) > 0) 
		{
			trueBTC = truedata[,2]
			y_label = 'UO2++ (ug/L)'
			y_convert = 238.0*1000000
		} 
		if(length(grep('T',species)) > 0) 
		{
			trueBTC = truedata[,3]/180.0
			y_label = 'Tracer C/C0'
			y_convert = 1000.0/2.25
		} 
    	    	data0 = data0 * y_convert
		#plot for all the realizations
    		#open the plotting file
		png(paste(path_prefix, prefix_file,'_', varnames[ivar], plotfile, sep = ''), width = pwidth, height = pheight)
		#postscript(paste(path_prefix, prefix_file,'_', varnames[ivar], plotfile, sep = ''), width = pwidth, height = pheight)

		plot(fixedt,data0[,1], main=paste(paths[ipath],': ',varnames[ivar],sep=''),xlab = b[1], ylab = y_label,xlim=c(-200,750),ylim = c(min(data0), max(data0)), type = "l",lwd = linwd1, col = 'blue',lty = 'solid') 	       
	
		for (i in 2:nfields)
		{
			lines(fixedt, data0[,i], lwd = linwd2, col = 'red', lty = 'solid')
		}
		points(true_t,trueBTC,col='black',type = 'p',pch=1)
		dev.off() 
	
		#calculate the mean and confidence intervals if the number of feilds exceeds 5
		if(nfields >= 5)
		{
			data0.mean=rowMeans(data0)
			data0.std=sqrt(apply(data0,1,var))
			data0.025=apply(data0,1,quantile,0.025)
			data0.975=apply(data0,1,quantile,0.975)
        		ymin = min(data0.025)
        		ymax = max(data0.975)
			yrange = ymax -ymin
			ymin = ymin - 0.1 * yrange
			ymax = ymax +0.1 * yrange
			if(true_exist)
			{
				ymax = max(ymax,max(trueBTC,na.rm=T))
				ymin = min(ymin,min(trueBTC,na.rm=T))
			}
			#plot the confidence intervals
			png(paste(paths[ipath], prefix_file,'_CI_', well_name,species, plotfile, sep = ''), width = pwidth, height = pheight)
			#postscript(paste(path_prefix, prefix_file,'_CI_', varnames[ivar], plotfile, sep = ''), width = pwidth, height = pheight)
			plot(fixedt,data0.mean, main=paste(paths[ipath],': ',varnames[ivar],sep=''), xlab = b[1], ylab = y_label,xlim=c(-200,750), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid') 
			lines(fixedt,data0.975,lwd=linwd1,col='blue',lty='dashed')
			lines(fixedt,data0.025,lwd=linwd1,col='blue',lty='dashed')             
			points(true_t,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
			#legend("topleft",c("Mean","95% CI",'True'), lty=c('solid','dashed','solid'),col=c('red','blue','black'),lwd=c(linwd1,linwd1,linwd1),pch=c(-1,-1,1), bty='n')
			dev.off() 
		}	
	}
}

