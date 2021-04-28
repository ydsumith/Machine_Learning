clc;clear;

% npar = 30;
% x = zeros(1,npar);
% x(1) = get_rand_values(0, 1, 1, 0);
% x(1,2:npar) = get_rand_values(-1, 1, npar-1, 0);
% 
% cost = evaluate_cost(x);


disp('GA program by Sumith Yesudasan');
NGEN = 10;             % Number of generations
NPAR = 30;               % number of parameters like density, etc
NPOP = 50;             % preferably an even number
keep_rate = 0.5;        % percent of population to keep
mu_rate = 0.1;          % mutation rate
chrom_low = zeros(1,NPAR);
chrom_high = zeros(1,NPAR);
chrom_low = chrom_low -1;   % lower bound of chromosomes
chrom_low(1) = 0;
chrom_high = chrom_high + 1;    % upper bound of chromosomes
STOP_REPEAT = 5;        % number of repetitions for stopping criteria
STOP_TOLERANCE = 1e-8;  % Tolerance value for stopping
MIN_GEN = 20;           % min generations to run to avoid premature converg
history_tolerance = 1e-5; % this is to speed up the cost estimation

%------------------------------------------------------------
% Initialization settings
rng('shuffle');
Nkeep = keep_rate * NPOP;
%Nmate = NPOP - Nkeep;
current_cost = zeros(NPOP,2);
current_population = zeros(NPOP, NPAR);
%offsprings = zeros(Nmate, NPAR); 
N_mutate = round(mu_rate*(NPOP-1)*NPAR);
global_best = [1e+9, 1e+9];
population_best = [1e+9, 1e+9];
stop_counter = 0;
old_best_cost = [1e+9, 1e+9];
GLOBAL_COST_TRACK = zeros(NGEN,2);
LOCAL_COST_TRACK = zeros(NGEN,2);
chromo_history = zeros(NPOP*NGEN,NPAR);
cost_history = zeros(NPOP*NGEN,2);
N_non_repeating_chromosomes = NPOP; % This is to set initially

%------------------------------------------------------------
% First Run
% initialize with random value between xlo and xhi
for i = 1:NPAR
    current_population(:,i) = get_rand_values(chrom_low(i), chrom_high(i) , NPOP, 0); % low_bound, up_bound, n, row
end

% First time estimation of the cost
for i = 1: NPOP
    current_cost(i,:) = evaluate_cost(current_population(i,:));
end

% First time history of chromos and costs
chromo_history(1:NPOP,:) = current_population;
cost_history(1:NPOP,:) = current_cost;

%----------------------------------------------------------------
%------THis is main loop
for current_gen = 1:NGEN
    
    %---------------------------------------------------
    % display the cost space
    subplot(1, 2, 1);
    scatter(current_cost(:,1),current_cost(:,2),'filled');
    java.lang.Thread.sleep(100); % millisecond delays
    
    %---------------------------------------------------
    % sort the population based on cost
    for i = 1:NPOP-1
        for j = i+1:NPOP
            if current_cost(i) > current_cost(j)
                temp = current_cost(i);
                current_cost(i) = current_cost(j);
                current_cost(j) = temp;
                
                temp2 = current_population(i,:);
                current_population(i,:) = current_population(j,:);
                current_population(j,:) = temp2;
            end
        end
    end
    
    %---------------------------------------------------
    % estimate the local and global best
    population_best = min(current_cost);
    if global_best > population_best
        global_best = population_best;
    end
    fprintf('Gen = %d, popul cost = %f, global best = %f\n',current_gen,...
        population_best,global_best);
    for i = 1:3
        fprintf('%d chromo-> ', i);
        for j = 1:NPAR
            fprintf('%f, ', current_population(i,j));
        end
        fprintf(' cost = %f\n', current_cost(i));
    end
    fprintf('\n');
    GLOBAL_COST_TRACK(current_gen,:) = global_best;
    LOCAL_COST_TRACK(current_gen,:) = population_best;
    
    %---------------------------------------------------
    % Stopping criteria
    if abs(population_best-old_best_cost) < STOP_TOLERANCE
        stop_counter = stop_counter + 1;
    else
        stop_counter = 0;
    end
    if stop_counter == STOP_REPEAT
        if current_gen > MIN_GEN
            fprintf('Termination criteria met..Bye\n');
            break;
        else
            stop_counter = 0;
        end
    end
    old_best_cost = population_best;
    
    %---------------------------------------------------
    % Let them mate
    for i = Nkeep+1:NPOP
        
        % find the mommy
        mamalist = randi([1,Nkeep],3,1); % gives 3 random integers btw 1 and Nkeep
        min_ma_cost = min(current_cost(mamalist(1)),min(current_cost(mamalist(2)),current_cost(mamalist(3))));
        for j = 1:3
            if current_cost(mamalist(j)) == min_ma_cost % selecting the ma
                mama =  mamalist(j);
            end
        end
        
        % find the daddy
        papalist = randi([1,Nkeep],3,1); % gives 3 random integers btw 1 and Nkeep
        min_pa_cost = min(current_cost(papalist(1)),min(current_cost(papalist(2)),current_cost(papalist(3))));
        for j = 1:3
            if current_cost(papalist(j)) == min_pa_cost % selecting the pa
                papa =  papalist(j);
            end
        end
        
        % mating process
        beta = rand(1,1); % using same random number for a pair of chromo
        current_population(i,:) = (1+beta)*current_population(mama,:) - beta * current_population(papa,:);
    end
    
    %---------------------------------------------------
    % Let them Mutate
    collist = randi([1,NPAR],N_mutate,1); % get a list of random columns
    rowlist = randi([1,NPOP],N_mutate,1); % get a list of random rows
    
    for i=1:N_mutate
        current_population(rowlist(i), collist(i)) = get_rand_values(chrom_low(collist(i)), chrom_high(collist(i)), 1, 1);
    end
    
    %---------------------------------------------------
    % Estimate the cost
    for i = 1: NPOP
        current_x = current_population(i,:);
        for j=1:N_non_repeating_chromosomes
            found = 0;
           for k=1:NPAR
               if abs(current_x(1,k)- chromo_history(j,k)) <= history_tolerance
                   found = 1;
               else
                   found = 0;
                   break;
               end
           end
           if found == 1 % here only possiblity is we found a match
               current_cost(i) = cost_history(j);
               break;
           end
        end
        if found ==0 % we didnt find a match in the history
            current_cost(i,:) = evaluate_cost(current_population(i,:));
            N_non_repeating_chromosomes = N_non_repeating_chromosomes + 1;
            chromo_history(N_non_repeating_chromosomes,:) = current_x;
            cost_history(N_non_repeating_chromosomes,:) = current_cost(i);
        end
    end

end

fprintf('No: of chromo estimation saved = %d\n\n', current_gen*NPOP - N_non_repeating_chromosomes );

subplot(1, 2, 2);
plot_x = linspace(1,current_gen,current_gen);
p = plot(plot_x, GLOBAL_COST_TRACK(1:current_gen), plot_x, LOCAL_COST_TRACK(1:current_gen));
p(1).LineWidth = 2;
p(1).Marker = 'o';
legend('Global','local');
p(2).LineWidth = 2;
p(2).Marker = 'd';

disp('Program Completed');



