#!/bin/bash
#SBATCH --gpus 4
#SBATCH --nodes=1
#SBATCH --time=1-00:00:00
#SBATCH --partition=yethiraj
#SBATCH --job-name=RECT_AA
#SBATCH --output=JOB.%J.out
#SBATCH --error=JOB.%J.err

#spack load gromacs@2019.4

time mpirun -n 4 gmx_mpi mdrun -deffnm md -cpi md.cpt -plumed ../plumed_rect.dat -multidir topol0 topol1 topol2 topol3 -replex 500 -nsteps 500000000 -pin on -maxh 48 -ntomp 1

