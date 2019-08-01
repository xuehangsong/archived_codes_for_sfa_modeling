rm(list=ls())
load('interpolated.data.r')

write.csv(slice,file="units.csv")

jpeg(filename="slice.layer.jpg",width=10,height=8,units='in',res=200,quality=100)
plot(slice[["meshx"]],slice[["u1"]],
     type="l",
     lwd=2,
     col='black',
     xlim = c(0,143.2),
     ylim = c(55,140),
     xaxs="i",
     xlab="x(m)",
     ylab="z(m)",     
     asp=1
     )
box()

lines(slice[["meshx"]],slice[["u1"]],col="black")
polygon(c(slice[["meshx"]],rev(slice[["meshx"]])),
       c(rep(0,n.node),rev(slice[["u1"]])),
       col="lightblue")

lines(slice[["meshx"]],slice[["u2"]],col="black")


lines(slice[["meshx"]],slice[["u3"]],col='black')
polygon(c(slice[["meshx"]],rev(slice[["meshx"]])),
       c(rep(0,n.node),rev(slice[["u3"]])),
      ,col="blue")


lines(slice[["meshx"]],slice[["u4"]],col="black")
polygon(c(slice[["meshx"]],rev(slice[["meshx"]])),
        c(rep(0,n.node),rev(slice[["u4"]])),
        col="green")


lines(slice[["meshx"]],slice[["u7"]],col="black")
polygon(c(slice[["meshx"]],rev(slice[["meshx"]])),
        c(rep(0,n.node),rev(slice[["u7"]])),
        col="yellow")




lines(slice[["meshx"]],slice[["u9"]],col="black")
polygon(c(slice[["meshx"]],rev(slice[["meshx"]])),
        c(rep(0,n.node),rev(slice[["u9"]])),
        col="red")

lines(slice[["meshx"]],slice[["ringold.surface"]],col="red",lwd=3)

legend("topright",c("Hanford",
                   "Rufu_u3 Undesignated Ringold upper fine-grained unit",
                   "ReG2_u4 Ringold E gravel below Rufu and where Rufu is not present",
                   "Rlm_u7 Ringold Lower Mud unit (RLM)",
                   "TOB_u9 Top of Basalt",
                   "Ringold Surface"
                   ),
       pch=c(15,15,15,15,15,NA),
       lty=c(NA,NA,NA,NA,NA,1),
       col=c("lightblue","blue","green","yellow","red","red"),
       bty="n"
       )


dev.off()

