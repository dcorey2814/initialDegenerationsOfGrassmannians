# initialDegenerationsOfGrassmannians

Here is a summary of the files. 



For the proof that initial degenerations are isomorphic to limits of thin Schubert cells and that limits are smooth:

TGr37.txt contains the data of the Groebner fan structure of TGr_0(3,7) computed by gfan, which can be done using initialDegenerationsMSD.m2 below.

initialDegenerationsMSD.m2 contains the Macaulay2 (v1.15) code used in the proofs that initial degenerations are isomorphic to limits of thin schubert cells, and in the proof that the limits are smooth. More information on how to use this in the proofs is given in the coments at the end of the file. 







For the proof that the Chow quotient of Gr(3,7) is the log canonical compactification of X_0(3,7), we use sage (works with sage 9.0):

gRaysConesS00.sage contains: rays37, lineality37, coneReps, Matroids37_orbits.
rays37 is a list of all the rays and lineality37 is a basis of the lineality space of TGr_0(3,7) with the Groebner fan structure. This was computed in gfan. coneReps is a dictionary: keys are the dimensions (mod lineality) of the nonzero cones, and the value at a dimension is a list of all the cones of TGr_0(3,7) of that dimension. Again, this was also computed in gfan.

Matroids37_orbits is a list of 0/1 vectors recording all the rank 3 matroids on [7]. the positions record the triple (i,j,k) in revLex, 0 indicates a nonbasis, 1 indicates a basis. This is from the database: http://www-imai.is.s.u-tokyo.ac.jp/~ymatsu/matroid/

Gr37MSD0.sage contains the list MSDs. This is a list of all the matroid subdivisions of nonzero cones as in coneReps above. These have the same order as coneReps, namely, it is ordered from lowest dimension cone to highest, and within each dimension i (mod lineality), the order is the same as in coneReps[i].

grobToSecondaryFunctions.sage contains all of the functions and data that is obtained quickly. This is needed to run computeSecondaryFromGrobFan.sage.

computeSecondaryFromGrobFan.sage will compute the dictionary secondaryRepsDim. The keys of this dictionary are the S7-reps of cones in the secondary fan structure of Gr_0(3,7) and the value of a cone is the Groebner cones that are contained in this cone. 

secondaryConesDim{i}.sage ({i} = 1,2,3,4,5,6) are files that contain the i-dimensional cones of the secondary fan.

testConesDim2345.sage: for each cone in the secondary fan of dimension 2,3,4, or 5, this  will test that Star(cone), as a fan in N_R/span(cone), contains no lines through the origin. Say maxCone1 and maxCone2 are maximal cones in Star(cone). We want to show that maxCone1 intersects (-1)maxCone2 at 0 in N_R/span(cone). To do this, we put the rays of "cone" in the lineality spaces of maxCone1 and maxCone2, intersect maxCone1 and (-1)maxCone2, and show that this intersection has dimension that of cone.

To test that Star(cone), as a fan in N_R/span(cone), contains no lines through the origin when cone is a ray, we do one ray at a time. There are 5 rays up to S7 symmetry. for rays = 46, 149, 378, 631, run:

testConesDim1Rays{j}.sage for {j} = 46, 149, 378, 631.

For ray 19, there are  run testConeDim1Rays19.sage, {14823 choose 2} = 109853253 pairs of maximal cones to check. pairsSlices splits up the pairs into 11 pieces of about the same size. It is best to run this on 11 different machines, changing the parameter "k" ranging from 0 to 11. 
