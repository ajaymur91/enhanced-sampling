#!/bin/bash

spack load gromacs@2019.4

for i in 0 1 2 3
do
        echo $i
        mkdir topol"$i"
        mpirun -n 1 gmx_mpi grompp -f ../mdp/md.mdp -c system.gro -p system.top -o topol"$i"/md.tpr
done

