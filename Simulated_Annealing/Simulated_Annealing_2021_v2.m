clc; clear;

disp('SA program by Prof. Sumith Yesudasan');

%------------------------------------------------------------
% user supplied variables
TInitial = 10;               % Initial Temperature
low_bound = [-5, -5];   % lower bound of the variables
upper_bound = [5, 5];   % upper bound of the variables
NPAR = 2;
myscale = 0.2;
Perturb_K = 50;
NITER = 1000;
global_cost = 100000;

%------------------------------------------------------------
% Initialization settings
current_state = get_rand_values(low_bound, upper_bound, NPAR, 0);
global_X = zeros(1,NPAR);

%-------------
% First time cost estimation
current_cost = evaluate_cost(current_state);

for curr_iter = 1:NITER
    fprintf('cost = %f, params = ', current_cost);
    for i =1:NPAR
        fprintf('%f\t',current_state(i));
    end
    fprintf('\n');
    
    %---------
    % Current temperature
    Tk = TInitial / (curr_iter + 1.0);
    
    %--------
    % Perturb and get a new state
    for i = 1:Perturb_K
        new_state = perturb(Tk, TInitial, low_bound, upper_bound, current_state, NPAR, myscale);
        
        %-------------
        % Cost estimation
        new_cost = evaluate_cost(new_state);
        if new_cost < global_cost
            global_cost = new_cost;
            global_X = new_state;
        end
        
        %------------
        % check to accept
        delta_E = new_cost - current_cost;
        rand1 = rand(1);
        
        if delta_E <= 0 || exp(-delta_E/Tk) > rand1
            current_state = new_state;
            current_cost = new_cost;
        end
    end
    
end

fprintf('current cost : %f\n', current_cost );
fprintf('current parameters');
for i=1:NPAR
    fprintf(', %f ', current_state(i));
end
fprintf('\n');

fprintf('Best cost : %f\n', global_cost );
fprintf('Best parameters');
for i=1:NPAR
    fprintf(', %f ', global_X(i));
end
fprintf('\n');

disp('Program Completed');