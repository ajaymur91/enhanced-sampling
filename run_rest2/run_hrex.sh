#!/bin/bash
#SBATCH --gres=gpu:4
#SBATCH --nodes=1
##SBATCH -w compute-0-4
#SBATCH --time=0-12:00:00
#SBATCH --partition=yethiraj
#SBATCH --job-name=rest2
#SBATCH --output=JOB.%J.out
#SBATCH --error=JOB.%J.err

#spack load gromacs@2019.4

nrep=4
mpirun -n $nrep gmx_mpi mdrun -v -plumed ../plumed.dat -multidir topol0 topol1 topol2 topol3 -replex 500 -maxh 12 -hrex -dlb no

