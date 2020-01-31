import itertools as itt
import time
from multiprocessing import Pool
from functools import partial

load("grobToSecondaryFunctions.sage")


MSDToGrob = {}
for i in range(len(coneRepsAll)):
    for s in S7:
        sMSD = s_on_MSD_index(7,s,MSDs_index[i])
        sCone = s_on_cone(7,s, coneRepsAll[i])
        if sMSD not in MSDToGrob.keys():
            MSDToGrob[sMSD] = set()
        MSDToGrob[sMSD].update(sCone)
# This is a dictionary where the keys are MSDs_index and the value at MSDi in MSDs_index is the list of all cones of the Groebner fan of TGr_0(3,7) whose matroid subdivision is MSDi.

# Note: this takes a long time. We only need the S7-reps, namely the "secondaryRepsDim" dictionary below. The data of the cones is contained in the files "secondaryConesDim{i}.txt" where {i}=1,2,3,4,5,6. See secondaryRepsDim below for how to extract this data from the files. 


newRays = set([list(c)[0][0] for c in MSDToGrob.values() if len(c) == 1 and len(list(c)[0]) == 1])
# this is a list of the rays in TGr_0(3,7) with the secondary fan structure, i.e., we all rays whose corresponding matroid subdivision is not that of a larger dimensional cone.


secondaryToGrob = {}
for msd in MSDToGrob.keys():
    secondaryCone =  tuple(sorted(list(set.union(*[set(cone).intersection(newRays) for cone in MSDToGrob[msd]]))))    
    secondaryToGrob[secondaryCone] = MSDToGrob[msd]
# A dictionary where the keys are the union of all the cones in MSDToGrob[MSDi] (a cone in the secondary fan), and the value is MSDToGrob[MSDi] (the cones in the Groebner fan that glue to give the cone in the secondary fan).


secondaryReps = G_orbits(S7OnRayIndices, set(secondaryToGrob.keys()))
# This gives S7-orbit representatives of the cones in the secondary fan, i.e., the keys of the dictionary secondaryToGrob. 


secondaryRepsDim = {}
for c in secondaryReps:
    dimc = max([len(gc) for gc in secondaryToGrob[c]])
    if dimc not in secondaryRepsDim.keys():
        secondaryRepsDim[dimc] = []
    secondaryRepsDim[dimc].append(c)
# This is a dictionary, the keys are the dimension (modulo the lineality space) of the cones in the secondary fan, the value at a dimension is a list of a11 S7-reps of secondary cones from secondaryReps of the prescribed dimension.
