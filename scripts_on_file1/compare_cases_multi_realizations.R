
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy'
#comp_paths = c('Mar2011/IFRC2_MR_0_Prior_NewComplexPar_LowSite/MeanField','Mar2011/IFRC2_MR_0_Prior_NewComplexPar/MeanField','Mar2011/IFRC2_MR_0_Prior_NewComplexPar_HighSite/MeanField')
#comp_legends = c('1.5264','15.264','152.64')
#comp_col = c('red','blue','darkgreen')
#comp_paths = c('IFRC2_MR_0_Prior/MeanField','IFRC2_MR_1_Prior/MeanField','IFRC2_MR_0_Prior_highIC/MeanField')
#comp_legends = c('IFRC2_MR_0','IFRC2_MR_1','High_Inital_U')
#comp_col = c('red','blue','darkgreen')
comp_paths = c('UK_MR_0_Mar2011','UK_MR_0_Mar2011')
#comp_paths = c('Premodel_Oct2011_10gpm','Premodel_Oct2011_25gpm','Premodel_Oct2011_50gpm','Premodel_Oct2011_100gpm','Premodel_Oct2011_150gpm')
#comp_paths = c('Premodel_Oct2011_10gpm_start191hr','Premodel_Oct2011_25gpm_start191hr','Premodel_Oct2011_50gpm_start191hr','Premodel_Oct2011_100gpm_start191hr','Premodel_Oct2011_150gpm_start191hr')
#comp_legends = c('10gpm','25gpm','50gpm','100gpm','150gpm')
#comp_col = c('black','red','blue','darkgreen','mediumorchid')
comp_legends = c('Good_Perm','Bad_Perm')
#comp_legends = c('1Inj','3Inj')
comp_col = c('red','blue')
#comp_paths = c('IFRC2_MR_0_Prior_highIC/MeanField','IFRC2_MR_0_Prior_highIC/MeanField_fine')
#comp_legends = c('High_Inital_U','High_Initial_U_finerVZ')
#comp_col = c('red','blue')
#comp_paths = c('IFRC2_Tracer_MeanField_BoundaryTracer/East','IFRC2_Tracer_MeanField_BoundaryTracer/West','IFRC2_Tracer_MeanField_BoundaryTracer/South','IFRC2_Tracer_MeanField_BoundaryTracer/North','IFRC2_Tracer_MeanField_BoundaryTracer/Injected')
#comp_legends = c('East','West','South','North','Initial')
#comp_col = c('red','blue','darkgreen','chocolate','plum')
testvariable = 'UO2'
BC = 'Kriged'
npath = length(comp_paths)
fields = c(11520,15677)
nfields = length(fields)     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'
DataSet = 'Mar2011TT'
plot_true = T   #whether to plot true observed curves
#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
pwidth = 26
pheight = 17
plotfile_name = 'Kriged_BC_'
plotfile = '_Mar2011_Good_Bad_Perm.jpg'
x_lim = c(0,1000)
NormTime_True = 1.0 #normalization factor for time of true data
#time_start = 255.5 # for Oct2009 test
time_start = rep(0.25,npath) # for Mar2011 test
#time_start = rep(191.25,npath) # for Mar2011 test
#time_start = rep(24,npath) # for Mar2011 test
#time_start = c(24,191.25) # for Mar2011 test
MeanData_exist = 0 #whether results from mean field exist
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
#	NormConc_True = 100.0  # 19Oct2011 test
#	y_convert = 1000.0/2.8169 #19Oct2011 test, injected tracer
#	y_convert = 1000.0 #for boundary tracer
}
wells_plot = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
			'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
			'3-29','3-30','3-31','3-32','3-35','2-34','2-37')
nwell = length(wells_plot)

for(ifield in seq(1,nfields))
{
	for (ipath in 1:npath)
	{
		path_prefix = paste(main_path,'/',comp_paths[ipath],'/',sep='')
		input_file = paste(path_prefix, prefix_file,'R',fields[ifield],ext_file,sep='')
		a = readLines(input_file,n=1)
		b = unlist(strsplit(a,','))
	
		nvar = length(b)-1 #the first column is time
		varnames = b[-1]
		#find the columns needed
		varcols = array(NA,nwell,1)
		for (iw in 1:nwell)
			varcols[iw] = intersect(grep(wells_plot[iw],varnames),grep(testvariable,varnames)) + 1 #the first column is time

		#read from files
		input_data = read.table(input_file,skip=1) # the first line is skipped

		data0 = matrix(0,nrow(input_data),(nwell+1))
		data0[,1] = input_data[,1]- time_start[ipath]
		for (ivar in 1:nwell)
			data0[,(ivar+1)] = input_data[,varcols[ivar]]
		data0[,2:(nwell+1)] = data0[,2:(nwell+1)] * y_convert
		
		#store data from different cases in different names
		text1 = paste('data',ipath,'=data0',sep='')
		eval(parse(text = text1))
	}
		

	jpeg(paste(main_path,'/',plotfile_name,testvariable,'_R',fields[ifield], plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
	par(mfrow=c(5,8))
	for (iw in 1:nwell)
	{
		well_name = wells_plot[iw]
		#find the maximum y among th cases
		ymin = 5000
		ymax = 0
		for (ipath in 1:npath)
		{
			text1 = paste('data0 = data',ipath,sep='')
			eval(parse(text = text1))
			ymax = max(max(data0[,(iw+1)],na.rm=T),ymax)
			ymin = min(min(data0[,(iw+1)],na.rm=T),ymin)
		}
		if(plot_true)
		{
			true_t = matrix(NA,1,1)
			true_BTC = matrix(NA,1,1)
			#read in true data if it exists
			true_file = paste('TrueData_',DataSet,'/Well_',well_name,'_',DataSet,'.txt',sep='')
			true_exist = file.exists(true_file)
			if(true_exist)
			{
				truedata = read.table(true_file,skip=1)
				true_t = truedata[,1]/NormTime_True #time units converted to hours
				true_BTC = truedata[,true_col]		
				if(length(grep('Tracer',testvariable)))
					true_BTC = true_BTC - mean(truedata[which(truedata[,1]<0),3])
				true_BTC = true_BTC/NormConc_True
				ymax = max(ymax,max(true_BTC,na.rm=T))
				ymin = min(ymin,min(true_BTC,na.rm=T))
			}
		}

		yrange = ymax - ymin
		ymax = ymax + 0.05*yrange
		ymin = ymin - 0.05*yrange
		#ymax = 1.1
		plot(data1[,1],data1[,(iw+1)], main=paste(BC,': ',wells_plot[iw],sep=''), xlab = b[1], ylab = y_label,xlim=x_lim, ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = comp_col[1],lty = 'solid')
		for(ipath in 2:npath) 
		{
			text1 = paste('data0 = data',ipath,sep='')
			eval(parse(text = text1))
			points(data0[,1],data0[,iw+1],col=comp_col[ipath],type = 'l',lty='solid',lwd=linwd1)
		}
		if(plot_true)
			points(true_t,true_BTC,col='black',type = 'b',lty='solid',lwd=linwd1,pch=1)
		#points(data0[,1],data1[,(iw+1)]+data2[,(iw+1)]+data3[,(iw+1)]+data4[,(iw+1)]+data5[,(iw+1)],type='l',lty='dashed')

	}
			
	plot(c(1,2),c(2,2),ylim=c(0,1),xlab="",ylab="",bty="n",axes = F)
	legend('topleft',comp_legends,lty=rep('solid',times = npath),col=comp_col,lwd=rep(linwd1,times=npath),bty='n',cex=1.7)
	dev.off()
}
