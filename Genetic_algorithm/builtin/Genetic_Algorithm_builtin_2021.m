clc;clear;
rng default % For reproducibility

fun = @evaluate_cost;
nvars = 2;
A = [];
b = [];
Aeq = [];
beq = [];
lb = []; % set using below functions
ub = [];
nonlcon = [];
options = optimoptions('ga','OutputFcn',@gaoutfun,'CrossoverFraction',0.2);
%opts = optimoptions(@ga,'PlotFcn',{@gaplotbestf,@gaplotstopping});
opts = optimoptions(options,'MaxGenerations',100,'MaxStallGenerations', 20);
opts.PopulationSize = 10;
opts.InitialPopulationRange = [0.3 2.0; 0.5 3];

[x,fval,exitflag,output,population,scores] = ga(fun,nvars,A,b,Aeq,beq,lb,ub,nonlcon,opts);

fprintf('The number of generations was : %d\n', output.generations);
fprintf('The number of function evaluations was : %d\n', output.funccount);
fprintf('The best function value found was : %g\n', fval);