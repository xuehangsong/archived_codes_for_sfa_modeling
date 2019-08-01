
#This file is used for comparing boundary conditions prior and post to EnKF update

rm(list=ls())

output_folder = 'BC_CondSim_Mar2011_wo121A'
BCfile_ext = '_Exp_drift0_Mar2011_192to291h.txt'
subdir_plot = 'plots'
subdir_data = 'data'

#create the folders if they do not exist
if (!file.exists(output_folder))
    dir.create(output_folder)
if (!file.exists(file.path(output_folder,subdir_plot)))
    dir.create(file.path(output_folder, subdir_plot))
if (!file.exists(file.path(output_folder,subdir_data)))
    dir.create(file.path(output_folder, subdir_data))

linwd1 = 1.5
linwd2 = 1.5
pwidth = 10
pheight = 10
plotfile = '.jpg'
#load the prior samples of the boundary conditions
#the start and end of boundary conditions to be updated
i_BC_start = 1
i_BC_end = 97

ngrid_BC = 480
ngrid4 = ngrid_BC/4
nsamp = 500
nt_BC = i_BC_end - i_BC_start + 1
BC_par_prior = matrix(0,ngrid_BC*nt_BC,nsamp)

for(ifield in 1:nsamp)
{
	BC_filename = paste(file.path(output_folder,subdir_data),'/BC_Data_Rel',ifield,BCfile_ext,sep='')
	BC_temp = read.table(BC_filename)
	BC_par_prior[,ifield] = c(as.matrix(BC_temp[,i_BC_start:i_BC_end]))
}

#the posterior samples of boundary conditions
BC_par_post = read.table(paste(output_folder,'/BC_Post_samples_96h.txt',sep=''))

for(i in i_BC_start:i_BC_end)
{
	H_2d_prior = BC_par_prior[((i-1)*ngrid_BC+1):(i*ngrid_BC),]
	H_2d_post = BC_par_post[((i-1)*ngrid_BC+1):(i*ngrid_BC),]	

	#cat(iset,'\t',min_error,'\t',ceiling(min_error/400),'\t', min_error%%400,'\n')
	jpeg(paste(file.path(output_folder,subdir_plot),'/Compare_BC_prior_post',(i+190),plotfile, sep = ''), width = pwidth, height = pheight,units="in",res=150,quality=100)
	par(mfrow=c(2,2))
	H_lim = c(min(min(H_2d_prior,na.rm=T),min(H_2d_post,na.rm=T)),max(max(H_2d_prior,na.rm=T),max(H_2d_post,na.rm=T)))
	#South boundary
	plot(seq(0,119), H_2d_prior[1:ngrid4,1],  main=paste('t=',(i+190),' hour, South',sep=''),xlab = "South Coord (m)", ylab = "Elevation(m)", xlim=c(0,120),ylim=H_lim,type='l',frame.plot=F)	
	for (isamp in 2:nsamp)
		lines(seq(0,119),H_2d_prior[1:ngrid4,isamp])
	#add average line
	#lines(seq(0,119),rowMeans(H_2d_prior[1:ngrid4,]),col='red')
	#add posterior lines
	for (isamp in 1:nsamp)
		lines(seq(0,119),H_2d_post[1:ngrid4,isamp],col='red')	
	#north boundary
	plot(seq(0,119), H_2d_prior[(ngrid4+1):(ngrid4*2),1],  main=paste('t=',(i+190),' hour, North',sep=''),xlab = "North Coord (m)", ylab = "Elevation(m)", xlim=c(0,120),ylim=H_lim,type='l',frame.plot=F)	
	for (isamp in 2:nsamp)
		lines(seq(0,119),H_2d_prior[(ngrid4+1):(ngrid4*2),isamp])
	#add average line
	#lines(seq(0,119),rowMeans(H_2d_prior[(ngrid4+1):(ngrid4*2),]),col='red')
	#add posterior lines
	for (isamp in 1:nsamp)
		lines(seq(0,119),H_2d_post[(ngrid4+1):(ngrid4*2),isamp],col='red')	

	#west boundary
	plot(H_2d_prior[(ngrid4*2+1):(ngrid4*3),1], seq(0,119), main=paste('t=',(i+190),' hour, West',sep=''),ylab = "West Coord (m)", xlab = "Elevation(m)", ylim=c(0,120),xlim=H_lim,type='l',frame.plot=F)	
	for (isamp in 2:nsamp)
		lines(H_2d_prior[(ngrid4*2+1):(ngrid4*3),isamp], seq(0,119))
	#add average line
	#lines(rowMeans(H_2d_prior[(ngrid4*2+1):(ngrid4*3),]), seq(0,119),col='red')
	#add posterior lines
	for (isamp in 1:nsamp)
		lines(H_2d_post[(ngrid4*2+1):(ngrid4*3),isamp],seq(0,119),col='red')			

	#East boundary
	plot(H_2d_prior[(ngrid4*3+1):ngrid_BC,1], seq(0,119), main=paste('t=',(i+190),' hour, East',sep=''),ylab = "East Coord (m)", xlab = "Elevation(m)", ylim=c(0,120),xlim=H_lim,type='l',frame.plot=F)	
	for (isamp in 2:nsamp)
		lines(H_2d_prior[(ngrid4*3+1):ngrid_BC,isamp], seq(0,119))
	#add average line
	#lines(rowMeans(H_2d_prior[(ngrid4*3+1):ngrid_BC,]), seq(0,119),col='red')
	#add posterior lines
	for (isamp in 1:nsamp)
		lines(H_2d_post[(ngrid4*3+1):ngrid_BC,isamp],seq(0,119),col='red')		
	dev.off()

}
