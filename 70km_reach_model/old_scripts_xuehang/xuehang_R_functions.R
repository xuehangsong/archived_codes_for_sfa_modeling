WgsToLonglat <- function(x) {
    wgscoord = SpatialPoints(x,proj4string = CRS("+proj=lcc +lat_1=45.83333333333334 +lat_2=47.33333333333334 +lat_0=45.33333333333334
                  +lon_0=-120.5 +x_0=500000.0000000002 +y_0=0 +ellps=GRS80 +datum=NAD83 "))
    longlatcoord = spTransform(wgscoord,CRS("+proj=longlat +ellps=WGS84"))
    return(longlatcoord)
}


regulate_data <- function(data,start.time,end.time,every_min,start_min)
{
    
    dt = 1
    npoint = (60-start_min) %/% every_min
    mins = c()
    for (ipoint in 0:npoint) {
        mins = c(mins,-dt:dt+start_min+ipoint*every_min)
        mins = mins[mins<60]
        mins = mins[mins>=0]        
    }
    time.index = seq(from=start.time,to=end.time,by=paste(every_min,"min"))    
    data.xts = data
    data.xts = data.xts[which(data.xts[,1]>=start.time),]
    data.xts = data.xts[which(data.xts[,1]<=end.time),]
    data.xts = xts(data.xts,data.xts[,1],unique=T,tz="GMT")
    data.xts = data.xts[,-1]
    data.xts = data.xts[.indexmin(data.xts) %in% mins,]
    index(data.xts) = as.POSIXlt(round(as.double(index(data.xts))/(every_min*60))*(every_min*60),
               origin=(as.POSIXlt('1970-01-01')),tz="GMT")
    data.xts = data.xts[!duplicated(.index(data.xts))]
    data.xts = merge(data.xts,time.index)
    return(data.xts)
}

replace_nan_na <- function(data)
{
    data = rapply(data,f=function(x) ifelse(x=="",NA,x),how = "replace")        
    data = rapply(data,f=function(x) ifelse(is.nan(x),NA,x),how = "replace")
    return(data)
}

##a=as.numeric(apply(Piezos_add,2,function(x) gsub("^$|^ $",NA,x))

proj_to_model <- function(origin,angle,coord)
{
    output = array(NA,dim(coord))
    rownames(output) = rownames(coord)
    colnames(output) = colnames(coord)    
    output[,1] = (coord[,1]-origin[1])*cos(angle)+(coord[,2]-origin[2])*sin(angle)
    output[,2] = (coord[,2]-origin[2])*cos(angle)-(coord[,1]-origin[1])*sin(angle)
    return(output)
}   


model_to_proj <- function(origin,angle,coord)
{
    output = array(NA,dim(coord))
    rownames(output) = rownames(coord)
    colnames(output) = colnames(coord)    
    output[,1] = origin[1]+coord[,1]*cos(angle)-coord[,2]*sin(angle)
    output[,2] = origin[2]+coord[,1]*sin(angle)+coord[,2]*cos(angle)
    return(output)
}   

