subroutine data_assimilation_enkf(Nupdate)
  use DA_Data
  implicit none
  integer :: i,j,k
  character*100 :: fname
  real*8,allocatable,dimension(:,:) :: DStaVecFr !ΔStaVecFr
  real*8 ::temp3        !for produce ΔStaVecFr
  integer ::Nupdate      !number of StaVec to be updated
  real*8,allocatable,dimension(:,:) :: DobsEnsem !ΔObsEnsem,
  real*8,allocatable,dimension(:,:) :: CovStaObs !Covariance between all state vector and obs state vector
  real*8,allocatable,dimension(:,:) :: CovObsObs !Covariance between obs state vector
  real*8,allocatable,dimension(:,:) :: temp1     !(H(t)P(f)H(t)+R)^(-1)
  real*8,allocatable,dimension(:,:) :: KalGain   !kalman gain P(f)H(t)*(H(t)P(f)H(t)+R)^(-1)
  real*8,allocatable,dimension(:,:) :: Increment !P(f)H(t)*(H(t)P(f)H(t)+R)^(-1)*(d-Hφ)


  allocate(DStaVecFr(Nupdate,Nreaz))   !ΔStaVec:only contains the part need to be updated (1:Nupdate)
  allocate(DObsEnsem(NobsAva,Nreaz))
  allocate(CovStaObs(Nupdate,NobsAva))           !in enkf,CovStaObs is defined by P(f)H(t)
  allocate(CovObsObs(NobsAva,NobsAva))           !in enkf,CovObsObs  is defined by H(t)P(f)H(t)
  allocate(temp1(NobsAva,NobsAva))  
  allocate(KalGain(Nupdate,NobsAva)) 
  allocate(Increment(Nupdate,Nreaz))

  StaVecAn=StaVecFr

  !generate the cov between state vector and obs vector 
  do i=1,NUpdate
     temp3=(sum(StaVecFr(i,1:Nreaz)))/real(Nreaz)
     DStaVecFr(i,1:Nreaz)=StaVecFr(i,1:Nreaz)-temp3
  enddo
  call GetPer(NobsAva,Nreaz,ObsEnsem,DObsEnsem)
  do i=1,Nupdate
     do j=1,NobsAva
        CovStaObs(i,j)=sum(DStaVecFr(i,1:Nreaz)*DobsEnsem(j,1:Nreaz))
     enddo
  enddo
  CovStaObs=CovStaObs/(real(Nreaz)-1.0)


  !generate the cov between obs vector
  !in enkf,CovObsObs  is defined by H(t)P(f)H(t)
  do i=1,NobsAva
     do j=1,NobsAva
        CovObsObs(i,j)=sum(DobsEnsem(i,1:Nreaz)*DobsEnsem(j,1:Nreaz))
     enddo
  enddo
  CovObsObs=CovObsObs/(real(Nreaz)-1.0)


  !added xuehang 03/24/2015
  fname=trim(trim('results/covariance_prediction.'//trim(fi_jtime))) 
  open (100,file=trim(fname),status='unknown')
  do J=1,NobsAva
     do i=1,NobsAva
        write(100,'(f10.3)',advance='no') covobsobs(i,j)
     enddo
     write(100,*) 
  enddo
  close(100)




  !H(t)P(f)H(t)+R
  do i=1,NobsAva
     CovObsObs(i,i)=CovObsObs(i,i)+ObsAvaVar(i) 
  enddo

  !temp1=( H(t)P(f)H(t)+R )^-1
  call get_inverse(NobsAva,CovObsObs,temp1)
  KalGain=matmul(CovStaObs,temp1)


  !added xuehang 03/24/2015
  fname=trim(trim('results/kalman_gain.'//trim(fi_jtime))) 
  open (100,file=trim(fname),status='unknown')
  do J=1,NobsAva
     do i=1,Nupdate
        write(100,'(f10.3)',advance='no') kalgain(i,j)
     enddo
     write(100,*) 
  enddo
  close(100)

  fname=trim(trim('results/covariance_state_prediction.'//trim(fi_jtime))) 
  open (100,file=trim(fname),status='unknown')
  do J=1,NobsAva
     do i=1,Nupdate
        write(100,'(f10.3)',advance='no') covstaobs(i,j)
     enddo
     write(100,*) 
  enddo
  close(100)






  Increment=matmul(KalGain,(ObsAvaPer-ObsEnsem))
  StaVecAn(1:NUpdate,1:Nreaz)=StaVecFr(1:NUpdate,1:Nreaz)+Increment(1:NUpdate,1:Nreaz)
  deallocate(DStaVecFr,DobsEnsem,CovStaObs,CovObsObs,temp1,KalGain,Increment)
end subroutine data_assimilation_enkf







subroutine GetPer(m,n,a,ap)
  implicit none
  integer m,n
  real * 8 :: a(m,n),ap(m,n)
  real *8, allocatable :: a1(:,:),am(:,:)
  allocate(a1(n,n),am(m,n))
  a1 = 1.0/n
  am = matmul(a,a1) ! save mean
  ap = a - am ! get purterbations
  deallocate(a1,am)
end subroutine GetPer



