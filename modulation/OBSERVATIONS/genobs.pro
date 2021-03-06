; Generate a sample profile and add some noise
; genobs, '../DATABASE/db_03.iqu', 30, 6, 12, 1.d-3
pro genobs, file, whichB, whichthB, whichchiB, noise

	if (strpos(file,'convolved') ne -1) then begin
	
; We use one of the original databases
		openr,2,file
		lambda = dblarr(41)
		readu,2,lambda
		int = dblarr(41)
		readu,2,int
		temp = dblarr(82,73,37,51)
		readu,2,temp

		q = temp[0:40,*,*,*]
		u = temp[41:*,*,*,*]
		nl = 41
		
	endif else begin

; We use one of the original databases
		openr,2,file
		lambda = dblarr(62)
		readu,2,lambda
		int = dblarr(62)
		readu,2,int
		temp = dblarr(124,73,37,51)
		readu,2,temp

		q = temp[0:61,*,*,*]
		u = temp[62:*,*,*,*]
		nl = 62
	endelse

	B = findgen(51) * 5.d0
	thB = findgen(37) * 5.d0
	chiB = findgen(73) * 5.d0

	close,2

	qnoise = q[*,whichchiB,whichthB,whichB] / int + noise*randomn(seed,62)
	unoise = u[*,whichchiB,whichthB,whichB] / int + noise*randomn(seed,62)

	openw,2,'test.obs', width=150
	printf,2,nl
	for i = 0, nl-1 do begin
		printf, 2, lambda[i], qnoise[i], unoise[i], noise, noise
	endfor
	close,2

	print, 'Wrote profile for B=', B[whichB], ' - thB=', thB[whichthB], ' - chiB=', chiB[whichchiB]

	!p.multi = [0,2,1]
	
	cwpal
	plot, lambda, qnoise
	oplot, lambda, q[*,whichchiB,whichthB,whichB] / int, col=2

	plot, lambda, unoise
	oplot, lambda, u[*,whichchiB,whichthB,whichB] / int, col=2

	!p.multi = 0

	stop
end