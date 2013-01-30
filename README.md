bayesclasp
==========

Bayesian inference for the CLASP mission.

This code uses a suitable database for the expected polarization in the Lyman-alpha
line to carry out Bayesian inference from CLASP observations to get information
about the magnetic field vector (B, thetaB, chiB).

The code can be compiled with any standard Fortran 90 compiler (ifort, gfortran, etc.)
by just invoking

	make all

in the SOURCE directory.

The code is then run with:

	./run.py conf.ini

once the configuration file (which is self-explanatory) has been properly set. Note that this
distribution does not contain the databases.

### Author

A. Asensio Ramos
