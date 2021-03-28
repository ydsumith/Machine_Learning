function localcost = evaluate_cost(x)
root_directory = 'C:\Sumith_Projects\LAMMPS_run\GA_testing_builtin';
cd(root_directory);

%-----initial cleanup
fileID = fopen('dens_90.0.txt','w');
fclose(fileID);

%---create and write the batch submission file.
fileID = fopen('submit.bat','w');
fprintf(fileID,'echo 0 > program_status.txt\n');
fprintf(fileID,['mpiexec -localonly 4 lmp_mpi -sf opt -in liquid.in -var epsi %f ',...
    '-var sigma %f -var T1 90.0 -var pres %f\n'],x(1),x(2),1.3176);
fprintf(fileID,'echo 1 > program_status.txt\n');
fprintf(fileID,'exit');
fclose(fileID);

%----submit the batch file
command = 'submit.bat';
[status,cmdout] = system(command,'-echo');

%----wait until all runs are over
formatSpec = '%d';
completed =0;
while completed ==0
    java.lang.Thread.sleep(2*1000);
    fileID = fopen('program_status.txt','r');
    completed = fscanf(fileID,formatSpec);
    fclose(fileID);
end

%---wait is over now read the results
cost1 = calculate_error('dens_90.0.txt',1378.6);
localcost = cost1;

end