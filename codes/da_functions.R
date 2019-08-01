library("parallel")


cov.serial <- function(m1,m2)
{
    m1 = t(apply(m1,2,function(x) x-mean(x)))
    m2 = apply(m2,2,function(x) x-mean(x))
    return((m1 %*% m2)/nrow(simu.ensemble))
}



cov.parallel.1 <- function(m1,m2)
{
    t = proc.time()

    m1 = t(apply(m1,2,function(x) x-mean(x)))
    m2 = apply(m2,2,function(x) x-mean(x))
    
    nstate = nrow(m1)
    nreaz = ncol(m1)

    ncore = detectCores()-1

    cl = makeCluster(ncore,type="FORK")

    print(ncore)

    print(proc.time() - t)
    
    idx = splitIndices(nstate,ncore)
    
    m1.list = lapply(idx,function(ii) m1[ii,,drop=FALSE])

    print(proc.time() - t)
    
    cov.list = clusterApply(cl,m1.list,get("%*%"),m2)

    print(proc.time() - t)
    
    cov.list = clusterApply(cl,cov.list,get("/"),(nreaz-1))
    
    stopCluster(cl)
    return(do.call(rbind,cov.list))
}


cov.parallel.2 <- function(m1,m2)
{

    m1 = t(apply(m1,2,function(x) x-mean(x)))
    m2 = apply(m2,2,function(x) x-mean(x))
    
    nstate = nrow(m1)
    nreaz = ncol(m1)

    ncore = detectCores()-1

    print(ncore)
    
    idx = splitIndices(nstate,ncore)
    m1.list = lapply(idx,function(ii) m1[ii,,drop=FALSE])
    cov.list = mclapply(m1.list,function(x) (x %*% m2)/(nreaz-1) )

    return(do.call(rbind,cov.list))
}



cov.parallel.3 <- function(m1,m2)
{
    
    ncore = detectCores()-1
    print(ncore)

    nstate = ncol(m1)
    nreaz = nrow(m1)
    
    idx = splitIndices(nstate,ncore)
    
    m1.list = mclapply(idx,function(ii)
        t( m1[,ii,drop=FALSE]-
           rep(colMeans(m1[,ii,drop=FALSE]),
               rep.int(nrow(m1[,ii,drop=FALSE]),ncol(m1[,ii,drop=FALSE])))))

    m2 = apply(m2,2,function(x) x-mean(x))

    cov.list = mclapply(m1.list,function(x) (x %*% m2)/(nreaz-1) )
    return(do.call(rbind,cov.list))
}


cov.parallel.4 <- function(m1,m2)
{
    t = proc.time()    
    
    ncore = detectCores()-1
    print(ncore)

    nstate = ncol(m1)
    nreaz = nrow(m1)
    
    idx = splitIndices(nstate,ncore)

    print(proc.time() - t)

    m2 = apply(m2,2,function(x) x-mean(x))

    print(proc.time() - t)
    
    cov.list = mclapply(idx,function(ii)
    (t( m1[,ii,drop=FALSE]-
        rep(colMeans(m1[,ii,drop=FALSE]),
            rep.int(nrow(m1[,ii,drop=FALSE]),
                    ncol(m1[,ii,drop=FALSE])))) %*% m2)/(nreaz-1) )

    print(proc.time() - t)    
    return(do.call(rbind,cov.list))
}


cov.parallel.5 <- function(m1,m2)
{

    t = proc.time()
    total.dim = 1.0*nrow(m1)*ncol(m1)*ncol(m2)
    
    m1 = t(apply(m1,2,function(x) x-mean(x)))
    m2 = apply(m2,2,function(x) x-mean(x))
    
    nstate = nrow(m1)
    nreaz = ncol(m1)
    
    ncore = detectCores()-1

    cl = makeCluster(ncore,type="FORK")

    print(ncore)

    print(proc.time() - t)

    idx = splitIndices(nstate,floor(total.dim/5e9*ncore))
    
    m1.list = lapply(idx,function(ii) m1[ii,,drop=FALSE])

    print(proc.time() - t)
    
    cov.list = clusterApplyLB(cl,m1.list,get("%*%"),m2)

    print(proc.time() - t)
    
    cov.list = clusterApplyLB(cl,cov.list,get("/"),(nreaz-1))
    
    stopCluster(cl)
    return(do.call(rbind,cov.list))
}







cov.parallel.6 <- function(m1,m2)
{
    t = proc.time()    
    total.dim = 1.0*nrow(m1)*ncol(m1)*ncol(m2)
    
    ncore = detectCores()-1
    print(ncore)

    nstate = ncol(m1)
    nreaz = nrow(m1)
    
    idx = splitIndices(nstate,floor(total.dim/5e9*ncore))
    
    print(proc.time() - t)

    m2 = apply(m2,2,function(x) x-mean(x))

    print(proc.time() - t)
    
    cov.list = mclapply(idx,function(ii)
    (t( m1[,ii,drop=FALSE]-
        rep(colMeans(m1[,ii,drop=FALSE]),
            rep.int(nrow(m1[,ii,drop=FALSE]),
                    ncol(m1[,ii,drop=FALSE])))) %*% m2)/(nreaz-1) )

    print(proc.time() - t)    
    return(do.call(rbind,cov.list))
}


cov.parallel.7 <- function(m1,m2)
{

    t = proc.time()
    total.dim = 1.0*nrow(m1)*ncol(m1)*ncol(m2)
    nstate = ncol(m1)
    nreaz = nrow(m1)

    m2 = apply(m2,2,function(x) x-mean(x))
    
    ncore = detectCores()-1
    cl = makeCluster(ncore,type="FORK")
    print(ncore)

    print(proc.time() - t)

    idx = splitIndices(nstate,floor(total.dim/5e9*ncore))

    cov.list = clusterApplyLB(cl,idx,function(ii)
    (t( m1[,ii,drop=FALSE]-
        rep(colMeans(m1[,ii,drop=FALSE]),
            rep.int(nrow(m1[,ii,drop=FALSE]),
                    ncol(m1[,ii,drop=FALSE])))) %*% m2)/(nreaz-1))
    
    stopCluster(cl)
    return(do.call(rbind,cov.list))
}



cov.parallel.8 <- function(m1,m2)
{

    t = proc.time()
    total.dim = 1.0*nrow(m1)*ncol(m1)*ncol(m2)
    nstate = ncol(m1)
    nreaz = nrow(m1)

    m2 = apply(m2,2,function(x) x-mean(x))
    
    ncore = detectCores()-1
    cl = makeCluster(ncore,type="FORK")
    print(ncore)

    print(proc.time() - t)

    idx = splitIndices(nstate,floor(total.dim/5e9*ncore))

    cov.list = clusterApplyLB(cl,idx,function(ii)
    (t( m1[,ii,drop=FALSE]-
        rep(colMeans(m1[,ii,drop=FALSE]),
            rep.int(nreaz,length(ii)))) %*% m2)/(nreaz-1))
    
    
    stopCluster(cl)
    return(do.call(rbind,cov.list))
}






cov.parallel.9 <- function(m1,m2)
{

    t = proc.time()
    total.dim = 1.0*nrow(m1)*ncol(m1)*ncol(m2)
    nstate = ncol(m1)
    nreaz = nrow(m1)

    m2 = apply(m2,2,function(x) x-mean(x))
    
    ncore = detectCores()-1
    cl = makeCluster(ncore,type="FORK")
    print(ncore)

    print(proc.time() - t)

    idx = splitIndices(nstate,floor(total.dim/5e9*ncore))
    


    m1.list = clusterApplyLB(cl,idx,function(ii)
        t( m1[,ii,drop=FALSE]-
           rep(colMeans(m1[,ii,drop=FALSE]),
               rep.int(nreaz,length(ii)))))
    

    print(proc.time() - t)
    
    cov.list = clusterApplyLB(cl,m1.list,get("%*%"),m2)

    print(proc.time() - t)
    
    cov.list = clusterApplyLB(cl,cov.list,get("/"),(nreaz-1))
    
    stopCluster(cl)
    return(do.call(rbind,cov.list))
}



cov.parallel.10 <- function(m1,m2)
{
    t = proc.time()
    total.dim = 1.0*nrow(m1)*ncol(m1)*ncol(m2)
    
    m1 = t(apply(m1,2,function(x) x-mean(x)))
    m2 = apply(m2,2,function(x) (x-mean(x))/(nreaz-1))
    
    nstate = nrow(m1)
    nreaz = ncol(m1)
    
    ncore = detectCores()-1

    cl = makeCluster(ncore,type="FORK")

    idx = splitIndices(nstate,max(ncore,floor(total.dim/5e9*ncore)))
    
    m1.list = lapply(idx,function(ii) m1[ii,,drop=FALSE])

    
    cov.list = clusterApplyLB(cl,m1.list,get("%*%"),m2)

    stopCluster(cl)
    return(do.call(rbind,cov.list))
}



multi.parallel <- function(m1,m2)
{
    total.dim = 1.0*nrow(m1)*ncol(m1)*ncol(m2)
    
    nstate = nrow(m1)
    ncore = detectCores()-1

    cl = makeCluster(ncore,type="FORK")


    idx = splitIndices(nstate,max(ncore,floor(total.dim/5e9*ncore)))    
    
    m1.list = lapply(idx,function(ii) m1[ii,,drop=FALSE])
    cov.list = clusterApplyLB(cl,m1.list,get("%*%"),m2)

    stopCluster(cl)
    return(do.call(rbind,cov.list))
}



kalman.segment <- function(nsegment)
{

    nstate = ncol(state.vector)
    idx = splitIndices(nstate,nsegment)

    for (isegment in 1:nsegment)
    {

        cov.state_simu = cov(state.vector[,idx[[isegment]]],simu.ensemble)
        kalman.gain = cov.state_simu %*% inv.cov.simuADDobs
        state.vector[,idx[[isegment]]] = state.vector[,idx[[isegment]]] +
            (obs.ensemble-simu.ensemble) %*% t(kalman.gain)
    }

    return(state.vector)    
}


kalman.parallel <- function ()
{
    product.obs_simu = multi.parallel(inv.cov.simuADDobs,
                                      t(obs.ensemble-simu.ensemble))
    ## rm(list=c("obs.ensemble",
    ##           "obs.ensemble",
    ##           "inv.cov.simuADDobs",
    ##           "cov.simu"))
    centered.state = t(apply(state.vector,2,function(x) x-mean(x)))
    centered.simu = apply(simu.ensemble,2,function(x) (x-mean(x))/(nreaz-1))
    kalman.part = multi.parallel(centered.simu,product.obs_simu)
#    rm(list=c("product.obs_simu","centered.simu"))
    kalman.correction = t(multi.parallel(centered.state,kalman.part))
#    rm(list=c("kalman.part","centered.state"))
    state.vector = state.vector+kalman.correction
 #   rm(list=c("kalman.correction"))
    return(state.vector)
}

