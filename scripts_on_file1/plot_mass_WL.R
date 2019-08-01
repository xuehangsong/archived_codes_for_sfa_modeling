
#This file is used for plotting mass fluxes at boundaries with multiple realizations

rm(list=ls())

#set the path to the files
main_path = '/Users/chen737/Work/Passive_2010_2011/'

#plotting specifications
linwd1 = 1.5
linwd2 = 1.0
pwidth = 10
pheight = 16

model_year = 2011

mass_file = paste('mass_balance_',model_year,'.dat',sep='')
plotfile_name = paste('Boundary_Fluxes_Passive',model_year, '.jpg',sep='')
if(model_year == 2010) WL_id = 9  # for 2010, well 2-10
if(model_year == 2011) WL_id = 8  # for 2011, well 2-10 

#read in water level data
time_upper = 4000  # hours after the beginning (Mar 17 15:00:00) + 1

WL_data=numeric(time_upper)
WL_t = seq(0,time_upper-1)

WL_folder = paste('/Users/chen737/Work/Data/headdata4krige_Passive',model_year, sep='')

for(i in 1:time_upper)
{
	temp = read.table(paste(WL_folder,'/time',i,'.dat',sep=''))
	WL_data[i] = temp[WL_id,3]
}


a = readLines(paste(main_path, mass_file,sep=''),n=1)
varnames = unlist(strsplit(a,','))

#read in mass balance data
mass_data = read.table(paste(main_path, mass_file,sep=''),skip=1)

#### find the indices of columns corresponding to 4 boundaries
east = grep('East', varnames)[2]
west = grep('West', varnames)[2]
south = grep('South', varnames)[2]
north = grep('North', varnames)[2]

ylow=min(mass_data[,c(east,north,west,south)],na.rm=T)
yupp=max(mass_data[,c(east,north,west,south)],na.rm=T)

###plot the fluxes along boundaries
jpeg(plotfile_name, width = pwidth, height = pheight,units="in",res=150,quality=100)
par(mfrow=c(4,1),mar=c(4,4,3,4))

plot(mass_data[,1],mass_data[,east],xlab='',ylab="",main='East',xlim=c(0,time_upper),ylim=c(ylow,yupp),type = "l",lwd = linwd1, col = 'black',lty = 'solid',axes=F)
lines(c(-50,time_upper+25),c(0,0),col='red')
axis(2,col="black",las=1,line=-2)  ## las=1 makes horizontal labels
mtext('Flux[kg/h]',side=2,line=2.5)
par(new=TRUE)
plot(WL_t,WL_data,xlab='',ylab="",xlim=c(0,time_upper),type = "l",lwd = linwd1, col = 'blue',lty = 'solid',axes=F)
yticks2 = pretty(min(WL_data,na.rm=T):max(WL_data,na.rm=T))
mtext("Water Level [m]",side=4,col="blue",line=1.5) 
axis(4, col="blue",col.axis="blue",las=2,at=yticks2,line=-2)
axis(1,at=seq(0,time_upper,100))
mtext("Time [Hours]",side=1,col="black",line=2.5) 

plot(mass_data[,1],mass_data[,north],xlab='',ylab="",main='North',xlim=c(0,time_upper),ylim=c(ylow,yupp),type = "l",lwd = linwd1, col = 'black',lty = 'solid',axes=F)
lines(c(-50,time_upper+25),c(0,0),col='red')
axis(2,col="black",las=1,line=-2)  ## las=1 makes horizontal labels
mtext('Flux[kg/h]',side=2,line=2.5)
par(new=TRUE)
plot(WL_t,WL_data,xlab='',ylab="",xlim=c(0,time_upper),type = "l",lwd = linwd1, col = 'blue',lty = 'solid',axes=F)
yticks2 = pretty(min(WL_data,na.rm=T):max(WL_data,na.rm=T))
mtext("Water Level [m]",side=4,col="blue",line=1.5) 
axis(4, col="blue",col.axis="blue",las=2,at=yticks2,line=-2)
axis(1,at=seq(0,time_upper,100))
mtext("Time [Hours]",side=1,col="black",line=2.5) 

plot(mass_data[,1],mass_data[,west],xlab='',ylab="",main='West',xlim=c(0,time_upper),ylim=c(ylow,yupp),type = "l",lwd = linwd1, col = 'black',lty = 'solid',axes=F)
lines(c(-50,time_upper+25),c(0,0),col='red')
axis(2,col="black",las=1,line=-2)  ## las=1 makes horizontal labels
mtext('Flux[kg/h]',side=2,line=2.5)
par(new=TRUE)
plot(WL_t,WL_data,xlab='',ylab="",xlim=c(0,time_upper),type = "l",lwd = linwd1, col = 'blue',lty = 'solid',axes=F)
yticks2 = pretty(min(WL_data,na.rm=T):max(WL_data,na.rm=T))
mtext("Water Level [m]",side=4,col="blue",line=1.5) 
axis(4, col="blue",col.axis="blue",las=2,at=yticks2,line=-2)
axis(1,at=seq(0,time_upper,100))
mtext("Time [Hours]",side=1,col="black",line=2.5) 

plot(mass_data[,1],mass_data[,south],xlab='',ylab="",main='South',xlim=c(0,time_upper),ylim=c(ylow,yupp),type = "l",lwd = linwd1, col = 'black',lty = 'solid',axes=F)
lines(c(-50,time_upper+25),c(0,0),col='red')
axis(2,col="black",las=1,line=-2)  ## las=1 makes horizontal labels
mtext('Flux[kg/h]',side=2,line=2.5)
par(new=TRUE)
plot(WL_t,WL_data,xlab='',ylab="",xlim=c(0,time_upper),type = "l",lwd = linwd1, col = 'blue',lty = 'solid',axes=F)
yticks2 = pretty(min(WL_data,na.rm=T):max(WL_data,na.rm=T))
mtext("Water Level [m]",side=4,col="blue",line=1.5) 
axis(4, col="blue",col.axis="blue",las=2,at=yticks2,line=-2)
axis(1,at=seq(0,time_upper,100))
mtext("Time [Hours]",side=1,col="black",line=2.5) 

dev.off()
