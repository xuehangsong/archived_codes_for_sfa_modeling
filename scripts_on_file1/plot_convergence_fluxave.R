
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
path_prefix = '/files1/scratch/chenxy/120x120x30/Oct2009/A_MR_0/'

nfields = 1500     # total number of random fields
#sampsize = c(50,100,200,300,400,500,1000,1500)
#sampsize = c(1,15,150,300,1500)
#nfields=200
#sampsize=c(50,100,120,140,160,180,190,200)
#plot.colors = c('blue','coral4','darkmagenta','darkgreen','cyan4','darkred','mediumseagreen','darkorange')
#plot.colors = c('blue','darkmagenta','darkgreen','darkorange','darkred')
sampsize=c(15,150,1500)
plot.colors = c('darkgreen','darkorange','darkred')
nsize = length(sampsize)
#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 5
pheight = 5
plotfile = '.jpg'


#read the headers in the first file and determine what variables are available
a = readLines(paste(path_prefix, prefix_file,'R1',ext_file,sep=''),n=1)
b = unlist(strsplit(a,','))
nvar = length(b)-1 #the first column is time
varnames = b[-1]

#determine the times when the data are output and keep them consitent among realizations
data0 = read.table(paste(path_prefix, prefix_file,'R1',ext_file,sep=''),skip=1) # the first line is skipped
fixedt = data0[,1] 
nt = length(fixedt)

#initialize the data mtrix

alldata = matrix(0,nvar*nt,nfields)

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

fixedt = fixedt - 255.5
#######plots#################
for (ivar in 1:nvar)
{
	#locations of the data stored
	locs = ((ivar - 1) * nt + 1) : (ivar * nt)
	varsplit = unlist(strsplit(varnames[ivar],' '))
	well_name = varsplit[1]
	species = varsplit[2]
	truedata = matrix(NA,1,3)
#read in true data if it exists		
	true_exist = file.exists(paste(well_name,'_Oct2009TT.txt',sep=''))
	if(true_exist)
		truedata = read.table(paste(well_name,'_Oct2009TT.txt',sep=''),skip=1)
	true_t = truedata[,1]/60.0 #time units converted to hours
	if(length(grep('U',species)) > 0) 
	{
		trueBTC = truedata[,2]
		y_label = 'U(VI) [ug/L]'
		legend.loc = 'bottomright'
		y_convert = 238.0*1000000
	} 
	if(length(grep('T',species)) > 0) 
	{
		trueBTC = truedata[,3]/180.0
		y_label = 'Tracer C/C0'
		legend.loc = 'topright'
		y_convert = 1000.0/2.25
	}
	data0=alldata[locs,]
	data0 = data0 * y_convert	
	data0.mean=matrix(0,nt,nsize)
	data0.std=matrix(NA,nt,nsize)
	data0.025=matrix(NA,nt,nsize)
	data0.975=matrix(NA,nt,nsize)
	for (isize in 1:nsize)
	{
		if(sampsize[isize]>1)
			data0.mean[,isize] = rowMeans(data0[,(1:sampsize[isize])])
		if(sampsize[isize]==1)
			data0.mean[,isize] = data0[,1]
		if(sampsize[isize]>5)
		{
			data0.std[,isize] = sqrt(apply(data0[,(1:sampsize[isize])],1,var))
			data0.025[,isize]=apply(data0[,(1:sampsize[isize])],1,quantile,0.025)
			data0.975[,isize]=apply(data0[,(1:sampsize[isize])],1,quantile,0.975)
		}
	}
	ymin.mean = min(data0.mean,na.rm=T)
	ymax.mean = max(data0.mean,na.rm=T)
	yrange = ymax.mean - ymin.mean
	ymin.mean = ymin.mean - 0.1 * yrange
	ymax.mean = ymax.mean + 0.1 * yrange
	ymin.std = min(data0.std,na.rm=T)
	ymax.std = max(data0.std,na.rm=T)
	yrange = ymax.std - ymin.std
	ymin.std = ymin.std - 0.1 * yrange
	ymax.std = ymax.std + 0.1 * yrange
	if(true_exist)
	{
		ymax.mean = max(ymax.mean,max(trueBTC,na.rm=T))
		ymin.mean = min(ymin.mean,min(trueBTC,na.rm=T))
	}
	#plot the confidence intervals
	#png(paste(BC,'_',prefix_file,'_CI_', well_name,species, plotfile, sep = ''), width = pwidth, height = pheight)
	jpeg(paste(prefix_file,'_MeanConv_', well_name,species, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)

	plot(fixedt,data0.mean[,1], main=paste('Mean of ',varnames[ivar],sep=''), xlab = b[1], ylab = y_label,xlim=c(-200,750), ylim = c(ymin.mean, ymax.mean), type = "l",lwd = linwd1, col = plot.colors[1],lty = 'solid') 
	for(isize in 2:nsize)
	{	
		lines(fixedt,data0.mean[,isize],lwd=linwd1,col=plot.colors[isize],lty='solid')
	}	
	points(true_t,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
	legend(legend.loc,paste(sampsize), lty=rep('solid',nsize),col=plot.colors,lwd=rep(linwd1,nsize), bty='n')
	dev.off() 	
	
	jpeg(paste(prefix_file,'_StdConv_', well_name,species, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)

	plot(fixedt,data0.std[,1], main=paste('Std of ',varnames[ivar],sep=''), xlab = b[1], ylab = y_label,xlim=c(-200,750), ylim = c(ymin.std, ymax.std), type = "l",lwd = linwd1, col = plot.colors[1],lty = 'solid') 
	for(isize in 2:nsize)
	{	
		lines(fixedt,data0.std[,isize],lwd=linwd1,col=plot.colors[isize],lty='solid')
	}	
	legend(legend.loc,paste(sampsize), lty=rep('solid',nsize),col=plot.colors,lwd=rep(linwd1,nsize), bty='n')
	dev.off() 	

	#png(paste(BC,'_',prefix_file,'_CI_', well_name,species, plotfile, sep = ''), width = pwidth, height = pheight)
	jpeg(paste(prefix_file,'_CIConv_', well_name,species, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)

	plot(fixedt,data0.mean[,1], main=paste('Mean of ',varnames[ivar],sep=''), xlab = b[1], ylab = y_label,xlim=c(-200,750), ylim = c(ymin.mean, ymax.mean), type = "l",lwd = linwd1, col = plot.colors[1],lty = 'solid') 
	for(isize in 2:nsize)
	{	
		lines(fixedt,data0.mean[,isize],lwd=linwd1,col=plot.colors[isize],lty='solid')
	}	
	for(isize in 1:nsize)
	{	
		lines(fixedt,data0.025[,isize],lwd=linwd1,col=plot.colors[isize],lty='dashed')
		lines(fixedt,data0.975[,isize],lwd=linwd1,col=plot.colors[isize],lty='dashed')
	}	

	points(true_t,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
	legend(legend.loc,paste(sampsize), lty=rep('solid',nsize),col=plot.colors,lwd=rep(linwd1,nsize), bty='n')
	dev.off()
}

