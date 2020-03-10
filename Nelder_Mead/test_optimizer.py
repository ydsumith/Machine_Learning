# Nelder Mead opt of Rastrigin function
# This function has minimum (0) at xi = {0,0,0,.....,0}
# Implementation of Nelder Mead optimization algorithm
# https://en.wikipedia.org/wiki/Nelder–Mead_method

import numpy as np
import math

def cost_estimate(x,n):
    A = 10;    cost = 0;    itera = 0;
    while itera < n:
        cost = cost + (x[itera]**2 - A*math.cos(2 * math.pi * x[itera]));
        itera += 1;
    cost = cost + A*n;
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
    n = 5; dh = 0.01;
    x = [0.1, 1.2, 5.0, 3.0, -1.0];
    alpha = 1.0; gamma = 2.0; rho = 0.5; sigma = 0.5;

    cost_mat = np.zeros((n+1,1));
    x_0 = np.zeros((n,1));
    
    x_mat = create_initial_simplex(x,n,dh);
    print("Here is the initial simplex\n",x_mat);
    for i in range(n+1): # from x_i to x_n+1
        cost_mat[i] = cost_estimate(x_mat[i][:],n);
    print("\nCost value = \n", cost_mat);
    # step 1: sorting
    (cost_mat,x_mat) = sort_mats(cost_mat,x_mat,n);
    print("\nSorted x values\n",x_mat);
    print("\nsorted cost value = \n", cost_mat);
    # step 2: centroid
    x_0 = np.sum(x_mat[0:n][:],axis=0)/n;
    print("x_0\n",x_0);
    #step 3: reflection
    x_n1 = x_mat[n][:]; # x_(n+1)
    x_r = x_0 + alpha*(x_0-x_n1);
    cost_r = cost_estimate(x_r,n);
    if cost_mat[0] <= cost_r:
        if cost_r < cost_mat[n]:
            # goto step 1
        
    print(x_r)
    
if __name__ == "__main__":
    main()
