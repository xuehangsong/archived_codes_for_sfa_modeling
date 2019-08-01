rm(list=ls())
jpeg("clay_proportion.jpg", width =4, height =4.6,units="in",res=600,quality=100)
barplot(c(0.3,0.23,0.37,0.3),ylim=c(0,0.4),
        density=20,col=c("grey","black","blue","red")
        )
lines(c(0,100),c(0.3,0.3),col="purple",lwd=2,lty=2)
box()

mtext("Clay proportion (-)",2,at=0.2,line=2)

mtext("True",1,at=0.7,line=0.0)
mtext("Prior",1,at=1.9,line=0.0)
mtext("Without\n recond.",1,at=3.1,line=1)
mtext("With\n recond.",1,at=4.3,line=1)

dev.off()


#jpeg("clay_mean_length.jpg", width =4, height =4.6,units="in",res=600,quality=100)
jpeg("clay_mean_length.jpg", width =4, height =4.6,units="in",res=600,quality=100)
barplot(c(300,198.2,376.2,309.7),ylim=c(0,400),
        density=20,col=c("grey","black","blue","red")

        )
lines(c(0,100),c(300,300),col="purple",lwd=2,lty=2)
box()

mtext("Clay mean length (m)",2,at=200,line=2)

mtext("True",1,at=0.7,line=0.0)
mtext("Prior",1,at=1.9,line=0.0)
mtext("Without\n recond.",1,at=3.1,line=1)
mtext("With\n recond.",1,at=4.3,line=1)


dev.off()


jpeg("clay_mean_thickness.jpg", width =4, height =4.6,units="in",res=600,quality=100)
barplot(c(20,13.8,35,22.9),ylim=c(0,40),
        density=20,col=c("grey","black","blue","red")
        )
lines(c(0,100),c(20,20),col="purple",lwd=2,lty=2)
box()

mtext("Clay mean thickness (m)",2,at=20,line=2)

mtext("True",1,at=0.7,line=0.0)
mtext("Prior",1,at=1.9,line=0.0)
mtext("Without\n recond.",1,at=3.1,line=1)
mtext("With\n recond.",1,at=4.3,line=1)
dev.off()



perm3 = read.table("../1/dainput/init_perm_vector.dat")
perm1 = read.table("../1/results/perm_vector.4")
perm2 = read.table("../2/results/perm_vector.4")

perm.matrix=array(NA,c(300,6))
perm.matrix[,1] = perm3[1:300,1]
perm.matrix[,2] = perm2[1:300,1]
perm.matrix[,3] = perm1[1:300,1]

perm.matrix[,4] = perm3[1:300,2]
perm.matrix[,5] = perm2[1:300,2]
perm.matrix[,6] = perm1[1:300,2]



#jpeg("perm_box.jpg", width =4, height =4.6,units="in",res=200,quality=100)
jpeg("perm_box.jpg", width =6, height =4.6,units="in",res=200,quality=100)
boxplot(perm.matrix,ylim=c(-13,-6),
        col=c("lightgrey","lightblue","pink"),
        density = 20,
        axes=FALSE,
        )
box()
axis(2,at=seq(-14,-6,2))
mtext("Prior",1,at=1,line=0.0,cex=0.8,col="black")
mtext("Without\n recond.",1,at=1.95,line=0.8,cex=0.8,col="blue")
mtext("With\n recond.",1,at=3.1,line=0.8,cex=0.8,col="red")

mtext("Prior",1,at=1+3,line=0.0,cex=0.8,col="black")
mtext("Without\n recond.",1,at=1.95+3,line=0.8,cex=0.8,col="blue")
mtext("With\n recond.",1,at=3+3.1,line=0.8,cex=0.8,col="red")

mtext(expression("Permeability (log, " ~ m^{2} ~ ")"),2,line=2)
lines(c(-3,100),c(-12,-12),col="purple",lwd=2,lty=3)
lines(c(-3,7),c(-9,-9),col="purple",lwd=2,lty=3)

## mtext("True Ringold permeability",1,at=1.9,line=-3,col="Purple",cex=0.8)
## mtext("True Hanford permeability",1,at=5.1,line=-8.4,col="Purple",cex=0.8)


mtext("True Ringold",1,at=1.9,line=-3.4,col="Purple",cex=0.8)
mtext("permeability",1,at=1.9,line=-2.5,col="Purple",cex=0.8)
mtext("True Hanford",1,at=5.1,line=-8.9,col="Purple",cex=0.8)
mtext("permeability",1,at=5.1,line=-8.,col="Purple",cex=0.8)

##mtext("Clay",1,at=5,line=-2,col="black")



## barplot(c(-9,-8,-9,-9),ylim=c(-0,-10))
## lines(c(0,100),c(-9,-9),col="purple",lwd=2,lty=2)
## box()

## mtext(expression("Sand permeability (log, " ~ m^{2} ~ ")"),2,at=-5,line=2)

## mtext("True",1,at=0.7,line=0.0)
## mtext("Prior",1,at=1.9,line=0.0)
## mtext("Without \n recond.",1,at=3.15,line=1)
## mtext("With \n recond.",1,at=4.35,line=1)
dev.off()





stop()


jpeg("sand_perm.jpg", width =4, height =4.6,units="in",res=200,quality=100)
barplot(c(-9,-8,-9,-9),ylim=c(-0,-10))
lines(c(0,100),c(-9,-9),col="purple",lwd=2,lty=2)
box()

mtext(expression("Sand permeability (log, " ~ m^{2} ~ ")"),2,at=-5,line=2)

mtext("True",1,at=0.7,line=0.0)
mtext("Prior",1,at=1.9,line=0.0)
mtext("Without \n recond.",1,at=3.15,line=1)
mtext("With \n recond.",1,at=4.35,line=1)
dev.off()



jpeg("clay_perm.jpg", width =4, height =4.6,units="in",res=200,quality=100)
barplot(c(-12,-11,-11.9,-12.1),ylim=c(-0,-13))
lines(c(0,100),c(-12,-12),col="purple",lwd=2,lty=2)
box()

mtext(expression("clay permeability (log, " ~ m^{2} ~ ")"),2,at=-6,line=2)

mtext("True",1,at=0.7,line=0.0)
mtext("Prior",1,at=1.9,line=0.0)
mtext("Without \n recond.",1,at=3.15,line=1)
mtext("With \n recond.",1,at=4.35,line=1)
dev.off()

