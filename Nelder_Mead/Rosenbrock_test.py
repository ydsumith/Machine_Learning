# Implementation of Nelder Mead optimization algorithm
# https://en.wikipedia.org/wiki/Nelder–Mead_method
# testing with Rosenbrock function
# https://en.wikipedia.org/wiki/Rosenbrock_function
# Author - Prof. Sumith Yesudasan
# Year 2020

import numpy as np
import math

def cost_estimate(x,n):
    a = 2.0; b = 100;
    cost = (a-x[0])**2 + b*(x[1]-x[0]**2)**2;
    return cost

def create_initial_simplex(x,n,dh):
    x_mat = np.zeros((n+1,n));
    for i in range(n):
        x_mat[0][i] = x[i];
    for j in range(1,n+1): # row navigation
        for i in range(n): # column nav
            if i == j-1:
                x_mat[j][i] = x[i] + dh;
            else:
                x_mat[j][i] = x[i];
    return x_mat

def sort_mats(cost_mat,x_mat,n):
    ind = np.argsort(cost_mat, axis=0);
    cost_mat = np.take_along_axis(cost_mat, ind, axis=0);
    x_mat = np.take_along_axis(x_mat, ind, axis=0);
    return cost_mat,x_mat;

def main():
    n = 2; dh = 0.001;
    x = [0.01, 0.25];
    alpha = 1.0; gamma = 2.0; rho = 0.5; sigma = 0.5;
    term_tol = 1e-15; MAX_ITER = 200; cur_iter = 0;
    stddev = 1000; # initial val

    cost_mat = np.zeros((n+1,1));
    x_0 = np.zeros((n,1));
    
    x_mat = create_initial_simplex(x,n,dh);
    print("Here is the initial simplex\n",x_mat);

    while stddev > term_tol and cur_iter < MAX_ITER: # termination criteria
        # step 1: estimate the cost of the current simplex
        #-----------------------------------------
        #----optimize below section---------
        #-----------------------------------------
        for i in range(n+1): # from x_i to x_n+1
            cost_mat[i] = cost_estimate(x_mat[i][:],n);
        #--print("\nCost value = \n", cost_mat);
        print("Current iteration = ", cur_iter);
        # sorting
        (cost_mat,x_mat) = sort_mats(cost_mat,x_mat,n);
        #--print("\nSorted x values\n",x_mat);
        #--print("\nsorted cost value = \n", cost_mat);
        stddev = np.std(cost_mat);        
        # step 2: centroid
        x_0 = np.sum(x_mat[0:n][:],axis=0)/n;
        #step 3: reflection
        x_n1 = x_mat[n][:]; # x_(n+1)
        x_r = x_0 + alpha*(x_0-x_n1);
        cost_r = cost_estimate(x_r,n);
        if cost_mat[0] <= cost_r and cost_r < cost_mat[n]:
            x_mat[n][:] = x_r; # Obtaining a new simplex 
        else:
            # step 4: Expansion
            if cost_r < cost_mat[0]:
                x_e = x_0 + gamma*(x_r - x_0);
                cost_e = cost_estimate(x_e,n);
                if cost_e < cost_r:
                    x_mat[n][:] = x_e; # Obtaining a new simplex 
                    cur_iter += 1;
                    continue;
                else:
                    x_mat[n][:] = x_r;  # Obtaining a new simplex 
                    cur_iter += 1;
                    continue;
            #step 5 Contraction
            else: 
                x_c = x_0 + rho*(x_mat[n][:] - x_0);
                cost_c = cost_estimate(x_c,n);
                if cost_c < cost_mat[n]:
                    x_mat[n][:] = x_c;  # Obtaining a new simplex
                    cur_iter += 1;
                    continue;
                #step 6 Shrink
                else:
                    for i in range(1,n+1): # from x_2 to x_n+1
                        x_mat[i][:] = x_mat[0][:] + sigma*(x_mat[i][:] - x_mat[0][:]);                    
        cur_iter += 1;
    # while ends here, terminate the whole business
    print("\nTerminating..\nstddev = ",stddev,", tolerance = ",term_tol);
    print("Total iterations = ",cur_iter);
    print("Best x values = ", x_mat[0][:]);
    print("Cost = \n", cost_mat);
    
if __name__ == "__main__":
    main()
