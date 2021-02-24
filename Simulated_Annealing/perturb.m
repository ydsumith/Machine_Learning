function newstate = perturb(Tk, Tinitial, low_bound, up_bound, current_state, NPAR,myscale)

x = zeros(1,NPAR);

for i = 1:NPAR
    x(i) = current_state(i) + myscale* get_rand_values(low_bound(i), up_bound(i), 1, 0);
end
newstate = x;
end