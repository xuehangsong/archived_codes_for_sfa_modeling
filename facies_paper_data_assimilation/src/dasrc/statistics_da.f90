subroutine AnaDaResult
  use DA_Data
  implicit none
  integer :: i,j
  character*100 :: fname
  real*8,allocatable,dimension(:,:) :: indicator
  real*8,allocatable,dimension(:) :: ref_indicator
  real*8,allocatable,dimension(:) :: diffvec
  real*8,allocatable,dimension(:) :: rmse
  real*8,allocatable,dimension(:) :: mean_stavec
  real*8,allocatable,dimension(:) :: mean_indicator
  real*8,allocatable,dimension(:) :: var_stavec
  real*8,allocatable,dimension(:) :: var_indicator


  fname=trim(trim('results/state_vector_tr.'//trim(fi_jtime))) 
  open (100,file=trim(fname),status='unknown')
  do J=1,Nreaz
     do i=1,Nstavec-1
        write(100,'(f16.8)',advance='no') StaVecTr(i,j)
     enddo
     write(100,'(f16.8)') StaVecTr(NStaVec,j)
  enddo
  close(100)

  fname=trim(trim('results/perm_vector.'//trim(fi_jtime))) 
  open (100,file=trim(fname),status='unknown')
  do J=1,Nreaz
     do i=1,Nfacies-1
        write(100,'(f16.8)',advance='no') StaVecTr(Nnode+i,j)
     enddo
     write(100,'(f16.8)') StaVecTr(NStaVec,j)
  enddo
  close(100)

  allocate(indicator(Nnode,Nreaz))
  allocate(diffvec(Nnode))
  allocate(ref_indicator(Nnode))
  allocate(mean_stavec(Nnode))
  allocate(mean_indicator(Nnode))
  allocate(var_stavec(Nnode))
  allocate(var_indicator(Nnode))
  allocate(rmse(nnode))

  indicator=0.
  diffvec=0.
  ref_indicator=0.
  mean_stavec=0.
  mean_indicator=0.
  var_stavec=0.
  var_indicator=0.
  rmse=0. 


  do J=1,Nreaz
     do i=1,Nnode
        if (StaVecTr(i,j).ge.0.) then
           indicator(i,j)=1.0
        else
           indicator(i,j)=0.
        endif
     enddo
  enddo


  fname=trim(trim('results/indicator_tr.'//trim(fi_jtime))) 
  open (100,file=trim(fname),status='unknown')
  do J=1,Nreaz
     do i=1,Nnode-1
        write(100,'(f16.8)',advance='no') indicator(i,j)
     enddo
     write(100,'(f16.8)') indicator(Nnode,j)
  enddo
  close(100)


  mean_indicator=sum(indicator,dim=2)/real(nreaz)
  mean_stavec=sum(stavectr,dim=2)/real(nreaz)


  fname='dainput/ref.dat'
  open (100,file=fname,status='old')
  do i=1,nnode
     read (100,*) ref_indicator(i)
  enddo
  close(100)
  do i=1,Nnode
     do J=1,Nreaz
        diffvec(i)=diffvec(i)+(indicator(i,j)-ref_indicator(i))**2
        var_stavec(i)=var_stavec(i)+(stavectr(i,j)-mean_stavec(i))**2
        var_indicator(i)=var_indicator(i)+(indicator(i,j)-mean_indicator(i))**2
     enddo
     rmse(i)=(mean_indicator(i)-ref_indicator(i))**2
  enddo
  diffvec=diffvec/real(nreaz)
  var_indicator=var_indicator/real(nreaz-1)
  var_stavec=var_stavec/real(nreaz-1)




  fname=trim(trim('results/prob_tr.'//trim(fi_jtime)))
  open (100,file=trim(fname),status='unknown')
  do i=1,Nnode
     write(100,'(6f16.6)') mean_indicator(i), &
          & var_indicator(i),  &
          & rmse(i), &
          & diffvec(i), &
          & mean_stavec(i),    &
          & var_stavec(i)
  enddo
  close(100)


  deallocate(indicator)
  deallocate(diffvec)
  deallocate(ref_indicator)
  deallocate(mean_stavec)
  deallocate(mean_indicator)
  deallocate(var_stavec)
  deallocate(var_indicator)
  deallocate(rmse)

end subroutine AnaDaResult
