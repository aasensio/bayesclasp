! Include file for example nested sampler program 'Gaussian Rings'

module init
use params
implicit none

contains

!-----------------------------------------------------------------
! Read the problem configuration
!-----------------------------------------------------------------
	subroutine setProblem
	integer :: i
	real(kind=8) :: l0, par(2)

		open(unit=12,file='internalConf.input',action='read',status='old')
		read(12,*) sdim
		read(12,*) observation%filename
		read(12,*) nest_root
		read(12,*) database%filename

		read(12,*) nest_tol
		read(12,*) nest_maxModes
		read(12,*) nest_efr
		read(12,*) nest_nlive



	! Read the prior ranges and types
		nest_nPar = sdim

		allocate(prior%ranges(sdim,2))
		allocate(prior%typ(sdim))
		allocate(prior%mu(sdim))
		allocate(prior%sigma(sdim))
		allocate(prior%pWrap(sdim))

		read(12,*) (prior%ranges(i,1),i=1,sdim)
		read(12,*) (prior%ranges(i,2),i=1,sdim)
		read(12,*) (prior%typ(i),i=1,sdim)
		read(12,*) (prior%mu(i),i=1,sdim)
		read(12,*) (prior%sigma(i),i=1,sdim)

		close(12)

! If we use a Dirac prior, set a very tight prior around the value
		do i = 1, sdim
			if (prior%typ(i) == 'D') then
				prior%ranges(i,1) = prior%mu(i) - 1.d-3
				prior%ranges(i,2) = prior%mu(i) + 1.d-3
			endif
		enddo


		allocate(map_pars(sdim))

! For periodic boundary conditions		
		prior%pWrap = 0
! 		nest_pWrap(3) = 1

	end subroutine setProblem


!-------------------------------------------------------------
! Generates a random number following a Maxwellian distribution
!-------------------------------------------------------------
	subroutine initData
	integer :: i
		
		print *, 'Reading data file...'
		open(unit=12,file=observation%filename,action='read',status='old')
		read(12,*) observation%nlambda

		allocate(observation%lambda(observation%nlambda))
		allocate(observation%stokesQ(observation%nlambda))
		allocate(observation%stokesU(observation%nlambda))
		allocate(observation%noiseQ(observation%nlambda))
		allocate(observation%noiseU(observation%nlambda))
		
		do i = 1, observation%nlambda
			read(12,*) observation%lambda(i), observation%stokesQ(i), observation%stokesU(i), &
				observation%noiseQ(i), observation%noiseU(i)
		enddo
		close(12)
		
		maxslhood = -1.d100
		
	end subroutine initData


end module init