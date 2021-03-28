echo 0 > program_status.txt
mpiexec -localonly 4 lmp_mpi -sf opt -in liquid.in -var epsi 0.492978 -var sigma 2.959492 -var T1 90.0 -var pres 1.317600
echo 1 > program_status.txt
exit