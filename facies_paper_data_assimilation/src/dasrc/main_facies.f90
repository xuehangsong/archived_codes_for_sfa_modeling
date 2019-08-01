Program facies
  use DA_Data
  implicit none
  character*100,fname
  integer :: i,j
  character*100 :: temp_getarg

  call etime(tarray_da,time_da)       !first time is meaningless
  call getarg(1,fname)
  call getarg(2,temp_getarg)
  read(temp_getarg,*) jtime

  open(100,file=trim(fname),status='old')   

  read(100,*) Ntime
  allocate(da_time(Ntime))
  read(100,*) (da_time(i),i=1,Ntime)
  read(100,*) Nobs
  read(100,*) prefix_obs_loc
  read(100,*) Nfacies
  read(100,*) (Value_facies(i),i=1,Nfacies)
  read(100,*) Nreaz
  read(100,*) Nnode
  NStaVec=Nnode+Nfacies
  read(100,*) IterType
  close(100)   

  

  !   Reference solution     
  !call ref_idw

  allocate(obstest(Nobs)) 
  allocate(StaVecPr(NStaVec,Nreaz),StaVecFr(NStaVec,Nreaz))
  allocate(StaVecAn(NStaVec,Nreaz),StaVecTr(NStaVec,Nreaz))
  StaVecAn=0.
  StaVecPr=0.
  StaVecFr=0.
  StaVecTr=0. 


  Jtime=Jtime-1
  write(fi_jtime,'(i1.1)') jtime
  if (jtime.lt.10) then
     write(fi_jtime,'(i1.1)') jtime
  elseif (jtime.lt.100) then
     write(fi_jtime,'(i2.2)') jtime 
  elseif (jtime.lt.1000) then
     write(fi_jtime,'(i3.3)') jtime
  else
     write(fi_jtime,'(i4.4)') jtime
  endif

  fname='results/state_vector.'//fi_jtime
  open(100,file=trim(fname),status='old')
  do j=1,nreaz
     read(100,*) (StaVecPr(i,j),i=1,Nstavec)      
  enddo
  close(100)
  StaVecFr(:,:)=StaVecPr(:,:)
  StaVecAn(:,:)=StaVecPr(:,:)
  StaVecTr(:,:)=StaVecPr(:,:)

  if (jtime.eq.0) then
     call AnaDaResult
  endif
  Jtime=Jtime+1



  !  Do Jtime=1,Ntime
  write(FNjtime(1:4),"(I4.4)") Jtime


  if (jtime.lt.10) then
     write(fi_jtime,'(i1.1)') jtime
  elseif (jtime.lt.100) then
     write(fi_jtime,'(i2.2)') jtime 
  elseif (jtime.lt.1000) then
     write(fi_jtime,'(i3.3)') jtime
  else
     write(fi_jtime,'(i4.4)') jtime
  endif


  call GetObs
  allocate(ObsEnsem(NobsAva,Nreaz))

  select case(IterType)
  case(NoUpda)
     call no_update
  case(p_EnKF)
     call parameter_enkf
  case default
     print *,'no such algorithm'
     stop
  end select

  call AnaDaResult
  deallocate(ObsEnsem)
  deallocate(ObsAvaVar,ObsAvaPer,ObsAva) 
  !  enddo

  deallocate(StaVecPr,StaVecFr,StaVecAn,StaVecTr)
  deallocate(obstest)
  deallocate(da_time)
end Program facies



