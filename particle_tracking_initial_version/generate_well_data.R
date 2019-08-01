rm(list=ls())
library(rhdf5)
load("data/simu_node.r")

start.time = 8760
end.time = 16206
###end.time = 8761

itime=0
group  = paste("/Time:  ",formatC(itime,digits=5,format="E")," h",sep="")
vari.name = names(h5read("flow/pflotran_bigplume.h5",group))
nvari =  length(vari.name)


dataset = paste(group,"/Liquid X-Velocity [m_per_h]",sep="")
ntime = length(start.time:end.time)

well.list = names(simu.node)
simu.results = list()
for (iwell in well.list)
{
    simu.results[[iwell]] = list()
    for (inode in 1:nrow(simu.node[[iwell]]))
    {
        simu.results[[iwell]][[inode]] = array(NA,c(ntime,nvari))
        colnames(simu.results[[iwell]][[inode]]) = vari.name
    }
}


for (itime in 1:ntime)
{
    print(itime)
    group  = paste("/Time:  ",formatC(start.time+itime-1,digits=5,format="E")," h",sep="")
    data = h5read("flow/pflotran_bigplume.h5",group)

    for (iwell in well.list)
    {
        for (inode in 1:nrow(simu.node[[iwell]]))
        {
            for (ivari in vari.name)
            {
                ix=simu.node[[iwell]][inode,"x"]
                iy=simu.node[[iwell]][inode,"y"]
                iz=simu.node[[iwell]][inode,"z"]                                
                simu.results[[iwell]][[inode]][itime,ivari] = data[[ivari]][iz,iy,ix]
            }
        }
    }


    
}
save(list=ls(),file="wells.r")
