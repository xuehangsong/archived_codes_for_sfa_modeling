
#This file is used for plotting flux averaged concentrations with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/files2/scratch/chenxy/'
#paths = c('Tracer_Mar2011_UK_Binary_Modal','Tracer_Mar2011_UK_Binary_Rel5','Tracer_Mar2011_UK_Binary_Rel10')
paths = c('Tracer_Mar2011_UK3_KrigeFields_Inj5','Tracer_Mar2011_UK3_Inj5_0to800h_Err30_Iter2','Tracer_Mar2011_UK3_Inj5_400to600h_Err30_Iter3','Tracer_Mar2011_UK3_Inj5_400to450h_Err20_Iter9')
npath = length(paths)
plotfile_name = 'Comp_RMSE_PDF_Set1.jpg'
legends = c('Prior','Batch_Iter2','4_Seg','16_Seg')
plot_legend = T
plot_cols = c('black','darkgreen','purple','red')
#pwidth = 26
#pheight = 17
#plot_nrow = 6
#plot_ncol = 6

pwidth = 12
pheight = 14
plot_nrow = 6
plot_ncol = 4
linwd = 2.5
tick_size = 15
fields = c(1:600)
nfields = length(fields)     # number of random fields
#prefix and extension of files

wells_all = c('2-07','2-08','2-09','2-11','2-12','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-20','2-21',
'2-22','2-23','2-24','2-26','2-27','2-28','2-29','2-30','2-31','3-23','3-24','3-25','3-27','3-28',
'3-29','3-30','3-31','3-32','3-35','2-34','2-37')

well_set1 = c('2-07','2-11','2-13','2-14','2-15','2-16','2-17','2-18','2-19','2-21','2-23','2-24','2-26','2-27','2-29','2-30','2-37','3-25','3-28','3-29','3-30','3-32','3-35')
wells = well_set1
wells_idx = match(wells,wells_all)
nwell = length(wells_idx)
time_upper = 1000
data_ext = paste('to',time_upper,'hr.Rdata',sep="")

for (ipath in 1:npath)
{
        path_prefix = paste(main_path,paths[ipath],'/',sep='')
        load(paste(path_prefix,'Square_error_',data_ext,sep=''))
	RMSE = matrix(0,nrow(SE_all),nwell) #squared error in all wells for all the realizations
	RMSE = SE_all[,wells_idx]
	nt_obs_1 = nt_obs[wells_idx]
	for(iwell in 1:nwell)
		RMSE[,iwell] = sqrt(RMSE[,iwell] / nt_obs_1[iwell])
	string1 = paste('RMSE_',ipath,'=RMSE',sep='')
	eval(parse(text=string1))
}


jpeg(paste(main_path,plotfile_name, sep = ''), width = pwidth, height = pheight,units="in",res=250,quality=100)
par(mfrow=c(plot_nrow,plot_ncol))
for (iw in 1:nwell)
{
	xmin = 10000
	xmax = 0
	ymin = 1e15
	ymax = 0
	for (ipath in 1:npath)
	{
		string1 = paste('RMSE=RMSE_',ipath,sep='')
		eval(parse(text=string1))
		dens = density(RMSE[,iw],bw='nrd')
		#find the x values with non-negligible pdf values
		idx_x = which(dens$y > 0.08*max(dens$y,na.rm=T))
		xmin = min(min(dens$x,na.rm=T),xmin)
		xmax = max(max(dens$x[idx_x],na.rm=T),xmax)
		ymin = min(min(dens$y,na.rm=T),ymin)
		ymax = max(max(dens$y,na.rm=T),ymax)
	}

	xrange = xmax -xmin
	xmin = xmin - 0.1 * xrange
	xmin = max(xmin,0)
#xmax = xmax +0.1 * xrange
	yrange = ymax -ymin
	ymin = ymin - 0.1 * yrange
	ymin = max(ymin,0)
	ymax = ymax + 0.1 * yrange
	#plot
	plot(density(RMSE_1[,iw],bw='nrd'), main = wells[iw],xlim = c(xmin, xmax),ylim = c(ymin,ymax),xlab = 'RMSE of C/C0',ylab = 'Density',axes=F,lty=1,col=plot_cols[1],cex.axis = 1.8,cex.lab=1.3)
	axis(1, lty='solid',font=tick_size)
	axis(2, lty='solid',font=tick_size)
	for (ipath in 2:npath)
	{
		string1 = paste('RMSE=RMSE_',ipath,sep='')
		eval(parse(text=string1))
		#
		lines(density(RMSE[,iw],bw='nrd'),lty = ipath, col = plot_cols[ipath])
	}
}
if(plot_legend)
{
       	plot(c(1,2),c(2,2),ylim=c(0,1),xlab="",ylab="",bty="n",axes = F)
       	legend('topright',legends,lty=c(1:4),col=plot_cols[1:npath],lwd=rep(linwd,times=npath),bty='n',cex=1.7)
}
dev.off() 
     
