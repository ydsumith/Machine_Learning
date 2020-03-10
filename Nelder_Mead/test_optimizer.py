# Nelder Mead opt of Rastrigin function
import math

def cost_estimate(x,n):
    A = 10;    cost = 0;
    itera = 1;
    while itera <= n:
        print(x);
        cost = cost + (x[itera]**2 - A*math.cos(2*math.pi*x[itera]) );
        itera += 1;
    cost = cost + A*n;
    return cost

def main():
    n = 5;
    x = [1,2,1,3,4];
    cost = cost_estimate(x,n);
    print("Cost value = %f", cost);

if __name__ == "__main__":
    main()
