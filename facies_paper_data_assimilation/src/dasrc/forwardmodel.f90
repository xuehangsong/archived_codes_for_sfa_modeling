
!This is a Inverse distance weighting model.
    subroutine simulator_IDW(fname,power_idw,SN_idw)
    use DA_Data

    real*8,allocatable,dimension(:,:) :: Cord_IDW
    real*8,allocatable,dimension(:,:) :: Obs_Cord_IDW
    real*8,allocatable,dimension(:) :: Value_IDW
    real*8,allocatable,dimension(:) :: Obs_value_IDW

    integer :: i,j
    real*8 :: weight_IDW,sum_weight_idw,sum_IDW,power_idw
    real*8 :: flag_idw
    character*4 :: SN_idw
    character*100 :: fname


    allocate(Cord_IDW(3,Nnode_IDW))
    allocate(value_IDW(Nnode_IDW))
    allocate(Obs_Cord_IDW(3,Nobs))
    allocate(Obs_value_IDW(Nobs))

    !!!!input

    open (100,file=trim(fname)//'/idw_mesh_'//sn_idw//'.dat',status='old')
    do i=1,Nnode_IDW
        read(100,*) Cord_IDW(1:3,i),value_idw(i)
    enddo
    close(100)


    open (100,file='dainput/obs_idw_location.dat',status='old')
    do i=1,Nobs
        read(100,*) Obs_Cord_IDW(1:3,i)
    enddo
    close(100)

    do i=1,Nobs
        weight_IDW=0.
        sum_weight_idw=0.
        sum_IDW=0.
        flag_idw=0.
        do j=1,Nnode_IDW

            weight_IDW=(Cord_IDW(1,j)-Obs_Cord_IDW(1,i))**2
            weight_IDW=(Cord_IDW(2,j)-Obs_Cord_IDW(2,i))**2+weight_IDW
            weight_IDW=(Cord_IDW(3,j)-Obs_Cord_IDW(3,i))**2+weight_IDW

            if (weight_IDW.eq.0.) then
                flag_idw=1.0
                exit
            endif


            weight_IDW=(1/(weight_IDW**0.5))**Power_idw
!            sum_IDW=sum_IDW+weight_IDW*value_idw(j)
            sum_IDW=sum_IDW+weight_IDW*value_idw(j)*(value_idw(j)+2)

            sum_weight_IDW=sum_weight_IDW+weight_IDW

        enddo

        if (flag_idw.eq.1) then
!            obs_value_idw(i)=value_IDW(j)
            obs_value_idw(i)=value_IDW(j)*(value_idw(j)+2)
        else
            obs_value_idw(i)=sum_IDW/sum_weight_IDW
        endif

    enddo


    open (100,file=trim(fname)//'/obs_idw_'//sn_idw//'.dat',status='unknown')
    write (100,*) "Observation_Number Power_factor,Observation_SN  "
    write (100,'(I16.8,f16.8,a3)') Nobs,power_idw,SN_idw
    write (100,*) "coordinate*3, obs_value"
    do i=1,Nobs
        write(100,'(3f16.8,f32.8)') Obs_Cord_IDW(1:3,i),obs_value_idw(i)
    enddo
    close(100)



    deallocate(Cord_IDW,Obs_Cord_IDW,value_IDW,Obs_value_IDW)


    end subroutine
