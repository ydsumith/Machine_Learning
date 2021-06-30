import numpy as np

# Based on the below paper
# Z. Zhan, J. Zhang, Y. Li and H. S. Chung, "Adaptive Particle Swarm Optimization,"
# in IEEE Transactions on Systems, Man, and Cybernetics, Part B (Cybernetics),
# vol. 39, no. 6, pp. 1362-1381, Dec. 2009, doi: 10.1109/TSMCB.2009.2015956.


#--------------------------------------------------------------------------
def find_pBest(X, pBest_X, current_cost, oldcost, NPAR):
    for i in range(NPAR):
        if current_cost[i] <= oldcost[i]:
            pBest_X[i,:] = X[i,:]
            oldcost[i] = current_cost[i]
    
    return pBest_X , oldcost

#--------------------------------------------------------------------------
def evaluate_cost(xx, D):
    sum = 0;
    for i in range(D):
        sum = sum + xx[i]**2
    
    return sum # localcost

def main():
    print('\n\nProgram for Adaptive PSO');
    filelog = open("logfile.txt", "w")
    D = 4; # dimensions like rho, eps etc.
    w_max = 0.9; # maximal and minimal weights
    w_min = 0.4;
    GENERATIONS = 100; # Total generations
    NPAR = 20; # Number of particles
    c1 = 0.5; # Acceleration coefficients
    c2 = 0.1;
    tol_criteria = 0.00001;
    min_iter = 25;

    xlo = [-10, -10, -10, -10];
    xhi = [10, 10, 10, 10];

    X = np.zeros((NPAR,D));
    V = np.random.rand(NPAR,D);
    current_cost = np.zeros((NPAR,1))+100000; # initialize with garbage value
    oldcost = np.zeros((NPAR,1))+100000;
    pBest_X = np.zeros((NPAR,D))+100000;
    gBest_cost = 1000000; # initialize with garbage value
    counter =0;

    # initialization with random numbers between the limits
    for i in range(NPAR):
        for j in range(D):
            X[i,j] = (xhi[j] - xlo[j]) * np.random.rand(1,1) + xlo[j];
        
    # Initial cost estimation
    for i in range(NPAR):
        current_cost[i] = evaluate_cost(X[i,:], D)

    # Find the best X value in the current population
    (pBest_X , oldcost) = find_pBest(X, pBest_X, current_cost, oldcost, NPAR)

    # Find the best X value among all generations so far
    for i in range(NPAR):
        if oldcost[i] < gBest_cost:
            gBest_cost =  oldcost[i];
            gBest_X = pBest_X[i,:];
        

    # Main program
    for current_GEN in range(1,GENERATIONS,1):
        w =  w_max - (w_max - w_min) * (current_GEN/GENERATIONS);
        for i in range(NPAR):
            for j in range(D):
                rand_1 = np.random.rand(1)
                rand_2 = np.random.rand(1);
                V[i,j] = w * V[i,j] + c1 * rand_1 * (pBest_X[i,j] - X[i,j]) + c2 * rand_2 * (gBest_X[j] - X[i,j]);
                X[i,j] = X[i,j] + V[i,j];

        # Current cost estimation
        for i in range(NPAR):
            current_cost[i] = evaluate_cost(X[i,:], D)
                
        filelog.write('GEN = %d,  best cost = %f\n' % (current_GEN, gBest_cost));
        filelog.write('old = %f, cur = %f\n' % (min(oldcost),min(current_cost)));
        filelog.write('cuurent best parameters are\n')
        for i in range(D):
            filelog.write('%f ' % gBest_X[i])
        filelog.write('\n\n')
        
        if current_GEN > min_iter:
            if min(oldcost) - min(current_cost)  < tol_criteria:
                counter = counter +1;
                if counter == 10:
                    print('Termination criteria met');
                    break
            else:
                counter = 0
            
        # Find the best X value in the current population
        (pBest_X , oldcost) = find_pBest(X, pBest_X, current_cost, oldcost, NPAR);
        
        # Find the best X value among all generations so far
        for i in range(NPAR):
            if oldcost[i] < gBest_cost:
                gBest_cost =  oldcost[i];
                gBest_X = pBest_X[i,:];
                
    filelog.close()
    print('Program completed\n\n')


if __name__ == "__main__":
    main()

