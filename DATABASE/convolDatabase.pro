pro convolDatabase, file

	openr,2,file
	lambda = dblarr(62)
	readu,2,lambda
	int = dblarr(62)
	readu,2,int
	temp = dblarr(124,73,37,51)
	readu,2,temp
	close,2

; Generate new wavelength axis. +-1A around 1215.65 A with a samping of 0.05
	nl = 2.d0 / 0.05d0 + 1
	lambda_final = 1215.65d0 + findgen(nl) * 0.05d0 - 1.d0

	qu_new = dblarr(2*nl,73,37,51)

; Axis with a very fine grid to carry out the convolution
	lambda_new = findgen(1000) / 999.d0 * (max(lambda)-min(lambda)) + min(lambda)

	fwhm = 0.13
	sigma_l = fwhm / 1.67d0
   sigma_v = sigma_l / 1216.d0 * 3.d10

   for i = 0, 72 do begin
	   print, i
	   for j = 0, 36 do begin
		   for k = 0, 50 do begin
				resQ = interpol(temp[0:61,i,j,k], lambda, lambda_new)
				resU = interpol(temp[62:*,i,j,k], lambda, lambda_new)

				resQ = macrosmooth(lambda_new, resQ, 1216.d0, sigma_v)
				resU = macrosmooth(lambda_new, resU, 1216.d0, sigma_v)

				resQ = interpol(resQ, lambda_new, lambda_final)
				resU = interpol(resU, lambda_new, lambda_final)

				qu_new[0:nl-1,i,j,k] = resQ
				qu_new[nl:*,i,j,k] = resU
				
		   endfor
		endfor
	endfor

	resI = interpol(int, lambda, lambda_new)
	resI = macrosmooth(lambda_new, resI, 1216.d0, sigma_v)
	resI = interpol(resI, lambda_new, lambda_final)

	openw,2,file+'.convolved'
	writeu,2,lambda_final
	writeu,2,resI	
	writeu,2,qu_new
	close,2

	stop
	
end