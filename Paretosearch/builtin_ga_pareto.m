%------------------------------------------------------------
% Initialization settings
clc;    clear;  rng('shuffle'); disp('GA program by Sumith Yesudasan');

fun = @evaluate_cost;

nvars = 30; NPOP = 150;  NGEN = 200; MaxStallGenerations = 10;
function_tol = 1e-3;

lb = zeros(1,nvars); ub = ones(1,nvars);
lb(1,2:nvars) = lb(1,2:nvars) -1;                 % lower bound of chromosomes

options = optimoptions('gamultiobj','PlotFcn',@gaplotpareto,...
    'Display','iter',...
    'InitialPopulationRange',[lb;ub],...
    'MaxGenerations',NGEN,...
    'MaxStallGenerations',MaxStallGenerations,...
    'PopulationSize',NPOP,...
    'FunctionTolerance',function_tol);

lb = []; ub = []; % reset them for unbound opt

%-------------------------------------------------------------
% Main function calls
[x,fval,exitflag,output,population,scores] = gamultiobj(fun,nvars,[],[],[],[],lb,ub,options);

disp('Program Completed');



