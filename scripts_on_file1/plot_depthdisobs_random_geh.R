
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files1/scratch/chenxy/120x120x30/Oct2009/'
# paths = c(paste(main_path,'A_MR_Oct2009_0/',sep=''),paste(main_path,'A_MR_Oct2009_1/',sep=''),paste(main_path,'A_EQ_Oct2009_0/',sep=''),paste(main_path,'A_EQ_Oct2009_1/',sep=''))

#paths = c('A_MR_0','A_MR_1','A_EQ_0','A_EQ_1','B_EQ_0','B_EQ_1','B_MR_0','B_MR_1')
paths = c('IFRC_MR_0','IFRC_MR_1','IFRC_EQ_0')
npath = length(paths)
nfields = 500     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_DepthDis'
ext_file = '.dat'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.0
pwidth = 10
pheight = 10
plotfile = '.jpg'
#pwidth = 4.5
#pheight = 4
#plotfile = '.eps'
wells = c('2-07','2-08','2-09','2-10','2-11','2-15','2-18')
nwell = length(wells)
#read the headers in the first file and determine what variables are available
for (ipath in 1:npath)
{
	path_prefix = paste(main_path,paths[ipath],'/',sep='')
	a = readLines(paste(path_prefix, prefix_file,'R1',ext_file,sep=''),n=1)
	b = unlist(strsplit(a,','))
	varnames = b
	Tracer_cols = grep('Tracer',varnames)
	n_tracer = length(Tracer_cols)
	UO2_cols = grep('UO2',varnames)
	n_UO2 = length(UO2_cols)

	#determine the times when the data are output and keep them consitent among realizations
	data0 = read.table(paste(path_prefix, prefix_file,'R1',ext_file,sep=''),skip=1) # the first line is skipped
	fixedt = data0[,1] 
	nt = length(fixedt)

	#initialize the data mtrix

	Tracerdata = matrix(0,n_tracer*nt,nfields)
	UO2data = matrix(0,n_UO2*nt,nfields)

	#read in all the data
	for(ifield in 1:nfields)
	{
    	#read from files
		data0 = read.table(paste(path_prefix, prefix_file,'R',ifield,ext_file,sep=''),skip=1) # the first line is skipped
		t0 = data0[,1]
    		#linearly interpolate the data at the given time points
		ct = 0
    		for (icol in Tracer_cols)
    		{
			ct = ct + 1
			ids = which(is.na(data0[,icol]) == 0) #the points used for interpolation
			interp = approx(t0,data0[ids,icol],xout = fixedt,rule = 2)$y
			#locations of the data will be stored
			locs = ((ct - 1) * nt + 1) : (ct * nt)
			Tracerdata[locs,ifield] = interp 
		}
		ct = 0
    		for (icol in UO2_cols)
    		{
			ct = ct + 1
			ids = which(is.na(data0[,icol]) == 0) #the points used for interpolation
			interp = approx(t0,data0[ids,icol],xout = fixedt,rule = 2)$y
			#locations of the data will be stored
			locs = ((ct - 1) * nt + 1) : (ct * nt)
			UO2data[locs,ifield] = interp 
		}
	}
	fixedt = fixedt - 255.0 #time zeroed at beginning of injection
	U_convert = 238.0*1000000
	T_convert = 1000.0/2.25
	UO2data = UO2data * U_convert
	Tracerdata = Tracerdata * T_convert
        Tracer.mean=rowMeans(Tracerdata)
        Tracer.std=sqrt(apply(Tracerdata,1,var))
        Tracer.025=apply(Tracerdata,1,quantile,0.025)
        Tracer.975=apply(Tracerdata,1,quantile,0.975)
        UO2.mean=rowMeans(UO2data)
        UO2.std=sqrt(apply(UO2data,1,var))
        UO2.025=apply(UO2data,1,quantile,0.025)
        UO2.975=apply(UO2data,1,quantile,0.975)

	#plots 
	for (iw in 1:nwell)
	{
		truedata = matrix(NA,1,3)
		true_exist = file.exists(paste('Well_',wells[iw],'_Oct2009TT.txt',sep=''))
		if(true_exist)
			truedata = read.table(paste('Well_',wells[iw],'_Oct2009TT.txt',sep=''),skip=1)
		true_t = truedata[,1]/60.0 #time units converted to hours
		true_Tracer = truedata[,3]/180.0
		true_UO2 = truedata[,2]
		#plot for tracer
		Tracer_titles = varnames[Tracer_cols]
		UO2_titles = varnames[UO2_cols]
		#columns for tracer at the well(relative to all tracer data)
		ids_tracer = grep(wells[iw],Tracer_titles)
		#columns for UO2 at the well(relative to all UO2 data)
		ids_UO2 = grep(wells[iw],UO2_titles)
		nplots_tracer = length(ids_tracer)
		nplots_UO2 = length(ids_UO2)
		locs_tracer = numeric(nplots_tracer*nt)
		locs_UO2 = numeric(nplots_UO2*nt)
		for (i in 1:nplots_tracer)
			locs_tracer[((i-1)*nt+1):(i*nt)] = ((ids_tracer[i]-1)*nt+1):(ids_tracer[i]*nt)
		for (i in 1:nplots_UO2)
			locs_UO2[((i-1)*nt+1):(i*nt)] = ((ids_UO2[i]-1)*nt+1):(ids_UO2[i]*nt)

 		#plot for tracer
        	ymin = min(Tracer.025[locs_tracer])
        	ymax = max(Tracer.975[locs_tracer])
		yrange = ymax -ymin
		ymin = ymin - 0.1 * yrange
		ymax = ymax +0.1 * yrange
		if(true_exist)
		{
			ymax = max(ymax,max(true_Tracer,na.rm=T))
			ymin = min(ymin,min(true_Tracer,na.rm=T))
		}
		#plot the confidence intervals
#		png(paste(paths[ipath], prefix_file,'_CI_Well_', wells[iw],'Tracer', plotfile, sep = ''), width = pwidth, height = pheight)
                jpeg(paste(paths[ipath],'_',prefix_file,'_CI_Well', wells[iw],Tracer_titles[ids_tracer[i]], plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
		par(mfrow = c(4,4))
		for (i in 1:nplots_tracer)
		{
			ilocs = ((ids_tracer[i]-1)*nt+1):(ids_tracer[i]*nt)
#			plot(fixedt,Tracer.mean[ilocs], main=paste(paths[ipath],': ',Tracer_titles[ids_tracer[i]],sep=''), xlab = b[1], ylab = 'Tracer C/C0',xlim=c(-200,750), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid') 
			plot(fixedt,Tracer.mean[ilocs], main="", xlab = "", ylab = "",xlim=c(-200,750), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid') 
			lines(fixedt,Tracer.975[ilocs],lwd=linwd1,col='blue',lty='dashed')
			lines(fixedt,Tracer.025[ilocs],lwd=linwd1,col='blue',lty='dashed')
			points(true_t,true_Tracer,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
		#legend("topleft",c("Mean","95% CI",'True'), lty=c('solid','dashed','solid'),col=c('red','blue','black'),lwd=c(linwd1,linwd1,linwd1),pch=c(-1,-1,1), bty='n')
		}
		dev.off()
                #plot for UO2
                ymin = min(UO2.025[locs_UO2])
                ymax = max(UO2.975[locs_UO2])
                yrange = ymax -ymin
                ymin = ymin - 0.1 * yrange
                ymax = ymax +0.1 * yrange
                if(true_exist)
                {
                        ymax = max(ymax,max(true_UO2,na.rm=T))
                        ymin = min(ymin,min(true_UO2,na.rm=T))
                }
                #plot the confidence intervals
#                png(paste(paths[ipath], prefix_file,'_CI_Well_', wells[iw],'UO2++', plotfile, sep = ''), width = pwidth, height = pheight)
                 jpeg(paste(paths[ipath],'_',prefix_file,'_CI_Well', wells[iw],UO2_titles[ids_UO2[i]], plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
                par(mfrow = c(4,4))
                for (i in 1:nplots_UO2)
                {
                        ilocs = ((ids_UO2[i]-1)*nt+1):(ids_UO2[i]*nt)
#                        plot(fixedt,UO2.mean[ilocs], main=paste(paths[ipath],': ',UO2_titles[ids_UO2[i]],sep=''), xlab = b[1], ylab = 'UO2++(ug/L)',xlim=c(-200,750), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid') 
                        plot(fixedt,UO2.mean[ilocs], main="", xlab = "", ylab = "",xlim=c(-200,750), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid') 
                        lines(fixedt,UO2.975[ilocs],lwd=linwd1,col='blue',lty='dashed')
                        lines(fixedt,UO2.025[ilocs],lwd=linwd1,col='blue',lty='dashed')
                        points(true_t,true_UO2,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
                #legend("topleft",c("Mean","95% CI",'True'), lty=c('solid','dashed','solid'),col=c('red','blue','black'),lwd=c(linwd1,linwd1,linwd1),pch=c(-1,-1,1), bty='n')
                }
                dev.off()
	}
}

