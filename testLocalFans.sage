import itertools as itt
import time

load("functionsSage.sage")

secondaryRepsDim = {i: fileToLists("secondaryFanTropGr37/dim{}.txt".format(i)) for i in range(1,7)}
                    
# if not using the precomputed files, compute secondaryRepsDim with load("computeSecondaryFromGrobFan.sage")
                    
maximalSecondaryCones = set.union(*act_by_G(S7OnRayIndices, set(secondaryRepsDim[6])).values())


starsDimensionDict = {i:star_dict(maximalSecondaryCones, secondaryRepsDim[i]) for i in range(1,6)}
# This is a dictionary where the keys are the dimensions (mod lineality) of the nonmaximal cones, and the value a dimension is another dictionary similar to the output of "star_dict" when  "cones" is the list of all maximal cones in the secondary fan (maximalSecondaryCones), and faceReps will be representatives (up to S7 symmetry) of all non-maximal cones of the given dimension.


# Say sigma is a cone in the secondary fan of TGr_0(3,7), M is the collection of maximal cones in Star(sigma).
# intersectLinearSpansRelDim(M,rays37,lineality37,sigma) computes the difference
# dim (intersection M) - dim sigma. If this is 0, then intersection M = sigma, which is what we want in the
# proof of Lemma 7.3.  allTests below verifies this for all sigma and maximal cones in star(sigma).

allTests = []
for j in [1,2,3,4,5]: 
    cones_j = secondaryRepsDim[j] 
    for sigma in cones_j:
        allTests.append(intersectLinearSpansRelDim(starsDimensionDict[j],rays37,lineality37,sigma))
print(allTests)

