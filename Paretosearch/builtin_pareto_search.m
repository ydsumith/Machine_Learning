% This is Pattern Search
clc;    tic;    type = 2;
rng('shuffle'); disp('Pareto Search program by Sumith Yesudasan');

switch type
    case 1 % ZDT2
        nvars = 30; lowx = 0; highx = 1;
    case 2 % Schaffer function N. 1
        nvars = 1; lowx = -10; highx = 10;
    case 3 % MD simulation of Morse potential
        nvars = 2; %
        lowx = -10; highx = 10;
    otherwise
        disp('unknown type function');
end
fun = @(x)evaluate_cost(x,type);
function_tol = 1e-6;

lb = zeros(1,nvars); ub = zeros(1,nvars);
lb = lb - lowx;  ub = ub + highx; % Bound of chromosomes

options = optimoptions('paretosearch',...
    'ParetoSetChangeTolerance',function_tol,...
    'PlotFcn','psplotparetof');

%-------------------------------------------------------------
% Custòdio, A. L., J. F. A. Madeira, A. I. F. Vaz, and L. N. Vicente...
% Direct Multisearch for Multiobjective Optimization. SIAM J. Optim., 21(3), 2011, pp. 1109–1140.
[x,fval,exitflag,output,residuals] = paretosearch(fun,nvars,[],[],[],[],lb,ub,[],options);

toc;    disp('Program Completed');
