rm(list=ls())

value = 1
input.dir = "openfoam/"
ntime = 200
for (itime in 1:ntime)
{

    data = read.table(
        paste(input.dir,"press_",itime,".dat",sep=""),
        header=F,
        skip = 27)


    print(paste(itime,max(abs(data[,1:3]-value))))

    
    x = sort(as.numeric(names(table(data[,1]))))
    y = sort(as.numeric(names(table(data[,2]))))
    z = sort(as.numeric(names(table(data[,3]))))
    nx = length(x)
    ny = length(y)
    nz = length(z)    
    field = array(data[,8],c(nx,ny))
    field[which(field<=101325)] = NA
#    print(paste(nx,ny,nz))

    field.z = array(data[,3],c(nx,ny))
    field.z[which(field.z==0)] = NA

    value = data[,1:3]
}

filled.contour(x,y,field.z,
               color.palette = terrain.colors
               )

filled.contour(x,y,field,
               color.palette = terrain.colors
               )
