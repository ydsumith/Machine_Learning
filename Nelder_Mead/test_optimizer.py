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
        for i in range(n):
            if i == j-1:
                x_mat[j][i] = x[i] + dh;
            else:
                x_mat[j][i] = x[i];
    ret_val = x_mat;
    return ret_val

def main():
    n = 5; dh = 0.01;
    x = [0.1, 1.2, 5.0, 3.0, -1.0];
    ret_val = create_initial_simplex(x,n,dh);
    print(ret_val);
    cost = cost_estimate(x,n);
    print("Cost value = ", cost);

if __name__ == "__main__":
    main()
