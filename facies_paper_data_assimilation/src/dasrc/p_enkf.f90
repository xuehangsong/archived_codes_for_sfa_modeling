
subroutine parameter_enkf
  use DA_Data
  implicit none
  integer :: i,j,Nupdate
  character*100 :: fname

  StaVecPr=StaVecTr

  !first forecast
  call forecast

  fname="results/obs????.dat"
  write(fname(12:15),"(I4.4)") jtime
  open (100,file=trim(fname),status='unknown')
  do i=1,Nreaz
     do j=1,Nobs-1
        write(100,'(f12.3)',advance='no') ObsEnsem(j,i)
     enddo
     write(100,'(f12.3)') ObsEnsem(Nobs,i)
  enddo

  close(100)


  !update state vector using kalman
  if(NobsAva.eq.0) then
     StaVecTr=StaVecFr   !no obs,no update
  else
     Nupdate=NStaVec
     call data_assimilation_enkf(Nupdate)
     StaVecFr=StaVecAn
     StaVecTr=StaVecAn
     !      call forecast
     !      StaVecTr=StaVecFr
  endif




!added xuehang song 04/08/2015
  do i=1,nreaz
     StaVecTr(Nstavec,i)=max(-14.0,StaVecTr(Nstavec,i))
     StaVecTr(Nstavec-1,i)=max(StaVecTr(Nstavec-1,i),StaVecTr(Nstavec,i))
  enddo





  return
end subroutine parameter_enkf



