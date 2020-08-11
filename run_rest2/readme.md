# REST2 simulations using gromacs+plumed
```
	 spack install gromacs@2019.4 +cuda+plumed
         spack load gromacs@2019.4
         cp ../min_eq/npt.gro ./system.gro
```
# Generate system.top (a standalone topology that does not require itp files)
```
	gmx_mpi grompp -f ../mdp/md.mdp -c system.gro -p ../system/topol.top -pp system.top
```

# Create processed.top that defines which solute atoms will be "heated" - see below comments
	cp system.top processed.top

# edit processed.top (where each "hot" atom has a "_" appended to the atom type) 
# note the _ added in the [ atoms ] section for the peptide

# four replicas (starling 4 gpus's per node - so using four replicas for max hardware efficiency.)
	nrep=4

# "effective" temperature range of the hot atoms - adjust for required exchange rates between replicas
	tmin=300
	tmax=400

# build geometric progression of temperatures
	list=$(
	awk -v n=$nrep \
    	-v tmin=$tmin \
    	-v tmax=$tmax \
  	'BEGIN{for(i=0;i<n;i++){
    	t=tmin*exp(i*log(tmax/tmin)/(n-1));
    	printf(t); if(i<n-1)printf(",");
  	}
	}'
	)
	echo "intermediate temperatures are $list"

# clean directory (pre-existing folders)
	#rm -fr topol*

#Create the replica folders
     for((i=0;i<nrep;i++))
	do
	mkdir topol$i #might throw error if folder exists - ignore
	lambda=$(echo $list | awk 'BEGIN{FS=",";}{print $1/$'$((i+1))';}')

	# process topology (create the "hamiltonian-scaled" forcefields)
  	mpirun -n 1 plumed partial_tempering $lambda < processed.top > topol"$i"/topol.top

	# prepare tpr files
  	mpirun -n 1 gmx_mpi grompp -c system.gro -o topol"$i"/topol.tpr -f ../mdp/md.mdp -p topol"$i"/topol.top
	done

#run hrex
	#sbatch run_hrex.sh
