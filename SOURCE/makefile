# Makefile for building the MCMC F90 code BayesME

# Select compiler
# Intel Fortran compiler
# COMPILER = ifort
# OPTIONS = -c -O3

# GFortran
COMPILER = gfortran
OPTIONS = -c -frecord-marker=4 -ffree-form


NESTED_LIB = NESTED
NESTED_INC = NESTED
LAPACK_LIB = LAPACK

LIBS=-L$(NESTED_LIB) -L$(LAPACK_LIB) -lnest3 -llapack_LINUX -lguide -lpthread

.SUFFIXES: .f .o

.f.o:
	$(COMPILER) $(OPTIONS) $< -o $@

OBJECTS = chk_g95.o chainAnalysis.o database.o like.o maths.o vars.o init.o main.o

OBJECTS_NESTED = NESTED/utils.o NESTED/utils1.o NESTED/priors.o NESTED/kmeans_clstr.o NESTED/xmeans_clstr.o \
   NESTED/posterior.o NESTED/nested.o

OBJECTS_LAPACK = LAPACK/dasum.o LAPACK/dgehrd.o LAPACK/dladiv.o LAPACK/dlahr2.o LAPACK/dlanv2.o \
   LAPACK/dlar1v.o LAPACK/dlarrb.o LAPACK/dlarrv.o LAPACK/dlasq5.o LAPACK/dorghr.o LAPACK/dpotf2.o \
   LAPACK/dswap.o LAPACK/dtrevc.o LAPACK/iladlr.o LAPACK/daxpy.o LAPACK/dgemm.o LAPACK/dlae2.o \
   LAPACK/dlaisnan.o LAPACK/dlapy2.o LAPACK/dlarfb.o LAPACK/dlarrc.o LAPACK/dlartg.o LAPACK/dlasq6.o \
   LAPACK/dorgqr.o LAPACK/dpotrf.o LAPACK/dsyevr.o LAPACK/dtrexc.o  LAPACK/ilaenv.o LAPACK/dcopy.o LAPACK/dgemv.o \
   LAPACK/dlaebz.o LAPACK/dlaln2.o LAPACK/dlaqr0.o LAPACK/dlarfg.o LAPACK/dlarrd.o LAPACK/dlaruv.o \
   LAPACK/dlasrt.o LAPACK/dorm2l.o LAPACK/drot.o   LAPACK/dsymv.o  LAPACK/dtrmm.o  LAPACK/iparmq.o \
   LAPACK/ddot.o   LAPACK/dger.o   LAPACK/dlaev2.o LAPACK/dlamch.o   LAPACK/dlaqr1.o LAPACK/dlarf.o  \
   LAPACK/dlarre.o LAPACK/dlascl.o LAPACK/dlassq.o LAPACK/dorm2r.o LAPACK/dscal.o  LAPACK/dsyr2k.o \
   LAPACK/dtrmv.o  LAPACK/lsame.o LAPACK/dgebak.o LAPACK/dhseqr.o LAPACK/dlaexc.o LAPACK/dlaneg.o \
   LAPACK/dlaqr2.o LAPACK/dlarft.o LAPACK/dlarrf.o LAPACK/dlaset.o LAPACK/dlasy2.o LAPACK/dormhr.o \
   LAPACK/dstebz.o LAPACK/dsyr2.o  LAPACK/dtrsm.o  LAPACK/xerbla.o LAPACK/dgebal.o LAPACK/disnan.o \
   LAPACK/dlagtf.o LAPACK/dlange.o  LAPACK/dlaqr3.o LAPACK/dlarfx.o LAPACK/dlarrj.o LAPACK/dlasq2.o \
   LAPACK/dlatrd.o LAPACK/dormql.o LAPACK/dstein.o LAPACK/dsyrk.o LAPACK/idamax.o LAPACK/dgeev.o \
   LAPACK/dlabad.o LAPACK/dlagts.o LAPACK/dlanst.o   LAPACK/dlaqr4.o LAPACK/dlarnv.o LAPACK/dlarrk.o \
   LAPACK/dlasq3.o LAPACK/dnrm2.o  LAPACK/dormqr.o LAPACK/dstemr.o LAPACK/dsytd2.o LAPACK/ieeeck.o \
   LAPACK/dgehd2.o LAPACK/dlacpy.o LAPACK/dlahqr.o LAPACK/dlansy.o   LAPACK/dlaqr5.o LAPACK/dlarra.o \
   LAPACK/dlarrr.o LAPACK/dlasq4.o LAPACK/dorg2r.o LAPACK/dormtr.o LAPACK/dsterf.o LAPACK/dsytrd.o LAPACK/iladlc.o


mcmc: $(OBJECTS)
	$(COMPILER) $(OBJECTS) -o mcmc $(LIBS)
	cp mcmc ../
	
all:
	make lapack
	make nested
	make mcmc
	
lapack: $(OBJECTS_LAPACK)
	ar cr LAPACK/liblapack_LINUX.a $(OBJECTS_LAPACK)

nested: $(OBJECTS_NESTED)
	ar cr NESTED/libnest3.a $(OBJECTS_NESTED)

clean:
	find . -maxdepth 3 -name "*.o" -delete ; find . -maxdepth 3 -name "*.mod" -delete
	find . -maxdepth 1 -name "*.f90~" -delete ; find . -maxdepth 1 -name "mcmc" -delete
	find ../ -maxdepth 1 -name "mcmc" -delete ; find . -maxdepth 2 -name "*.a" -delete

chk_g95.o: chk_g95.f90
	$(COMPILER) $(OPTIONS) chk_g95.f90
	
maths.o: maths.f90
	$(COMPILER) $(OPTIONS) -I$(NESTED_INC) maths.f90

chainAnalysis.o: chainAnalysis.f90 vars.o maths.o database.o
	$(COMPILER) $(OPTIONS) chainAnalysis.f90

vars.o: vars.f90
	$(COMPILER) $(OPTIONS) vars.f90

database.o: database.f90 maths.o vars.o chk_g95.o
	$(COMPILER) $(OPTIONS) database.f90

init.o: init.f90 maths.o vars.o
	$(COMPILER) $(OPTIONS) init.f90

like.o: like.f90 vars.o maths.o database.o
	$(COMPILER) $(OPTIONS) -I$(NESTED_INC) like.f90
	
main.o: main.f90 init.o like.o maths.o vars.o database.o chainAnalysis.o
	$(COMPILER) $(OPTIONS) -I$(NESTED_INC) main.f90

NESTED/utils.o: NESTED/utils.f90
	$(COMPILER) $(OPTIONS) NESTED/utils.f90 -o NESTED/utils.o

NESTED/utils1.o: NESTED/utils1.f90
	$(COMPILER) $(OPTIONS) NESTED/utils1.f90 -o NESTED/utils1.o

NESTED/priors.o: NESTED/priors.f90
	$(COMPILER) $(OPTIONS) NESTED/priors.f90 -o NESTED/priors.o

NESTED/kmeans_clstr.o: NESTED/kmeans_clstr.f90
	$(COMPILER) $(OPTIONS) NESTED/kmeans_clstr.f90 -o NESTED/kmeans_clstr.o

NESTED/xmeans_clstr.o: NESTED/xmeans_clstr.f90
	$(COMPILER) $(OPTIONS) NESTED/xmeans_clstr.f90 -o NESTED/xmeans_clstr.o

NESTED/posterior.o: NESTED/posterior.F90
	$(COMPILER) $(OPTIONS) NESTED/posterior.F90 -o NESTED/posterior.o

NESTED/nested.o: NESTED/nested.F90
	$(COMPILER) $(OPTIONS) NESTED/nested.F90 -o NESTED/nested.o
