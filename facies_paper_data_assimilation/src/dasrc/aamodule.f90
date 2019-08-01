!global variable shared by procedures running on host process only
module DA_Data
  !parmaters assignmented in "dainput/parameter.dat"
  character*100 :: CaseName !Case name
  !VirExam    1,virtual experiment;0,real cases,a series of observations must
  !           be put in the "obsdata" folder manually   
  integer :: VirExam=0 !1,virtual example;0,real case
  integer :: Nparm=0    !number of model paramters to update(static part of State Vector)
  integer :: Nvari=0    !number of state variables to update(dynamic part of State Vector) 
  integer :: NStaVec  !Size of state Vector;NstaVec=Nvari+Nparm
  integer :: Ntime=0    !interval time between two adjacent assimilation steps
  integer :: NReaz=0    !amount of realizations(viz ensemble size)
  real*8,allocatable,dimension(:) :: obstime_da !totoal observation time

  !for iterate    
  integer :: IterType=0 !iterate type
  integer :: MaxIter=0  !maximum iterate number
  integer,parameter :: NoUpda=-1 !unconditional run
  !integer,parameter :: OrigEnKF=0 !original EnKF
  !integer,parameter :: ConfEnKF=1 !Confirming EnKF
  !integer,parameter :: ModiEnKF=2 !Modified Restart EnKF
  !integer,parameter :: RestEnKF=11 !Restart EnKF
  !integer,parameter :: IterRML=12 !EnRML method
  integer,parameter :: p_EnKF=11



  !    integer,parameter :: ConfirmingPlusEnKF=4
  !    integer,parameter :: ResampleEnKF=5

  !State Vector
  real*8,allocatable,dimension(:,:) :: StaVecPr   !prior state vector
  real*8,allocatable,dimension(:,:) :: StaVecFr   !state vector after a forcast
  real*8,allocatable,dimension(:,:) :: StaVecAn   !state vector after an analysis(update)
  real*8,allocatable,dimension(:,:) :: StaVecTr   !posterior state vector     

  !for obsevation
  integer :: Nobs=0         !number of obsevations,assignmented in "dainput/parameter.dat"
  integer,allocatable,dimension(:) :: ObsTest      !check if obsevation avaiable
  integer :: NobsAva=0      !number of avaiable observations,less or equal to Nobs
  real*8,allocatable,dimension(:) :: ObsAva   !the observations avaiable
  real*8,allocatable,dimension(:,:) :: ObsAvaPer !(avaiable)observations after perturbation
  real*8,allocatable,dimension(:) :: ObsAvaVar    !variance of available observations
  real*8,allocatable,dimension(:,:) :: ObsEnsem     !the model preditions of available observation points
  real*8 :: fakeobs=1.e31


  !for file operation   
  character*4 :: FNJtime      !character forms of  jtime
  character*4 :: FNJreaz      !character forms of  jreaz
  character*2 :: FNJiter      !character forms of  Jiter
  integer,parameter :: TimeDat=30000  !time information result "/statistics_da/***_time.dat"
  integer,parameter :: InfDat=30001   !DA statistical result "/statistics_da/***_inf.dat" 

  integer :: ParaComp=0     !ParaComp   1:parallel computing;0:serial computer

  !time control
  real :: time_da  !number of time step
  real,dimension(:) :: tarray_da(2)  !begin/finish time  of da
  integer :: jtime=0    !current assimilation step
  integer :: jreaz=0    !current realization
  integer :: Jiter=0    !current iterate step


  !information about random field and KL
  real*8 :: Sigma=0  
  integer :: Nterm=0,OPFun=0
  real*8,allocatable,dimension(:,:) :: Omiga,fun
  real*8,allocatable,dimension(:) :: Lambda



  !iterative criteria
  real*8 :: iter_relax  !EnRMl relax factor
  real*8 :: EpsPar=0.00001 !iterative criteria of EnRML
  real*8 :: EpsRatio=0.0001 !iterative criteria of EnRML




  !facies_SIMULATOR
  integer :: Nnode
  integer :: nfacies
  real*8,dimension(:)  :: Value_facies(10)


  !for pflotran
  character*100 :: prefix_obs_loc
  real*8,allocatable,dimension(:) :: da_time
  character*100 :: pflotran_perm
  character*100 :: Fi_Jtime

end module DA_Data
