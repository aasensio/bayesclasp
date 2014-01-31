module like
use params
use Nested, only : nestRun
use database_m, only : lininterpolDatabase
implicit none
      
contains
      
!-----------------------------------------------------------------------
! Do the actual nested sampling to estimate the evidence and the posterior distribution
!-----------------------------------------------------------------------
	subroutine nestSample
   integer :: nclusters, context !total number of clusters found
   integer :: maxNode !variables used by the posterior routine
   
		call nestRun(nest_mmodal,nest_ceff,nest_nlive,nest_tol,nest_efr,sdim,nest_nPar, &
			nest_nClsPar,nest_maxModes,nest_updInt,nest_Ztol,nest_root,nest_rseed, prior%pWrap, &
			nest_fb,nest_resume,outfile,initmpi,logzero,maxiter,getLogLike,dumper,context)

	end subroutine nestSample
	
!-----------------------------------------------------------------------
! Dumper. It is called after every updInt*10 iterations in case you want to
! print any message
!-----------------------------------------------------------------------
	subroutine dumper(nSamples, nlive, nPar, physLive, posterior, paramConstr, maxLogLike, logZ, logZerr, context)

	integer nSamples                                ! number of samples in posterior array
   integer nlive                                   ! number of live points
	integer nPar                                    ! number of parameters saved (physical plus derived)
	double precision, pointer :: physLive(:,:)      ! array containing the last set of live points
	double precision, pointer :: posterior(:,:)     ! array with the posterior distribution
	double precision, pointer :: paramConstr(:)     ! array with mean, sigmas, maxlike & MAP parameters
	double precision maxLogLike                     ! max loglikelihood value
	double precision logZ, logZerr                           ! log evidence
	integer :: context
	
		logevidence = logZ
        
	end subroutine dumper

!-----------------------------------------------------------------------
! Wrapper around Likelihood Function
! Cube(1:n_dim) has nonphysical parameters
! scale Cube(1:n_dim) & return the scaled parameters in Cube(1:n_dim) &
! additional parameters in Cube(n_dim+1:nPar)
! return the log-likelihood in lnew
!-----------------------------------------------------------------------
	subroutine getLogLike(Cube,n_dim,nPar,lnew,context)

		integer :: n_dim,nPar,context
		real(kind=8) :: lnew,Cube(nPar)
   
		call slikelihood(Cube,lnew)

	end subroutine getLogLike

      
!-----------------------------------------------------------------------
! Likelihood function
!-----------------------------------------------------------------------
	subroutine slikelihood(Cube,slhood)              
	real(kind=8) :: Cube(nest_nPar),slhood,logpriorP
	real(kind=8) :: temp(sdim),dist,loclik, sigma, xi, L
	integer :: i,j

! Multiply the unit hypercube with the appropriate ranges of the parameters
		Cube = (prior%ranges(:,2)-prior%ranges(:,1))*Cube + prior%ranges(:,1)

! Compute the priors
		logpriorP = 0.d0

		do i = 1, sdim
			if (prior%typ(i) == 'U') then
				logpriorP = logpriorP - log(prior%ranges(i,2) - prior%ranges(i,1))
			endif
			if (prior%typ(i) == 'J') then
				logpriorP = logpriorP - log(Cube(i) * log(prior%ranges(i,2)/prior%ranges(i,1)))
			endif
			if (prior%typ(i) == 'D') then
				logpriorP = logpriorP
				Cube(i) = prior%mu(i)
			endif
			if (prior%typ(i) == 'G') then
				logpriorP = logpriorP - (Cube(i) - prior%mu(i))**2 / (2.d0*prior%sigma(i)**2)
			endif
		enddo
		
		call lininterpolDatabase(Cube, database%model)
			
! Compute the log-likelihood
		slhood = -0.5d0 * sum(((database%model(1:database%nlambda)-observation%stokesQ) / observation%noiseQ)**2) - &
			0.5d0 * sum(((database%model(database%nlambda+1:2*database%nlambda)-observation%stokesU) / observation%noiseU)**2)


! Add the log-prior to the log-likelihood
		slhood = slhood + logpriorP

! Save the parameters that give the best likelihood
		if (slhood > maxslhood) then
			map_pars = Cube
			maxslhood = slhood
		endif

		return
			
	end subroutine slikelihood
      
end module like