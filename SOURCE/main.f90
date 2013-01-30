program main

use init, only : setProblem, initData
use database_m, only : readDatabase, lininterpolDatabase
use params, only : map_pars, sdim, nest_root, logevidence, observation, database, chain_analysis
use like, only : nestSample
use maths, only : init_random_seed
use chainAnalysis_m, only : analyze_chains_multinest
      
implicit none
      
	integer :: i

	call init_random_seed

	call setProblem

	call readDatabase

	call initData
	
 	call nestSample

	open(unit=12,file=trim(adjustl(nest_root))//'.map.pars',action='write',status='replace')
	write(12,*) map_pars
	close(12)

	call lininterpolDatabase(map_pars, database%model)

	open(unit=12,file=trim(adjustl(nest_root))//'.map.prof',action='write',status='replace')
	write(12,*) observation%nlambda
	write(12,*) logevidence
	do i = 1, observation%nlambda
 		write(12,*) observation%lambda(i), database%model(i), database%model(database%nlambda+i)
	enddo
	close(12)

	call analyze_chains_multinest(chain_analysis)
   
end
