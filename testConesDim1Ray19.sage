import itertools as itt
import time
from multiprocessing import Pool
from functools import partial

load("grobToSecondaryFunctions.sage")

secondaryRepsDim = {i: fileToLists("secondaryConesDim{}.txt".format(i)) for i in range(1,7)}
# if not using the precomputed files, compute secondaryRepsDim with load("computeSecondaryFromGrobFan.sage")
                    
maximalSecondaryCones = set.union(*act_by_G(S7OnRayIndices, set(secondaryRepsDim[6])).values())


starsDimensionDict = {i:star_dict(maximalSecondaryCones, secondaryRepsDim[i]) for i in range(1,6)}
# This is a dictionary where the keys are the dimensions (mod lineality) of the nonmaximal cones, and the value a dimension is another dictionary similar to the output of "star_dict" when  "cones" is the list of all maximal cones in the secondary fan (maximalSecondaryCones), and faceReps will be representatives (up to S7 symmetry) of all non-maximal cones of the given dimension.

pool = Pool(processes=8)  # can set the parameter of Pool to the number of cpus you want to use. an empty parameter just uses all available cpus. We use 8 for the computation below. 

# Say maxCone1 and maxCone2 are maximal cones in Star(cone). We want to show that maxCone1 intersects (-1)maxCone2 at 0 in N_R/span(cone). To do this, we put the rays of "cone" in the lineality spaces of maxCone1 and maxCone2, intersect maxCone1 and (-1)maxCone2, and show that this intersection has dimension that of cone.

cone = tuple([378])
sL = len(starsDimensionDict[1][cone])

partial_test = partial(test_pair, starsDimensionDict, rays37, lineality37, 1, cone) # this is a preparation to use the pool.map function
                    
pairs=list(itt.combinations(range(sL),2))
# there are {14823 choose 2} = 109853253 pairs! It is better to break this up into several pieces and test each one on a different machine.  

pairsSlices =[pairs[i:i+len(10000000)] for i in range(10)].append(pairs[100000000:])
# this splits up pairs into roughly 11 equal sized pieces. 

k=0 # change this parameter to 0,1,..., 11 to verify each piece.
tests = pool.map(partial_test, pairsSlices[k]) # this tests all pairs of maximal cones in a parallel computation.

print(all([e==8 for e in tests])) # if True, then intersection maxCone1 and (-1)maxCone2 = 0 in N_R/span(cone).  
