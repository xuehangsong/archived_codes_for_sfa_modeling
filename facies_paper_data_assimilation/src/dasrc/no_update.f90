subroutine No_Update
  use DA_Data
  implicit none
  integer :: i,j,Nupdate
  character*100 :: fname

  StaVecPr=StaVecTr

  !first forecast
  call forecast 
  StaVecFr=StaVecAn
  StaVecTr=StaVecFr   !no obs,no update


  return
end subroutine No_Update



