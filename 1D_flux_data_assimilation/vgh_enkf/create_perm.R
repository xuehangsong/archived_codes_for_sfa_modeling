rm(list=ls())
library("rhdf5")

h5file = "perm_field.h5"

nz = 100
nreaz = 10
magnitude = 10^-6
value = seq(1,9,length.out = nreaz)


if (file.exists(h5file))
{
    file.remove(h5file)
}

for (ireaz in nreaz )
{
    h5createFile(h5file)
    h5write(1:nz,h5file,"Cell Ids",level=0)
    h5write(value*magnitude,h5file,"perm_field",level=0)
}

H5close()
