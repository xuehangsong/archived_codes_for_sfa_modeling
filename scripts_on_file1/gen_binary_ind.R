#this file is used to generate binary indicator field using conditional indicator simulation	
Indicator_data = read.table('Conditioning_Litho_Binary.txt',skip=1)
#change the locations of conditioning points to grid center
Indicator_data[,1] = 0.5*(round(Indicator_data[,1]-0.5)+round(Indicator_data[,1]+0.5))
Indicator_data[,2] = 0.5*(round(Indicator_data[,2]-0.5)+round(Indicator_data[,2]+0.5))

colnames(Indicator_data) = c("x","y","z","indicator")
 
domain3D.grid = expand.grid(seq(0.5,119.5),seq(0.5,119.5),seq(95.25,109.75,0.5))
colnames(domain3D.grid)=c('x','y','z')
library(gstat)
v_litho = variogram(indicator~1,locations=~x+y+z,Indicator_data,alpha = 0, beta = 0,tol.hor = 90, tol.ver = 5, cutoff = 70, width = 7)
m_litho = fit.variogram(v_litho,vgm(1.2,"Gau",20,0.1))
#plot(v_litho,model=m_litho)
covm = vgm(0.12,"Gau",55.5,0.04,anis = c(0,0,0,1,0.1))
#conditional simulation for the indicator field
g_ind = gstat(formula=indicator~1,locations=~x+y+z,data=Indicator_data,model=covm,nmax = 20)
set.seed(36248)
ind_3D = predict(g_ind, domain3D.grid,nsim = 500,indicators = T)
write.table(ind_3D,file="Binary_Indicators_3D.txt",row.names=F)	
if(FALSE)
{
	# find the modal realization
	modal_ind = matrix(NA,nrow = nrow(domain3D.grid),ncol=4)
	modal_ind[,1:3] = domain3D.grid
	for(i in 1:nrow(domain3D.grid))
		modal_ind[i,4] = round(mean(ind_3D[i,4:503],na.rm=T))
	write.table(modal_ind,file="Modal_Binary_Indicators_3D.txt",row.names=F)
}
