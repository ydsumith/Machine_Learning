# Nelder Mead opt of Rastrigin function
# This function has minimum (0) at xi = {0,0,0,.....,0}
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

    return cost_mat,x_mat;

def main():
    n = 5; dh = 0.01;
    x = [0.1, 1.2, 5.0, 3.0, -1.0];
    cost_mat = np.zeros((n+1,1));
    x_mat = create_initial_simplex(x,n,dh);
    print("Here is the initial simplex\n",x_mat);
    for i in range(n+1): # from x_i to x_n+1
        cost_mat[i] = cost_estimate(x_mat[i][:],n);
    print("\nCost value = \n", cost_mat);
    # sorting
    (cost_mat,x_mat) = sort_mats(cost_mat,x_mat,n);
    print("\nSorted x values\n",x_mat);
    print("\nsorted cost value = \n", cost_mat);

if __name__ == "__main__":
    main()
