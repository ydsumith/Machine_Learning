function localcost = evaluate_cost(x)
a = 1; b = 100;
localcost = (a-x(1))^2 + b*(x(2) - x(1)^2)^2;
end