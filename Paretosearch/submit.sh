#!/bin/bash
#mpiexec -np 8 /home/sumith/installed/lammps-master/src/lmp_g++_openmpi -in /home/sumith/SUMITH_PROJECTS/GA_ANN_PSO_paper/lammps_runs/conf.in -v T1 373.16 -v bs 138.4071 -v pr 205.71
mpiexec -np 8 /home/sumith/installed/lammps-master/src/lmp_g++_openmpi -in conf.in -v T1 373.16 -v bs 138.4071 -v pr 205.71
