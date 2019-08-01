rm(list=ls())
load("statistics/parameters.r")

mass.data = list()
nreaz=6
for (ireaz in 1:nreaz)
{
    header = read.table(paste(ireaz,"/2duniform-mas.dat",sep=''),
                        nrow=1,sep=",",header=FALSE,stringsAsFactors=FALSE)
    mass.data[[ireaz]] = read.table(paste(ireaz,"/2duniform-mas.dat",sep=''),
                                    skip=1,header=FALSE,fill=TRUE)
    colnames(mass.data[[ireaz]]) = header
}

vari.names = colnames(mass.data[[ireaz]]) 
## nrow = length(mass.data[[1]][,1])
## ncol = length(mass.data[[1]][1,])
## index = 7268
## mass.data[[1]][index:nrow,2:ncol] = mass.data[[1]][index:nrow,2:ncol] - t(replicate(length(index:nrow),as.numeric(mass.data[[1]][index,2:ncol] - mass.data[[1]][index-1,2:ncol])))



for (ivari in 2:length(header))
{
    range = range(
        mass.data[[3]][,ivari],
        mass.data[[3]][,ivari],    
        mass.data[[3]][,ivari],
        mass.data[[3]][,ivari],
        mass.data[[4]][,ivari],
        mass.data[[5]][,ivari]    
    )
    temp = gsub(" ","",header[ivari])
    temp = gsub("/","",temp)
    fname = paste("figures/",temp,".jpg",sep="")    
    jpeg(fname,width=10,height=4,units="in",res=200,quality=100)
    plot(mass.data[[ireaz]][,1]*3600+start.time,mass.data[[ireaz]][,ivari],
         type="l",col="white",
         xlab="",
         ylab="",
         ylim=range,     
         main = header[ivari],
         axes=FALSE
         )
    box()
    color = c("black","grey","blue","green","orange","red")
    for (ireaz in 1:nreaz)
    {
        lines(mass.data[[ireaz]][,1]*3600+start.time,mass.data[[ireaz]][,ivari],col=color[ireaz])
    }

    axis.POSIXct(1,at=time.ticks,format="%Y-%m");
    axis(2);
    mtext("Time",1,line=2)
    mtext(header[ivari],2,line=2)
    legend("topleft",c("1 hour","3 hours","12 hours","24 hours","7 days","30 days"),lty=1,lwd=2,
           col=color,bty="n"
           )
    dev.off()

}


###stop()
###a=mass.data[[1]][["river Riv_Tracer [mol]"]]
