rm(list=ls())
library(rhdf5)
nsim = 3000
material.file = "../../facies/facies.model.2/reference/T3_Slice_material.h5"

west = 0
east = 143.2
south = 0
north = 1
top = 110.0
bottom = 90.0

dx = c(rev((0.1*1.095415574**(1:48))),rep(0.1,532))
dy = 1.0
dz = c(rev(0.05*1.09505408**(1:25)),rep(0.05,300))

nx = length(dx)
ny = length(dy)
nz = length(dz)

x = west+cumsum(dx)-0.5*dx
y = south+cumsum(dy)-0.5*dy
z = bottom+cumsum(dz)-0.5*dz

threshold = 1.055012e-12
for (iperm in 1:nsim) {
    load(paste("../../heterogenous/data/perm.",iperm,".r",sep=''))
    perm = alluvium

    indicator = array(rep(0,nx*nz),c(nx,nz))
    net.code = array(rep(0,nx*nz),c(nx,nz))
    indicator[which(perm>threshold)] = 1
    indicator[which(perm<=threshold)] = 0

    material.ids = h5read(material.file,"Materials/Material Ids")
    material.ids = array(material.ids,c(nx,nz))
    indicator[which(material.ids!=5)] = 0

    net.index = 0    
    net.list = list()
    for (iz in 1:nz) {

        for (ix in 1:nx) {
            
            if(indicator[ix,iz]>0) {
                if(ix==1) {
                    net.index = net.index+1
                    net.list[[as.character(net.index)]] = c(ix,iz)                
                    net.code[ix,iz] = net.index                
                }else if(indicator[ix-1,iz] == 0) {
                    net.index = net.index+1
                    net.list[[as.character(net.index)]] = c(ix,iz)                
                    net.code[ix,iz] = net.index
                }else {
                    net.list[[as.character(net.index)]] = rbind(net.list[[as.character(net.index)]],c(ix,iz))
                    net.code[ix,iz] = net.index                                
                }
            }


        }
        
    }


    for (inet in 1:length(net.list)) {
        net.list[[inet]] = array(c(net.list[[inet]]),c(length(net.list[[inet]])%/%2,2))
    }
    

    ##finished.code = c()
    for (ix in 1:nx) {
        for (iz in 2:nz) {


            if(net.code[ix,iz]*net.code[ix,iz-1]>0 &
               net.code[ix,iz]!=net.code[ix,iz-1]) {

                
                net.list[[as.character(net.code[ix,iz-1])]] = rbind(net.list[[as.character(net.code[ix,iz-1])]],
                                                                    net.list[[as.character(net.code[ix,iz])]])
                
                ##find list of points to change
                points.to.alter = net.list[[as.character(net.code[ix,iz])]]

                ##remove old code from list
                net.list[[as.character(net.code[ix,iz])]]=NULL

                ##re-coding
                net.code[points.to.alter]=net.code[ix,iz-1]

            }


        }

    }


    ori.code = as.integer(names(sort(table(net.code),decreasing=TRUE)))
    ori.code = ori.code[which(ori.code>0)]
    ori.code = c(0,ori.code)
    nbody = length(ori.code)
    temp = net.code
    for (ibody in 1:nbody) {
        net.code[which(temp==ori.code[ibody])] = ibody-1
    }    

    temp = net.list
    net.list = list()
    for (ibody in 1:nbody) {
        net.list[[as.character(ibody-1)]] = temp[[as.character(ori.code[ibody])]]
    }    



save(net.code,file=paste("results/alluvium/code.",iperm,".r",sep=''))
    ## net.code.1 = net.code
    ## n.major.body = 10
    ## net.code.1[which(net.code>n.major.body)] = 0

    ## jpegfile=paste("./figures/allu_geobody",iperm,"_1e_12_10",".jpg",sep="")
    ## jpeg(jpegfile,width=8,height=3.8,units='in',res=1200,,quality=100)
    ## image(x,z,net.code.1,asp=1.0,#color=topo.colors(2),
    ##       xlab="x(m)",
    ##       ylab="z(m)",
    ##       xlim=c(90,144),
    ##       ylim=c(100,108),
    ##       breaks = c(0.5,1:n.major.body+0.5),
    ##       col=rainbow(n.major.body),
    ##       main=paste("Threshold = 1e-12m^2,","N Bodies = 10",": Realization=",iperm)
    ##       )
    ## dev.off()

}
