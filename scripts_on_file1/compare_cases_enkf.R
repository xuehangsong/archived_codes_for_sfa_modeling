
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy'
comp_paths = c('Tracer_Mar2011_Random_BC_191to291h','Tracer_Mar2011_Random_BC_191to262h')
plot_legend=T
comp_legends = c('Prior_Rel265','Post_Rel265')
comp_col = c('darkgreen','darkmagenta')
pwidth = 26
pheight = 17
testvariable = 'Tracer'
BC = 'Kriged'
npath = length(comp_paths)
fields = c(265,265)
nfields = length(fields)     # number of random fields
#prefix and extension of files
prefix_file = 'OBS_FluxAve'
ext_file = '.dat'
DataSet = 'Mar2011TT'
plot_true = T   #whether to plot true observed curves
#plotting specifications
linwd1 = 1.5
linwd2 = 1.5
plotfile_name = 'ENKF'
plotfile = '_191to262h_All_Wells.jpg'
#plotfile_name = 'HomoHeteroChem_'
#plotfile = '_Mar2011_select_WellsR11520.jpg'
x_lim = c(0,72)
NormTime_True = 1.0 #normalization factor for time of true data
time_start = rep(0.25,npath) # for Mar2011 test
#time_start = rep(24,npath) # for Mar2011 test
MeanData_exist = 0 #whether results from mean field exist
if(length(grep('UO2',testvariable)) > 0)
{
	true_col = 2
	NormConc_True = 1.0
	y_label = 'U(VI) [ug/L]'
	y_convert = 238.0*1000000
	true_color = 'chocolate'
	true_pch = 2

}
if(length(grep('Tracer',testvariable)) > 0)
{
	true_col = 3
	y_label = 'Tracer C/C0'
	true_color = 'black'
	true_pch = 1
#	norm_true = 180.0 #Oct 2009 test
#	y_convert = 1000.0/2.25  #Oct2009 test
	NormConc_True = 210.0  # Mar2011 test
	y_convert = 1000.0/5.9234 #Mar2011 test, injected tracer
#	NormConc_True = 100.0  # 19Oct2011 test
#	y_convert = 1000.0/2.8169 #19Oct2011 test, injected tracer
#	y_convert = 1000.0 #for boundary tracer
}
all_wells = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
			'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
			'3-29','3-30','3-31','3-32','3-35','2-34','2-37')
#wells_plot = c('2-07','2-08','2-14','2-26','2-27','2-28')
wells_plot = all_wells
nwell = length(wells_plot)
plot_nrow = 5 
plot_ncol = 8
#pwidth = 10.5
#pheight = 5.5

	for (ipath in 1:npath)
	{
		path_prefix = paste(main_path,'/',comp_paths[ipath],'/',sep='')
		input_file = paste(path_prefix, prefix_file,'R',fields[ipath],ext_file,sep='')
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
		

	jpeg(paste(main_path,'/',plotfile_name,testvariable,plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=250,quality=100)
	par(mfrow=c(plot_nrow,plot_ncol))
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
		ymax = max(ymax,0.1)
		ymin = max(ymin,0)
		#ymax = 1.1
		idx1 = which(data1[,1]>=0)
		plot(data1[idx1,1],data1[idx1,(iw+1)], main=paste(wells_plot[iw],sep=''), xlab = b[1], ylab = y_label,xlim=x_lim, ylim = c(ymin, ymax), type = "l",lwd = linwd1, col = comp_col[1],lty = 'solid',cex.main=1.7,cex.lab=1.7,cex.axis=1.7,bty='n')
		for(ipath in 2:npath) 
		{
			text1 = paste('data0 = data',ipath,sep='')
			eval(parse(text = text1))
			idx0 = which(data0[,1]>=0)
			points(data0[idx0,1],data0[idx0,iw+1],col=comp_col[ipath],type = 'l',lty='solid',lwd=linwd1)
		}
		if(plot_true)
			points(true_t,true_BTC,col=true_color,type = 'b',lty='solid',lwd=linwd1,pch=true_pch)
		#points(data0[,1],data1[,(iw+1)]+data2[,(iw+1)]+data3[,(iw+1)]+data4[,(iw+1)]+data5[,(iw+1)],type='l',lty='dashed')

	}
if(plot_legend)		
{
	plot(c(1,2),c(2,2),ylim=c(0,1),xlab="",ylab="",bty="n",axes = F)
	legend('topleft',comp_legends,lty=rep('solid',times = npath),col=comp_col[1:npath],lwd=rep(linwd1,times=npath),bty='n',cex=1.7)
}
dev.off()

