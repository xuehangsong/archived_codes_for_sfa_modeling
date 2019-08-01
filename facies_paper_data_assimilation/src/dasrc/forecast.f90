subroutine Forecast
  use DA_Data
  implicit none
  integer :: i
  character*100 :: fname
  character*100 :: prefix_file
  character*100 :: Fi_Jreaz

  !   do Jreaz=1,Nreaz
  !      write(FNJreaz,"(i4.4)") Jreaz
  !      fname="ensemble/????"
  !      write(fname(10:13),"(I4.4)") jreaz
  !      call levelset_inverse_parameterization
  !      call simulator_IDW(fname,power_idw_array(jtime),FNjtime) 
  !      call GetPrediction
  !      write(*,*) "DA step=",Jtime,'Realization=',jreaz,'finished'
  !   enddo

  ! this part is to generate pflotran field
  !  call WritePflotranDataSet
  !this part is for get observation


  do jreaz=1,nreaz
     if (jreaz.lt.10) then
        write(fi_jreaz,'(i1.1)') jreaz
     elseif (jreaz.lt.100) then
        write(fi_jreaz,'(i2.2)') jreaz 
     elseif (jreaz.lt.1000) then
        write(fi_jreaz,'(i3.3)') jreaz
     else
        write(fi_jreaz,'(i4.4)') jreaz
     endif

     prefix_file=trim(trim(trim('pflotran_mc/pflotran_mcR')))
     prefix_file=trim(trim(prefix_file)//trim(fi_jreaz))//'-obs-'

     call GetPflotranSimu(prefix_file,da_time(jtime),ObsEnsem(:,jreaz))

  enddo
end subroutine Forecast






subroutine GetPflotranSimu(prefix_file,obs_time,simu_obs)
  USE DA_DATA
  implicit none
  integer :: i,j,i_index,i_file
  character*100 :: fname
  integer :: Head_locator
  character*10000 :: Obs_Head
  real*8,allocatable,dimension(:) :: Temp_data
  integer,dimension(:) :: obs_index(1000)
  real*8 :: simu_time
  real*8 :: Obs_time
  integer :: sum_obs
  character*100 :: Fi_file
  character*100 :: prefix_file
  logical :: file_exist


  !  integer :: Nobs
  !  real*8,allocatable,dimension(:) :: Simu_Obs
  real*8,dimension(:) ::  simu_obs(8)
  !  Nobs=7
  !  prefix_obs_loc='obs_well'
  !  prefix_file='pflotranR2-obs-'
  !  obs_time= 1.000000E-05

  !  allocate(Simu_Obs(Nobs))

  sum_obs=0
  i_file=0
  do while(.TRUE.)

     if(i_file.lt.10) then
        write(Fi_file,"(i1.1)") i_file
     elseif (i_file.lt.100) then
        write(Fi_file,"(i2.2)") i_file
     elseif (i_file.lt.1000) then
        write(Fi_file,'(i3.3)') i_file
     else
        write(Fi_file,'(i4.4)') i_file
     endif

     fname=trim(trim(prefix_file)//trim(Fi_file))//'.tec'
     inquire(file=trim(fname),exist=file_exist)
     if(file_exist) then
        obs_index=0
        open(100,file=trim(fname),status='old')


        !Find the index of observation
        i_index=0
        Head_locator=0
        obs_index=0
        read(100,'(a10000)') Obs_Head
        do while(.TRUE.)
           Head_locator=index(Obs_Head,trim(prefix_obs_loc))
           if (Head_locator.gt.0) then
              i_index=i_index+1
              Head_locator=Head_locator+len(trim(prefix_obs_loc))
              Obs_Head=Obs_Head(Head_locator:)
              read(Obs_Head,*) Obs_index(i_index)
           else
              exit
           endif
        enddo
        !store observation
        allocate(Temp_data(i_index))
        do while(.TRUE.)
           read(100,'(e14.6)',advance='no') Simu_Time
           if(abs((Simu_Time-Obs_Time)).lt.1e-8) then
              do i=1,i_index-1
                 read(100,'(e14.6)',advance='no') Temp_data(i)
              enddo
              read(100,'(e14.6)') Temp_data(i)
              exit
           else
              read(100,*)
           endif
        enddo

        !pick up pressure head observation
        j=1
        do i=1,100
           if (obs_index(i).eq.obs_index(i+1)) then
              j=j+1
           else
              exit
           endif
        enddo


        do i=1,i_index/j
           Simu_Obs(Obs_index(1+(i-1)*j))=Temp_data(1+(i-1)*j)
        enddo
        deallocate(Temp_data)
        close(100)


        sum_obs=i_index/j+sum_obs
        if (sum_obs.eq.Nobs) then
           exit
        endif

     else
     endif
     i_file=i_file+1

  enddo

  do i=1,Nobs
     Simu_obs(i) =simu_obs(i)/9810.0
  enddo





  !  deallocate(Simu_Obs)
End subroutine GetPflotranSimu


! subroutine init_state_vector
!   use DA_Data
!   implicit none
!   integer :: i,j
!   character*100 :: fname

!   fname='dainput/init_state_vector.dat'

!   open(100,file=trim(fname),status='old')
!   do j=1,nreaz
!      read(100,*) (StaVecPr(i,j),i=1,Nstavec)      
!   enddo
!   close(100)
!   StaVecFr(:,:)=StaVecPr(:,:)
!   StaVecAn(:,:)=StaVecPr(:,:)
!   StaVecTr(:,:)=StaVecPr(:,:)
! end subroutine init_state_vector

subroutine GetObs
  use DA_Data
  implicit none
  real*8,allocatable,dimension(:) :: ObsAll
  real*8,allocatable,dimension(:) :: ObsVar
  real*8,allocatable,dimension(:,:) :: ObsError  
  character*100 :: fname
  integer :: i,j

  !-----  FOR NOISY OBSERVATION  ----
  !integer :: KORDEI,MAXOP1,IERR,MAXINT,IDUM
  !integer :: IXV
  !parameter (KORDEI=12,MAXOP1=KORDEI+1,MAXINT=2**30)
  real xp   !REAL HERE
  REAL*8 :: p   !acorni
  integer :: ierr
  !   COMMON/iaco/ ixv(MAXOP1)

  !read & check all the observation
  allocate(ObsAll(Nobs))
  allocate(ObsVar(Nobs))         
  NobsAva=0
  ObsTest=0
  fname="obsdata/"//"obs."//fi_jtime
  open(100,file=fname,status='old')     !for example  "obsdata/obsh_001.dat"
  do i=1,Nobs
     read(100,*) ObsAll(i),ObsVar(i)
     if (ObsVar(i).gt.0.) then
        ObsTest(i)=1   
        NobsAva=NobsAva+1
     endif
  enddo
  close(100)  

  !produce the matrixs of perturbed available observation  and it's  variance
  allocate(ObsAva(NobsAva))
  allocate(ObsAvaVar(NobsAva))
  allocate(ObsAvaPer(NobsAva,Nreaz))  !ObsAva,ObsAvaVar,ObsAvaPer are deallocate in main program
  j=0                               
  do i=1,Nobs
     if(ObsTest(i).eq.1) then
        j=j+1
        ObsAvaVar(j)=ObsVar(i)
        ObsAva(j)=ObsAll(i)
     endif
  enddo

  !add pertubation to observation
  allocate(ObsError(NobsAva,Nreaz))
  do j=1,Nreaz
     do i=1,NobsAva
        !            p = acorni(idum)
        call random_number(p)

        CALL gauinv(p,xp,ierr)  !!!?????????????????
        ObsError(i,j)=xp*SQRT(ObsAvaVar(i)) 
        ObsAvaPer(i,j)=ObsAva(i)+ObsError(i,j)
     enddo
  enddo
  deallocate(ObsError,ObsAll,ObsVar)

end subroutine GetObs




! subroutine GetPrediction
!   use DA_Data
!   implicit none
!   integer :: i
!   character*100 ::fname
!   write(FNJreaz,"(i4.4)") Jreaz
!   fname="ensemble/????"
!   write(fname(10:13),"(I4.4)") jreaz
!   open(100,file=trim(fname)//'/obs_idw_'//Fnjtime//'.dat')
!   read(100,*)
!   read(100,*)
!   read(100,*)
!   do i=1,Nobs
!      read (100,*) ObsEnsem(i,jreaz),ObsEnsem(i,jreaz),ObsEnsem(i,jreaz),ObsEnsem(i,jreaz)
!   enddo
!   close(100)

! end subroutine GetPrediction


! subroutine levelset_inverse_parameterization
!   use DA_Data
!   implicit none
!   integer :: i,j
!   character*100 :: fname
!   real*8  :: value_temp

!   do J=1,Nreaz
!      write(FNJreaz,"(i4.4)") J
!      fname="ensemble/????"
!      write(fname(10:13),"(I4.4)") j  

!      open (100,file=trim(fname)//'/idw_mesh_'//FNJtime//'.dat',status='unknown')

!      do i=1,Nnode_IDW
!         !this part is for two facies
!         !if ((StaVecTr(i,j).ge.0.).and.(StaVecTr(i+Nnode_IDW,j).ge.0)) then
!         !    value_temp=Value_faices(1)
!         !else if ((StaVecTr(i,j).ge.0.).and.(StaVecTr(i+Nnode_IDW,j).lt.0)) then
!         !    value_temp=Value_faices(2)
!         !else if((StaVecTr(i,j).lt.0.).and.(StaVecTr(i+Nnode_IDW,j).ge.0)) then
!         !    value_temp=Value_faices(3)
!         !else
!         !    value_temp=Value_faices(4)
!         !endif       

!         if (StaVecTr(i,j).ge.0.) then
!            value_temp=Value_faices(1)
!         else 
!            value_temp=Value_faices(2)
!         endif
!         !        write(100,'(4f16.8)') Cord_IDW(1:3,i),value_temp
!      enddo

!      close(100)

!   enddo
! end subroutine levelset_inverse_parameterization


!generate observations, add random noise

