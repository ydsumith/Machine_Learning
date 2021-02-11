function adaptive_PSO
clc;clear;

% Based on the below paper
% Z. Zhan, J. Zhang, Y. Li and H. S. Chung, "Adaptive Particle Swarm Optimization,"
% in IEEE Transactions on Systems, Man, and Cybernetics, Part B (Cybernetics),
% vol. 39, no. 6, pp. 1362-1381, Dec. 2009, doi: 10.1109/TSMCB.2009.2015956.

disp('Program for Adaptive PSO');
D = 4; % dimensions like rho, eps etc.
w_max = 0.9; % maximal and minimal weights
w_min = 0.4;
GENERATIONS = 100; % Total generations
NPAR = 20; % Number of particles
c1 = 0.5; % Acceleration coefficients
c2 = 0.1;
tol_criteria = 0.00001;
min_iter = 25;

xlo = [-10, -10, -10, -10];
xhi = [10, 10, 10, 10];

X = zeros(NPAR,D);  V = rand(NPAR,D);
current_cost = zeros(NPAR,1)+100000; % initialize with garbage value
oldcost = current_cost;
pBest_X = zeros(NPAR,D)+100000;
gBest_cost = 1000000; % initialize with garbage value
counter =0;

% initialization with random numbers between the limits
for i = 1:NPAR
    for j = 1:D
        X(i,j) = (xhi(j)-xlo(j))*rand(1,1) + xlo(j);
    end
end

% Initial cost estimation
for i = 1:NPAR
    current_cost(i) = evaluate_cost(X(i,:), D);
end

% Find the best X value in the current population
[pBest_X , oldcost] = find_pBest(X, pBest_X, current_cost, oldcost, NPAR);

% Find the best X value among all generations so far
for i = 1:NPAR
    if oldcost(i) < gBest_cost
        gBest_cost =  oldcost(i);
        gBest_X = pBest_X(i,:);
    end
end

% Main program
for current_GEN = 1:GENERATIONS
    w =  w_max - (w_max - w_min)*(current_GEN/GENERATIONS);
    for i = 1:NPAR
        for j = 1:D
            rand_1 = rand(1);  rand_2 = rand(1);
            V(i,j) = w * V(i,j) + c1 * rand_1 * (pBest_X(i,j) - X(i,j)) + c2 * rand_2 * (gBest_X(j) - X(i,j));
            X(i,j) = X(i,j) + V(i,j);
        end
    end
    % Current cost estimation
    for i = 1:NPAR
        current_cost(i) = evaluate_cost(X(i,:), D);
    end
    
    fprintf('GEN = %d,  best cost = %f\n', current_GEN, gBest_cost);
    fprintf('old = %f, cur = %f\n\n',min(oldcost),min(current_cost ));
    
    if current_GEN > min_iter
        if  min(oldcost) - min(current_cost)  < tol_criteria
            counter = counter +1;
            if counter == 5
                disp('Termination criteria met');
                break;
            end
        else
            counter = 0;
        end
    end
    
    % Find the best X value in the current population
    [pBest_X , oldcost] = find_pBest(X, pBest_X, current_cost, oldcost, NPAR);
    
    % Find the best X value among all generations so far
    for i = 1:NPAR
        if oldcost(i) < gBest_cost
            gBest_cost =  oldcost(i);
            gBest_X = pBest_X(i,:);
        end
    end
    
end
save databackup.mat
disp('Program completed');
end

%--------------------------------------------------------------------------
function [pBest_X , oldcost] = find_pBest(X, pBest_X, current_cost, oldcost, NPAR)
for i = 1:NPAR
    if current_cost(i) <= oldcost(i)
        pBest_X(i,:) = X(i,:);
        oldcost(i) = current_cost(i);
    end
end
end

%--------------------------------------------------------------------------
function localcost = evaluate_cost(xx, D)
sum = 0;
for i = 1:D
    sum = sum + xx(i)*xx(i);
end
localcost = sum;
end
