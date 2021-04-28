% This is Pattern Search
clc;    tic;    type = 3;
rng('shuffle'); disp('Pareto Search program by Sumith Yesudasan');

switch type
    case 1 % ZDT2
        nvars = 30; lowx = 0; highx = 1;
    case 2 % Schaffer function N. 1
        nvars = 1; lowx = -10; highx = 10;
    case 3
        % ZDT 6
        nvars = 10; lowx = 0; highx = 1;
    case 4 % MD simulation of Morse potential
        nvars = 2; %
        lowx = -10; highx = 10;
    otherwise
        disp('unknown type function');
end
fun = @(x)evaluate_cost(x,type);
%myoutputfunction = @myoutputfunction(options,state,'iter');
function_tol = 1e-6;

lb = zeros(1,nvars); ub = zeros(1,nvars);
lb = lb + lowx;  ub = ub + highx; % Bound of chromosomes

options = optimoptions('gamultiobj',...
    'FunctionTolerance',function_tol,...
    'PopulationSize',100,...
    'MaxGenerations',100,...
    'MaxStallGenerations',10,...
    'OutputFcn',@myoutputfunction,...
    'PlotFcn',{'gaplotpareto','gaplotscores'},...
    'PlotInterval',1);

%-------------------------------------------------------------
[x,fval,exitflag,output,population,scores] = gamultiobj(fun,nvars,[],[],[],[],lb,ub,[],options);

toc;    disp('Program Completed');
