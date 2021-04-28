function localcost = evaluate_cost(x,type)
[row,col] = size(x);
localcost = zeros(1,col);
switch (type)
    case 1
        % ZDT2 problem from https://sop.tik.ee.ethz.ch/download/supplementary/testproblems/zdt2/
        x(x<0) = 0;
        x(x>1) = 1;
        
        gx = 1;
        for i = 2:30
            gx = gx + (9/29)*x(i);
        end
        
        localcost(1,1) = x(1);
        localcost(1,2) = gx *(1 - (localcost(1,1)/gx)*(localcost(1,1)/gx));
    case 2
        %Schaffer function N. 1
        localcost(1,1) = x(1).^2;
        localcost(1,2) = (x(1)-2).^2;
    case 3
        % ZDT 6
        x(x<0) = 0;   x(x>1) = 1;  sum =0;
        for i = 2:10
            sum = sum + x(i);
        end
        gx = 1 + 9*(sum/9)^0.25; 
        f1x = 1 - exp(-4*x(1))*(sin(6*pi*x(1)))^6;
        hx = 1 - (f1x/gx)^2;
        f2x = gx*hx;
        localcost(1,1) = f1x;
        localcost(1,2) = f2x;
    otherwise
        disp('[Error]: Unknown cost function');
end

end