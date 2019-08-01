rm(list=ls())
library(rhdf5)
library(hydroGOF)
H5close()

original_h5  = "original/543_river.h5"
hete_h5  = "hete/543_river.h5"
   
group = "Time:  2.73973E-01 y"


original_data = h5read(original_h5,group)
hete_data = h5read(hete_h5,group)


vari_names = names(original_data)

for (ivari in vari_names)
{
    vari_rmse = rmse(c(original_data[[ivari]]),
                     c(hete_data[[ivari]]))
    print(paste(ivari,vari_rmse))

    jpeg(paste("figures/",ivari,".jpg",sep=''),width=5,height=5.5,units='in',res=300,quality=100)    
    plot(original_data[[ivari]],
         hete_data[[ivari]],
         asp=1,
         xlim=range(original_data[[ivari]],hete_data[[ivari]]),
         ylim=range(original_data[[ivari]],hete_data[[ivari]]),
         xlab = paste("Original: ",ivari),
         ylab = paste("Mapped: ",ivari)         
         )
    lines(c(-1e10,1e10),c(-1e10,1e10),col="red")
    dev.off()
}
