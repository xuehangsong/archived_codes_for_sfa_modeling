# ============================================================================
# Name        : Makefile for levelset+Tprogs+data assimilation model
# Author      : Xuehang Song
# ============================================================================

.PHONY: module all clean

# Change this line if you are using a different Fortran compiler
FORTRAN_COMPILER = gfortran

#===========================
sourcepath=*.f90 *.f
PRO_NAME=../../exe/facies
FFLAGS=-O3

#=========================objects===================================
sources=$(wildcard $(sourcepath))
objects=$(patsubst %.f,%.o,$(patsubst %f90,%o,$(sources)))

#===========================link Object file========================
all:$(objects)
	$(FORTRAN_COMPILER)  $(FFLAGS) -o  $(PRO_NAME) $(objects)

module:$(aamodule.f90)
	$(FORTRAN_COMPILER) $(FFLAGS) -c aamodule.f90

#==========================Build Object file========================
%.o:%.f90
	$(FORTRAN_COMPILER)  $(FFLAGS) -c $< -o $@ 
%.o:%.f
	$(FORTRAN_COMPILER)  $(FFLAGS) -c $< -o $@ 

#all: src/test.f90
#	$(FORTRAN_COMPILER) -O2 -g -o bin/test.exe 
#		src/test.f90

clean:
	rm -f src/$(objects) $(PRO_NAME) *.mod *.o
