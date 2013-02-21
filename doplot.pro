; Simple code to show the results of the code

; doplot, 'OBSERVATIONS/test.obs', 'RESULTS/test'
pro doplot, fileObs, fileResult

	fileOut = strsplit(fileResult,'/',/extra)
	fileOut = fileOut[n_elements(fileOut)-1]

; Read the original observations
	openr,2,fileObs
	readf,2,n
	obs = dblarr(5,n)
	readf,2,obs
	close,2

	cwpal
	
; Read the maximum-a-posteriori fit and the log-evidence
	openr,2,fileResult+'.map.prof'
	readf,2,n
	readf,2,logZ
	map = dblarr(3,n)
	readf,2,map
	close,2

; Read Stokes profiles obtained from samples from the posterior
	openr,2,fileResult+'.stokesSamples'
	nStokes = 0L
	readu,2,nStokes
	qu = dblarr(2*n,nStokes)
	temp = dblarr(2*n)
	for i = 0, nStokes-1 do begin
		readu,2,temp
		qu[*,i] = temp
	endfor
	close,2

; Plot the observations, the best fit and the samples from the posterior
	ps_start,'PLOTS/'+strtrim(string(fileOut),2)+'.samples.eps',/encaps,xsize=14,ysize=8
	
	!p.multi = [0,2,1]

	minim = 100.d0*min(obs[1,*]-obs[3,*])
	maxim = 100.d0*max(obs[1,*]+obs[3,*])
	cgplot, obs[0,*], 100.d0*obs[1,*], psym=8, xran=[1215,1216.3], xsty=1, yran=[minim,maxim], xtit='Wavelength [$\angstrom$]', ytit='Q/I [%]'
	for i = 0, 200 do begin
		cgoplot, obs[0,*], 100.d0*qu[0:n-1,i], col='grey'
	endfor
	cgoplot, obs[0,*], 100.d0*obs[1,*], psym=8
	cgerrplot, obs[0,*], 100.d0*obs[1,*]-100.d0*obs[3,*], 100.d0*obs[1,*]+100.d0*obs[3,*]
	cgoplot, map[0,*], 100.d0*map[1,*], col='red', thick=4

	minim = 100.d0*min(obs[2,*]-obs[4,*])
	maxim = 100.d0*max(obs[2,*]+obs[4,*])
	cgplot, obs[0,*], 100.d0*obs[2,*], psym=8, xran=[1215,1216.3], xsty=1, yran=[minim,maxim], xtit='Wavelength [$\angstrom$]', ytit='U/I [%]'
	for i = 0, 200 do begin
		cgoplot, obs[0,*], 100.d0*qu[n:*,i], col='grey'
	endfor
	cgoplot, obs[0,*], 100.d0*obs[2,*], psym=8
	cgerrplot, obs[0,*], 100.d0*obs[2,*]-100.d0*obs[4,*], 100.d0*obs[2,*]+100.d0*obs[4,*]
	cgoplot, map[0,*], 100.d0*map[2,*], col='red', thick=4

	ps_end


; Read the posterior distributions
	nlines = file_lines(fileResult+'post_equal_weights.dat')
	openr,2,fileResult+'post_equal_weights.dat'
	npar = 3
	post = dblarr(npar+1,nlines)
	readf,2,post
	close,2

; Read the 1D marginals
	openr,2,fileResult+'.hist1D'
	readf,2,npar

	singleMarginal = {x: ptr_new(), yStep: ptr_new(), yGauss: ptr_new()}
	marginals = replicate(singleMarginal, npar)
	for i = 0, npar-1 do begin
		readf,2,loop,n
		temp = fltarr(3,n)
		readf,2,temp
		marginals[i].x = ptr_new(reform(temp[0,*]))
		marginals[i].yStep = ptr_new(reform(temp[1,*]))
		marginals[i].yGauss = ptr_new(reform(temp[2,*]))
	endfor
	close,2

; Read the confidence intervals
	openr,2,fileResult+'.confidence'
	est = fltarr(3)
	errup = fltarr(3)
	errdown = fltarr(3)
	temp = fltarr(6,3)
	readf,2,temp
	close,2

	est = temp[0,*]
	map = temp[1,*]
	errdown = temp[2,*]
	errup = temp[3,*]

	ps_start,'PLOTS/'+strtrim(string(fileOut),2)+'.posterior.eps',/encaps,xsize=12,ysize=9
	
	!p.multi = [0,3,3,0,0]
	
; Plot the marginal posteriors for the model parameters

	labels = ['B','$\theta$!dB!n','$\chi$!dB!n']

	for i = 0, 2 do begin
		for j = 0, 2 do begin
			if (i eq j) then begin
				cgplot, (*marginals[i].x), (*marginals[i].yStep), $
					psym=10, ytit='p('+labels[i]+'|Data)', xtit=labels[i], xran=[min((*marginals[i].x))-5, max((*marginals[i].x))+5]
				cgverx, map[i], col='red', thick=3
				cgverx, est[i], col='blue', thick=3
				cgverx, est[i]-errdown[i], col='blue', thick=3, line=2
				cgverx, est[i]+errup[i], col='blue', thick=3, line=2
			endif else begin
				cgplot, post[i,*], post[j,*], psym=3, xtit=labels[i], ytit=labels[j], xran=[min(post[i,*])-5, max(post[i,*])+5], $
					yran=[min(post[j,*])-5, max(post[j,*])+5]
			endelse
		endfor
	endfor

	ps_end

	stop
end
