# extract C_alpha atoms from gro
```
grep " CA " ../run_rest2/system.gro | awk '{print $3}' | awk '{printf "%s,",$0} END {print ""}' | sed s/.$// > C_ALPHA.txt
```
- Use contents of C_ALPHA.txt to create plumed_rect.dat (see plumed_rect.dat)

# make run folders (here i use 4 replicas - see make_run_folders.sh) 
```
bash make_run_folders.sh
```
# Run RECT
```
sbatch run_rect.sh 
```
