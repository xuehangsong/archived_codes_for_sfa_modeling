rm(list=ls())
load("statistics/parameters.r")

nreaz = 6
th.data = list()
tran.data = list()


for (ireaz in 1:nreaz)
{
    print(ireaz)
    output.file = readLines(paste("output.backup/",ireaz,".out",sep=""))
    simple.file = output.file[-grep("2r",output.file)]
    simple.file = simple.file[-(1:grep("Finished Initialization",simple.file))]
    simple.file  = simple.file[which(simple.file!="")]

    th.line = grep("== TH FLOW ====",simple.file)
    tran.line = grep("== REACTIVE TRANS",simple.file)
    tranth.line = grep("==",simple.file)


    th.line.end = tranth.line[match(th.line,tranth.line)+1]-1
    tran.line.end = tranth.line[match(tran.line,tranth.line)+1]-1
    tran.line.end[length(tran.line.end)] = length(simple.file)


    th.file = simple.file[unlist(mapply(":",th.line,th.line.end))]
    tran.file = simple.file[unlist(mapply(":",tran.line,tran.line.end))]

    ## iter.line =  simple.file[apply(th.line,1,function)]

    time.line = grep("snes_conv_reason",th.file)
    th.time = as.numeric(substr(th.file[time.line],19,32))
    iter.line = grep("newton =",th.file)
    th.newton = as.numeric(substr(th.file[iter.line],11,15))
    th.linear = as.numeric(substr(th.file[iter.line],35,41))


    th.data[[ireaz]] = cbind(th.time,th.newton,th.linear)
    
    time.line = grep("snes_conv_reason",tran.file)
    tran.time = as.numeric(substr(tran.file[time.line],19,32))
    iter.line = grep("newton =",tran.file)
    tran.newton = as.numeric(substr(tran.file[iter.line],11,15))
    tran.linear = as.numeric(substr(tran.file[iter.line],35,41))

    tran.data[[ireaz]] = cbind(head(tran.time,-2),
                               head(tran.newton,-2),
                               head(tran.linear,-2))

    
}

jpeg(file="th_linear_iter.jpeg",width=6,height=4,units="in",res=200,quality=100)
plot(th.data[[1]][,1]*3600+start.time,th.data[[1]][,3],type="l",
     axes=FALSE,
     xlab="",
     ylab=""
     )
axis.POSIXct(1,at=time.ticks,format="%Y")
axis(2)
mtext("Time",1,line=2)
mtext("Iteration number",2,line=2)
mtext("TH flow, linear solver")
box()
dev.off()



jpeg(file="th_newton_iter.jpeg",width=6,height=4,units="in",res=200,quality=100)
plot(th.data[[1]][,1]*3600+start.time,th.data[[1]][,2],type="l",
     axes=FALSE,
     xlab="",
     ylab=""
     )
axis.POSIXct(1,at=time.ticks,format="%Y")
axis(2)
mtext("Time",1,line=2)
mtext("Iteration number",2,line=2)
mtext("TH flow, newton solver")
box()
dev.off()




jpeg(file="tran_linear_iter.jpeg",width=6,height=4,units="in",res=200,quality=100)
plot(tran.data[[1]][,1]*3600+start.time,tran.data[[1]][,3],type="l",
     axes=FALSE,
     xlab="",
     ylab=""
     )
axis.POSIXct(1,at=time.ticks,format="%Y")
axis(2)
mtext("Time",1,line=2)
mtext("Iteration number",2,line=2)
mtext("Transport flow, linear solver")
box()
dev.off()



jpeg(file="tran_newton_iter.jpeg",width=6,height=4,units="in",res=200,quality=100)
plot(tran.data[[1]][,1]*3600+start.time,tran.data[[1]][,2],type="l",
     axes=FALSE,
     xlab="",
     ylab=""
     )
axis.POSIXct(1,at=time.ticks,format="%Y")
axis(2)
mtext("Time",1,line=2)
mtext("Iteration number",2,line=2)
mtext("Transport, newton solver")
box()
dev.off()


