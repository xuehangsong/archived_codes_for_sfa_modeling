
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files1/scratch/chenxy/120x120x30/Oct2009/'

BC = 'IFRC'
#paths = c(paste(BC,'_MR_0',sep=''),paste(BC,'_EQ_0',sep=''),paste(BC,'_EQ_1',sep=''))
paths = c(paste(BC,'_MR_0',sep=''),paste(BC,'_EQ_0',sep=''))
#paths = c(paste(BC,'_MR_0',sep=''))
npath = length(paths)
fields = seq(1,500)
nfields = length(fields)     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 5
pheight = 5
plotfile = '.jpg'
#pwidth = 4.5
#pheight = 4
#plotfile = '.eps'


#read the headers in the first file and determine what variables are available
for (ipath in 1:npath)
{
	path_prefix = paste(main_path,paths[ipath],'/',sep='')
	a = readLines(paste(path_prefix, prefix_file,'R',fields[1],ext_file,sep=''),n=1)
	b = unlist(strsplit(a,','))
	nvar = length(b)-1 #the first column is time
	varnames = b[-1]

	#determine the times when the data are output and keep them consitent among realizations
	data0 = read.table(paste(path_prefix, prefix_file,'R',fields[1],ext_file,sep=''),skip=1) # the first line is skipped
	fixedt = data0[,1] 
	nt = length(fixedt)

	#initialize the data mtrix

	alldata = matrix(0,nvar*nt,nfields)

	#read in all the data
	for(ifield in fields)
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
			alldata[locs,which(fields==ifield)] = interp 
		}
	}
	string = paste('alldata',ipath, '=alldata',sep='')
	eval(parse(text=string))
	string = paste('fixedt',ipath, '=fixedt-255.0',sep='')
	eval(parse(text=string))	
	string = paste('varnames',ipath,'=varnames',sep='')	
	eval(parse(text=string))

	#get data from mean field
        meandata = matrix(0,nvar*nt,1)

        #read from file
	meanfile = paste(path_prefix, 'MeanField/',prefix_file,'R1',ext_file,sep='')
        tempa = readLines(meanfile,n=1)
        tempb = unlist(strsplit(tempa,','))
        nvar_mean = length(tempb)-1 #the first column is time
        varnames_mean = tempb[-1]
        string = paste('varnames_mean',ipath,'=varnames_mean',sep='')
        eval(parse(text=string))


        data0 = read.table(meanfile,skip=1) # the first line is skipped
        t0 = data0[,1]
        #linearly interpolate the data at the given time points
        for (icol in 2:(nvar_mean+1))
        {
                ids = which(is.na(data0[,icol]) == 0) #the points used for interpolation
                interp = approx(t0,data0[ids,icol],xout = fixedt,rule = 2)$y
                #locations of the data will be stored
                locs = ((icol - 2) * nt + 1) : ((icol-1) * nt)
                meandata[locs,1] = interp
        }
        string = paste('meandata',ipath, '=meandata',sep='')
        eval(parse(text=string))
 
}


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
	true_file = paste('TrueData_Oct2009TT/',well_name,'_Oct2009TT.txt',sep='')	
	true_exist = file.exists(true_file)
	if(true_exist)
		truedata = read.table(true_file,skip=1)
	true_t = truedata[,1]/60.0 #time units converted to hours
	if(length(grep('U',species)) > 0) 
	{
		trueBTC = truedata[,2]
		y_label = 'U(VI) [ug/L]'
		y_convert = 238.0*1000000
		ymin = 0
		ymax = 50
	} 
	if(length(grep('T',species)) > 0) 
	{
		trueBTC = truedata[,3]/180.0
		y_label = 'Tracer C/C0'
		y_convert = 1000.0/2.25
		ymin = 0
		ymax = 1
	}
	#plot the confidence intervals
	for (ipath in 1:npath)
	{
		jpeg(paste(paths[ipath],'_',prefix_file,'_CI_', well_name,species, plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
		string = paste('data0=alldata',ipath,'[locs,]',sep='')
		eval(parse(text=string))
		string = paste('fixedt=fixedt',ipath,sep='')
		eval(parse(text=string))	
		data0 = data0 * y_convert
		data0.mean=rowMeans(data0)
		data0.025=apply(data0,1,quantile,0.025)
		data0.975=apply(data0,1,quantile,0.975)
		#mean data
                string = paste('varnames_mean=varnames_mean',ipath,sep='')
                eval(parse(text=string))
	
       		if(length(grep('U',species))>0)
                	ivar_mean = intersect(grep(well_name,varnames_mean),grep('UO2',varnames_mean))
        	if(length(grep('T',species))>0)
                	ivar_mean = intersect(grep(well_name,varnames_mean),grep(species,varnames_mean))
        	locs_mean = ((ivar_mean-1) *nt +1):(ivar_mean * nt)

                string = paste('meandata=meandata',ipath,'[locs_mean,1]',sep='')
                eval(parse(text=string))
		meandata = meandata * y_convert
		plot(fixedt,data0.mean, main=paste(paths[ipath],': ',varnames[ivar],sep=''), xlab = b[1], ylab = y_label,xlim=c(-200,750), ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = 'red',lty = 'solid') 
		lines(fixedt,data0.975,lwd=linwd1,col='blue',lty='dashed')
		lines(fixedt,data0.025,lwd=linwd1,col='blue',lty='dashed')             
		lines(fixedt,meandata,lwd=linwd1,col='darkgreen',lty='solid')             
		points(true_t,trueBTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
		#legend("topleft",c("Mean","95% CI",'True'), lty=c('solid','dashed','solid'),col=c('red','blue','black'),lwd=c(linwd1,linwd1,linwd1),pch=c(-1,-1,1), bty='n')
		dev.off() 	
	}
}

