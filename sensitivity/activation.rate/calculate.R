rm(list=ls())
k1=c(28.26,23.28,84.78)
t1=26+273.15
t2=25+273.15
k2=k1*exp(62.715*1000/8.315*(1/t1-1/t2))

##25.97  21.39  77.90

rates = c()
temps = seq(0,25,0.1)
for (t2 in temps)
{
    t2 = t2+273.15
    k2=k1*exp(62.715*1000/8.315*(1/t1-1/t2))
    rates = rbind(rates,k2)
}    


jpeg("rate.jpg",height=5,width=5,units="in",res=300,quality=100)
par(mar=c(3,3,1,1))
plot(temps,rates[,1],type="l",lwd=2,ylim = c(0,90),
     axes=FALSE,
     xlab=NA,
     ylab=NA,
     )
box()
lines(temps,rates[,2],col="red",lwd=2)
lines(temps,rates[,3],col="blue",lwd=2)
axis(1,mgp=c(1,0.6,0))
axis(2,mgp=c(1,0.6,0))
mtext("Temperatuxre",1,line=1.5)
mtext(expression(Xuehang %.% Song ^1 song),1)
##mtext("Reaction rates [mmol/mmol BM/d]",2,line=2)

legend(-1,95,c(
                 expression(paste("CH"[2],"O + 2NO"[3]^"-"," = 2NO"[2]^"-"," + CO"[2]," + H"[2],"O")),
                 expression(paste("CH"[2],"O + 4/3NO"[2]^"-","+ 4/3H"^"+"," = 2/3N"[2]," + CO"[2]," + 5/3H"[2],"O")),
                 expression(paste("CH"[2],"O + O"[2]," = CO"[2]," + H"[2],"O"))
               ),
       col=c("black","red","blue"),
       lwd=2,
       bty="n")
dev.off()
