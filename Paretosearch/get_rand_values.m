function rander = get_rand_values(low_bound, up_bound, n, row)
% -- Routine to create random numbers
% low_bound -- lower value of the rand number
% up_bound -- upper value of the rand number
% n -- number of values to be returned
% row -- 0 means col matrix needed, 1 means row matrix
if row ==0
    rander = low_bound + (up_bound-low_bound).*rand(1, n);
else % row matrix
    rander = low_bound + (up_bound-low_bound).*rand(n, 1);
end
end