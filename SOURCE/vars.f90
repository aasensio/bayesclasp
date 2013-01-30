! Include file for example nested sampler program 'Gaussian Rings'

module params
implicit none

! Toy Model Parameters

!dimensionality
      	integer :: sdim


! Parameters for Nested Sampler
	
!whether to do multimodal sampling
			logical nest_mmodal 
 			parameter(nest_mmodal=.FALSE.)
	
!max no. of live points
     		integer nest_nlive
! 			parameter(nest_nlive=500)

			logical :: nest_ceff
			parameter(nest_ceff = .TRUE.)
      
!tot no. of parameters, should be sdim in most cases but if you need to
!store some additional parameters with the actual parameters then
!you need to pass them through the likelihood routine
			integer :: nest_nPar
      
!seed for nested sampler, -ve means take it from sys clock
			integer nest_rseed 
			parameter(nest_rseed=-1)
      
!evidence tolerance factor
      	real*8 nest_tol 
!       	parameter(nest_tol=0.5)
      
!enlargement factor reduction parameter
      	real*8 nest_efr
!       	parameter(nest_efr=0.8d0)
      
      	!root for saving posterior files
      	character*100 nest_root
! 			parameter(nest_root='chains/2-')
	
!no. of iterations after which the ouput files should be updated
			integer nest_updInt
			parameter(nest_updInt=100)

!null evidence (set it to very high negative no. if null evidence is unknown)
			real*8 nest_Ztol
			parameter(nest_Ztol=-1.d90)
      
!max modes expected, for memory allocation
      	integer nest_maxModes 
!       	parameter(nest_maxModes=20)
      
!no. of parameters to cluster (for mode detection)
      	integer nest_nClsPar
      	parameter(nest_nClsPar=1)
      
!whether to resume from a previous run
      	logical nest_resume
      	parameter(nest_resume=.false.)
      
!feedback on the sampling progress?
      	logical nest_fb 
      	parameter(nest_fb=.true.)

      	integer maxiter
      	parameter(maxiter=50000)

      	logical outfile
      	parameter(outfile=.true.)

      	logical initmpi
      	parameter(initmpi=.true.)

      	double precision logZero
	      parameter(logZero=-huge(1d0))
      	
!=======================================================================

	character(len=20), allocatable, dimension(:) :: fvars
	character(len=250) :: feval
	
	real(kind=8) :: sigma, maxslhood, logevidence
	real(kind=8), allocatable, dimension(:) :: map_pars
	real(kind=8), parameter :: PI = 3.14159265359d0, one_sigma = 68.268955e0, &
		two_sigma = 95.449972e0

	integer :: ndata
	character(len=128) :: file_data
	real(kind=8), allocatable :: x(:), y(:), noise(:), model(:), fvals(:)

	type observation_t
		character(len=120) :: filename
		integer :: nlambda
		real(kind=8), pointer :: lambda(:), stokesQ(:), noiseQ(:), stokesU(:), noiseU(:)
	end type observation_t

	type prior_t
		character(len=1), allocatable :: typ(:)
      real(kind=8), allocatable :: mu(:), sigma(:)
      real(kind=8), allocatable :: ranges(:,:) !spriorran(sdim,2)
      integer, allocatable :: pWrap(:) ! Wraparound parameters
	end type prior_t
	
	type database_t
		character(len=120) :: filename
		integer :: nlambda, nB, nthB, nchiB, ndim
		real(kind=8), pointer :: B(:), thB(:), chiB(:), pars(:,:), model(:)
      real(kind=8), pointer :: stokesQU(:,:,:,:), stokesI(:)
      real(kind=8), pointer :: lambda(:), wrk(:,:), params(:,:)
      integer, pointer :: indi(:), ee(:,:)
	end type database_t

	type markov_t
		character(len=4) :: typ
		integer :: nparam, nlength		
		real(kind=8), pointer :: chain(:,:), best_parameters(:), most_probable(:)
		real(kind=8) :: evidence, avg_lnL
		character(len=100) :: filename
		character(len=4), pointer :: param_names(:)
	end type markov_t

	type(database_t) :: database
	type(observation_t) :: observation
	type(markov_t) :: chain_analysis
	type(prior_t) :: prior

end module params
