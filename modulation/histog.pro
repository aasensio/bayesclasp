function histog, a, nbins=nbins, binsize=binsize, plot=plot, optimbin=optimbin, min=min, max=max, _extra=_extra
	if (not keyword_set(min)) then begin
		mina = min(a)
	endif else begin
		mina = min
	endelse
	if (not keyword_set(max)) then begin
		maxa = max(a)
	endif else begin
		maxa = max
	endelse
	if (keyword_set(optimbin)) then begin
		binopt = optbin(a)
		h = histogram(a,binsize=binopt,min=mina,max=maxa)
		n = n_elements(h)
		x = findgen(n) * binopt + mina
		if (keyword_set(plot)) then begin
	 		plot,x,h, psym=10, _extra=_extra
	 	endif
		return,[[x],[h]]
	endif
		
	if (keyword_set(nbins)) then begin
		h = histogram(a,nbins=nbins,min=mina,max=maxa)	 
	 	x = findgen(nbins)/(nbins-1.d0) * (maxa-mina) + mina
	 	if (keyword_set(plot)) then begin
	 		plot,x,h, psym=10, _extra=_extra
	 	endif
	 	return,[[x],[h]]
	endif
	 
	if (keyword_set(binsize)) then begin
		h = histogram(a,binsize=binsize,min=mina,max=maxa)
		n = n_elements(h)
		x = findgen(n) * binsize + mina
		if (keyword_set(plot)) then begin
	 		plot,x,h, psym=10, _extra=_extra
	 	endif
		return,[[x],[h]]
	endif
	 	 
end
