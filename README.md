# initialDegenerationsOfGrassmannians

This repository contains the code used in "Initial degenerations of Grassmannians." Here is a summary of the files. 

The directories tropGr36 and tropGr37 contain the gfan outputs for the tropicalizations of thin Schubert cells of simple (3,6) and (3,7) matroids, respectively. 

directory msdTropGr37 contains the matroid subdivision data. In each file, the subdivisions are separated by an extra line. Each subdivision starts with the relative interior vector w, and the remaining lines are the matroids. Each matroid is a list of numbers 0,...,34, representing a basis. The numbers indicate the position of the basis in the list of triples of [35], in the revLex order.


For the proof of Proposition 3.9, that the dimensions of limits of thin Schubert cells over Delta_{M,w} equals the dimension of Gr_M, when (d,n)=(3,6), (3,7), and Lemma 6.4, that these limits are smooth and irreducible when the adjacency graph has no leaves:

initialDegenerationsMSD.m2 contains the Macaulay2 (v1.15) code used to prove Proposition 3.9 and Lemma 6.4.  More information on how to use this in the proofs is given in the coments of that file.  Note that this requires gfan (works with v0.5) and polymake (works with v3.2).

functionsM2.m2 contains all of the M2 functions used in initialDegenerationsMSD.m2.

For the proof that the Chow quotient of Gr(3,7) is the log canonical compactification of X_0(3,7), we use sage (works with sage 9.0):

The directory secondaryFanTropGr37 contains S_7 orbit representatives of the cones of the secondary fan structure of TGr_0(3,7).

gRaysConesS00.sage contains: rays37, lineality37, coneReps, Matroids37_orbits.
rays37 is a list of all the rays and lineality37 is a basis of the lineality space of TGr_0(3,7) with the Groebner fan structure. This was computed in gfan. coneReps is a dictionary: keys are the dimensions (mod lineality) of the nonzero cones, and the value at a dimension is a list of all the cones of TGr_0(3,7) of that dimension. Again, this was also computed in gfan. Matroids37_orbits is a list of 0/1 vectors recording all the rank 3 matroids on [7]. the positions record the triple (i,j,k) in revLex, 0 indicates a nonbasis, 1 indicates a basis. This is from the database: http://www-imai.is.s.u-tokyo.ac.jp/~ymatsu/matroid/

Gr37MSD0.sage contains the list MSDs. This is a list of all the matroid subdivisions of nonzero cones as in coneReps above. These have the same order as coneReps, namely, it is ordered from lowest dimension cone to highest, and within each dimension i (mod lineality), the order is the same as in coneReps[i].

functionsSage.sage contains all of the functions and data that is obtained quickly. This is needed to run computeSecondaryFromGrobFan.sage.

computeSecondaryFromGrobFan.sage will compute the dictionary secondaryRepsDim. The keys of this dictionary are the S7-reps of cones in the secondary fan structure of Gr_0(3,7) and the value of a cone is the Groebner cones that are contained in this cone. 

testLocalFans.sage contains the code used in the proof of Lemma 7.3.

