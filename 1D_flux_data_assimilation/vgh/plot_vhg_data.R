rm(list=ls())
library(xts)

load("vhg_case/results/vhg_data.r")

temp_color = c("red","orange","green","blue")
plot(index(thermistor.output),thermistor.output[,1],
     type="l",col="white",
     ylim=range(thermistor.output))
#for (itemp in 1:length(thermistor.depth))
for (itemp in 1:3)    
{
    lines(index(thermistor.output),thermistor.output[,itemp],
          col=temp_color[itemp]
          )
}
