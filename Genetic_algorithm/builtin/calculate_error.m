function cost = calculate_error(filename, ref_density)
fileID = fopen(filename,'r');
linesToSkip = 2;
for ii = 1:linesToSkip
    fgetl(fileID);
end
tline = fgetl(fileID);
if all(tline == -1)
    % disp('empty'); % This happens when a MD simulation failed to complete due
    % to bad parameters. So skip using this candidate
    fclose(fileID);
    cost = 100000;
    return;
end
A = sscanf(tline,'%f %f\n'); % A(2) contains density
fclose(fileID);

cost = abs(ref_density - A(2));
end