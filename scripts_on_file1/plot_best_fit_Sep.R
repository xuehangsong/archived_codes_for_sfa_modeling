
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files1/scratch/chenxy/Mar2009/60x60x30/'
grid_res = '60x60x30'
paths = c('A','B','C','D','E','F','G','H','IFRC2')
npath = length(paths)
nfields = 500     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 4 
pheight = 4
plotfile = '.jpg'
y_label = 'Tracer C/C0'
y_convert = 1000.0/1.19

truedata_all = read.table('Mar2009/TracerData_Mar2009.txt',header=T)
#read the headers in the first file and determine what variables are available
best_fit_indx = matrix(0,1,npath)
for (ipath in 1:npath)
{
	path_prefix = paste(main_path,paths[ipath],'/',sep='')
	a = readLines(paste(path_prefix, prefix_file,'R1',ext_file,sep=''),n=1)
	b = unlist(strsplit(a,','))
	nvar = length(b)-1 #the first column is time
	varnames = b[-1]
	truedata_t = matrix(NA,60,nvar)
	truedata_BTC = matrix(NA,60,nvar)
	nt_all = matrix(NA,1,nvar)
	for (ivar in 1:nvar)
	{
		varsplit = unlist(strsplit(varnames[ivar],' '))
		varsplit = unlist(strsplit(varsplit[1],'_'))
		well_name = varsplit[2]
		true_loc = which(truedata_all[,1] == well_name) 
		if(length(true_loc)>0)
		{
			true_t = truedata_all[true_loc,2]/60.0 #time units converted to hours
			true_BTC = truedata_all[true_loc,3]/95.0 
			nt_all[ivar] = length(which(true_t>0))
			truedata_t[(1:nt_all[ivar]),ivar] = true_t[which(true_t>0)]
			truedata_BTC[(1:nt_all[ivar]),ivar] = true_BTC[which(true_t>0)]	
		}

	}
	#initialize the sum of error

	min_error =1e10
	total_error = numeric(nfields)
	#read in all the data
	for(ifield in 1:nfields)
	{
    	#read from files
		data0 = read.table(paste(path_prefix, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
		t0 = data0[,1]-100.0  #simulation started from 100 hours prior to injection
		data0[,2:(nvar+1)] = data0[,2:(nvar+1)] * y_convert
		#linearly interpolate the data at the given time points
		for (icol in 2:(nvar+1))
		{
			if(is.na(nt_all[icol-1]) == 0)
			{
				ids = which(is.na(data0[,icol]) == 0) #the points used for interpolation
				interp = approx(t0,data0[ids,icol],xout = truedata_t[(1:nt_all[icol-1]),(icol-1)],rule = 2)$y
				observed = truedata_BTC[(1:nt_all[icol-1]),(icol-1)]
				total_error[ifield] = total_error[ifield] + sum((interp-observed)^2)
			}

		}
		if(total_error[ifield]<min_error)
		{
			min_error = total_error[ifield]
			best_fit_indx[ipath] = ifield
		}
	}
	save(total_error,file=paste('total_error_',grid_res,'_',paths[ipath],'.Rdata',sep=''))
	#plot the best fit with observed data
	data0 = read.table(paste(path_prefix, prefix_file,'R',best_fit_indx[ipath],ext_file,sep=''),skip=1) # the first line is skipped
	t0 = data0[,1] -100.0
	data0[,2:(nvar+1)] = data0[,2:(nvar+1)] * y_convert
	
	for(ivar in 1:nvar)
	{
                varsplit = unlist(strsplit(varnames[ivar],' '))
                varsplit = unlist(strsplit(varsplit[1],'_'))
                well_name = varsplit[2]

		jpeg(paste(main_path, paths[ipath],'_',grid_res,'_best_fit_',well_name, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
		ymax = max(max(data0[,(ivar+1)],na.rm=T),max(truedata_BTC[(1:nt_all[ivar]),ivar],na.rm=T))
		ymin = min(min(data0[,(ivar+1)],na.rm=T),min(truedata_BTC[(1:nt_all[ivar]),ivar],na.rm=T))
		plot(t0,data0[,(ivar+1)], main=paste(paths[ipath],': ',varnames[ivar],sep=''), xlab = b[1], ylab = y_label,xlim=c(0,300), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid') 
		points(truedata_t[(1:nt_all[ivar]),ivar],truedata_BTC[(1:nt_all[ivar]),ivar],col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
		dev.off()
	}
}




