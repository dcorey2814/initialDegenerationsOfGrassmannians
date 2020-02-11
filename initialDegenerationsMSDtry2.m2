needsPackage "Polyhedra"
needsPackage "Matroids"
needsPackage "Graphs"

load "functions.m2"
load "symmetryGr3n.m2"


d3n6 = subsets(6,3);
n6 = allMatroids 6;
simpled3n6 = for i in (0..#n6-1) list (if isSimple(n6#i) and rank(n6#i) == 3 then n6#i else continue);


d3n7 = subsets(7,3);
n7 = allMatroids 7;
simpled3n7 = for i in (0..#n7-1) list (if isSimple(n7#i) and rank(n7#i) == 3 then n7#i else continue);





-- -- Instructions on how to use this program to verify claims in the paper (initial degenerations iso to limits, and in the proof that limits are smooth). 
-- -- note: requires polymake and gfan. This works with polymake v3.2 and gfan v0.5.
-- -- 

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- -- Verification of Proposition 3.4 for simple (3,[6]) matroids: i.e. rank 3 on {0,1,2,3,4,5}. 
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


-- -- simpled3n6 contains all of the simple (3,[6])-matroids, there are 9 of these.
-- -- for notation in the pseudocode, we let Si denote the ith matroid in this list. 
-- -- syms36 contains generators for the Aut(Si) (as a subgroup of permutations of [#Bases(Si)])
-- -- signs36 contains the signs of the action of the permutation on a basis of Si
-- -- These are used in the computation of TGr_Si using gfan_tropicaltraverse.

-- -- to compute the tropicalization of Gr_Si 
-- -- run tropicalize(TSC(simpled3n6#i), sym36#i, signs36#i)

-- -- we set 

-- TGr36S = hashTable for i in (0..8) list {i, tropicalize(TSC(simpled3n6#i), syms36#i, signs36#i)}

-- -- To generate all matroid subdivisions, run:

-- MSD36S = new MutableHashTable
-- for i in (0..4)|(6..8) do (
--     MSD36S#i = new MutableHashTable;
--     for j in (0..#(TGr36S#i#"relativeInteriorVectors") - 1 ) do (
-- 	wj := TGr36S#i#"relativeInteriorVectors"#j;
--     	MSD36S#i#wj = matroidSubdivision(simpled3n6#i, wj);
-- 	)
--     )

-- -- this makes a hashTable, a key is a relative interior point of a cone of TGr_S,  
-- -- and its value is the corresponding matroid subdivision of Delta_S.


-- I36 = hashTable for i in (0..8) list {i, TSC(simpled3n6#i)};  -- this is a list of the ideals of the Gr_S

-- -- to compute the ideal of in_w Gr_Si, run:
-- -- inw(w, I36#i)



-- -- Note that this saturates the initial ideal with respect to the product of the variables pijk
-- -- we do this because we think of this as an ideal of k[pijk^{pm} | ijk basis of Si].
-- -- To compute the limit of thin Schubert cells over the subdivision Delta_{Si,w}, run


-- -- limitTSC(ring I36#i, matroidSubdivision(simpled3n6#i, w))

-- -- Note that this saturates the initial ideal with respect to the product of the variables pijk
-- -- we do this because we think of this as an ideal of k[pijk^{pm}].


-- -- for a given w, to show that in_w Gr_Si == limit_{Delta__{Si,w}} Gr_Si , run
-- -- inw(w, I36#i) == limitTSC(ring I36#i, matroidSubdivision(simpled3n6#i, w)) 
-- -- or since the matroid subdivivisions were already computed, run
-- -- inw(w, I36#i) == limitTSC(ring I36#i, MSD36S#i#w) 


-- -- to check in_w Gr_Si == limit_{Delta_Si,w} Gr_S', for all simple (3,[6])-matroids Si  and all 
-- -- w in TGr_Si  one could run:

-- all((0..4)|(6..8), i-> all(TGr36S#i#"relativeInteriorVectors", w-> inw(w, I36#i) == limitTSC(ring I36#i, MSD36S#i#w)))



------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- -- Verification of Proposition 3.4 for simple (3,[7]) matroids: i.e. rank 3 on {0,1,2,3,4,5,6}. 
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


-- -- simpled3n7 contains all of the simple (3,[7])-matroids, there are 23 of these.
-- -- for notation in the pseudocode, we let Si denote the ith matroid in this list. 
-- -- syms37 contains generators for the Aut(Si) (as a subgroup of permutations of [#Bases(Si)])
-- -- signs37 contains the signs of the action of the permutation on a basis of Si
-- -- These are used in the computation of TGr_Si using gfan_tropicaltraverse.

-- -- to compute the tropicalization of Gr_Si one could run
-- -- tropicalize(TSC(simpled3n7#i), sym37#i, signs37#i)
-- -- This uses gfan_tropicalstartingcone, which seems to work when i is not 0,1,3. 
-- -- It still takes a long time. So I precomputed these fans and determined a point in the relative
-- -- interior of a maximal cone, these are listed in wGiven.

-- -- For i=0,1,3, The vectors that we provide are 0/-1 vectors with a -1 in the coordinate pijk
-- -- whenever ijk is a nonbasis of the nonFano matroid. For the uniform matroid S0, this was the 
-- -- vector used in "How to Draw Tropical Planes" by Hermann, Jensen, Joswig, Sturmfels in computing 
-- -- TGr_0(3,7) (note that we order our pluecker coordinates in revlex, whereas they use lex). 
-- -- we check that these are in the relative interior of a maximal cone below.


-- --  To check that these are maximal cones
-- -- one must show that the Groebner cone is the same dimension of Gr_Si. 
-- -- This is done with the function "checkMaximal" below. 


-- wGiven = hashTable {
--     0=> {-1,0,0,0,0,0,0,-1,0,0,0,0,0,0,-1,0,0,0,-1,0,0,0,0,0,0,-1,0,-1,0,0,0,0,0,0,0},
--     1=> {0,0,0,0,0,0,-1,0,0,0,0,0,0,-1,0,0,0,-1,0,0,0,0,0,0,-1,0,-1,0,0,0,0,0,0,0},
--     2=> {136, 73, 73, 136, 73, 73, -66, -276, -129, -11, -74, -74, 102, -108, 39, 102, -108, 39, -36, -99, -99, -133, 147, 84, -133, 147, 84, -55, -70, 0, -63, 113, 113},
--     3=> {0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,-1,0,0,0,0,0,0,-1,0,-1,0,0,0,0,0,0,0},
--     4=> {711, -129, 735, 159, -681, 183, 504, -336, 567, -273, 591, -72, -888, -48, -624, 360, -480, -279, -321, -1161, -297, 840, -1776, 864, 288, -528, 312, 633, 696, 720, -759, 489},
--     5=> {24, 24, -27, 16, 16, -35, 19, 19, 17, 17, -34, -9, -20, -20, -17, 12, 12, -14, -7, -7, -58, -33, 36, 36, -41, 28, 28, -38, 29, 29, 3, -5},
--     6=> {39, 50, -30, -30, -19, -99, 50, 61, 50, 61, -19, -30, -99, -99, 61, 72, -19, 5, 16, -64, 5, 5, 16, -64, 16, 27, 16, 16, 16, 27, -64, 27},
--     7=> {507, 147, 257, -357, -717, -607, 530, 170, 633, 273, 383, -270, -520, -1134, 656, 296, -247, -63, -423, -313, 714, -856, 464, -150, -40, 737, 840, -730, 590, -1633, 863},
--     8=> {22, 15, -7, -25, -32, -54, 28, 21, 17, 10, -12, 12, -17, -35, 23, 16, 18, 34, 27, 5, -11, -33, -58, 40, 33, -5, 24, -38, -5, -43, 30},
--     9=> {3, 3, -6, -7, -7, -16, 3, 3, 8, 8, -1, 3, -6, -7, 8, 8, 3, 8, 8, -1, 3, -6, -7, 8, 8, 3, -16, -1, -1, -6},
--     10=> {10, 10, 3, 10, 10, 3, -7, -7, 7, 7, 0, -3, -10, -3, -10, -20, -27, -27, -34, 3, 16, 16, 3, 16, 16, -14, 0, 13, 13, 3, 3},
--     11=> {5, 1, 1, -1, -5, -5, 5, 1, -1, -5, -5, 5, 1, -1, -1, 5, 8, 4, 4, -6, -6, -12, 8, 4, -6, 8, -12, 4, -6, 8},
--     14=> {194, 144, -81, -81, 144, 94, 104, 54, -171, -171, 54, 4, 178, -497, -97, 128, 104, 54, -171, -171, 54, 4, -497, 178, 128, -97, 88, 88, 38, 38, 162},
--     15=> {4, 4, -2, 2, 2, 2, 4, 4, -2, 2, 2, 2, -10, -4, -4, -6, -2, -2, -8, -4, -4, -4, -1, 5, 5, 3, -1, 5, 5, 3},
--     16=> {7158, 78, 4968, -4347, 8508, 1428, 3972, -3108, 1782, -7533, 5322, -1758, 705, -6375, -10800, 2001, -5079, -189, -9504, 3351, -3729, 9774, -33126, 7584, 11124, 6588, -4452, 4398, 7938, 3321},
--     17=> {365508, 467748, -660087, -660087, 467748, 569988, 231957, 334197, -793638, -793638, 334197, 436437, 207675, 309915, -817920, 231957, 334197, -793638, -793638, 334197, 436437, 207675, -817920, 309915, 74124, 74124, 176364, 176364, 49842},
--     18=> {13, 13, -15, -25, 18, 18, 13, 13, -15, -25, 18, 18, -2, -2, -40, 2, 2, -26, -36, 7, 7, 15, -13, 20, 15, -13, 20, 0},
--     19=> {2, 2, -3, -1, 3, 3, 2, 2, -3, -1, 3, 3, -3, -3, -6, -1, -1, -6, -4, 0, 0, 3, 3, 0, 3, 3, 0},
--     20=> {35, 35, -65, 15, -15, -15, -75, 35, 35, 15, 35, 35, -65, 15, -15, -15, -75, 35, 35, 15, -20, 20, 20, 0, -20},
--     21=> {8, 8, -26, -4, 4, 4, -12, 10, 10, -2, 8, 8, -26, -4, 4, 4, -12, 10, 10, -2, 8, 8, -4, -12},
--     22=> {8, 8, -17, 3, -2, -2, -2, 3, 3, -2, -17, 8, 8, 3, -2}
--         }


-- checkMaximal = (i,w) -> (
--     GrSi = TSC(simpled3n7#i);
--     gc := groebnerConeData(ring GrSi,(GrSi)_*,  w);
--     return dim GrSi == gc#"dim"
--     )

-- all((0..11)|(14..22), i-> checkMaximal(i,wGiven#i))


-- -- note that i=12 and 13 are missing. i=13 is the Fano matroid, which is nonrealizable / QQ.
-- -- For i=12, TGr_S12 is a linear space, this can be checked by running
--  tropicalize(TSC(simpled3n7#12), sym37#12, signs37#12)
-- -- and observing that there are no rays. Since there are no rays, there is nothing to check here
-- -- so we omit it in the future computations.

-- -- Then one can compute the tropicalization by running
-- -- tropicalizeWithVector(TSC(simpled3n7#i), wGiven#i, syms37#i, signs37#i)

  
TGr36S = hashTable for i in (0..11)|(14..22)  list {i, tropicalizeWithVector(TSC(simpled3n7#i), wGiven#i, syms37#i, signs37#i)}


-- -- To generate all matroid subdivisions, run:

-- MSD37S = new MutableHashTable
-- for i in (0..11)|(14..22) do (
--     MSD37S#i = new MutableHashTable;
--     for j in (0..#(TGr37S#i#"relativeInteriorVectors") - 1 ) do (
-- 	wj := TGr37S#i#"relativeInteriorVectors"#j;
--     	MSD37S#i#wj = matroidSubdivision(simpled3n7#i, wj);
-- 	)
--     )

-- -- this makes a hashTable, a key is a relative interior point of a cone of TGr_S,  
-- -- and its value is the corresponding matroid subdivision of Delta_S.


-- I37 = hashTable for i in (0..12)|(14..22) list {i, TSC(simpled3n7#i)};  -- this is a list of the ideals of the Gr_S


-- -- to compute the ideal of in_w Gr_Si, run:
-- -- inw(w, I37#i)



-- -- Note that this saturates the initial ideal with respect to the product of the variables pijk
-- -- we do this because we think of this as an ideal of k[pijk^{pm} | ijk basis of Si].
-- -- To compute the limit of thin Schubert cells over the subdivision Delta_{Si,w}, run


-- -- limitTSC(ring I37#i, matroidSubdivision(simpled3n7#i, w))

-- -- Note that this saturates the initial ideal with respect to the product of the variables pijk
-- -- we do this because we think of this as an ideal of k[pijk^{pm}].


-- -- for a given w, to show that in_w Gr_Si == limit_{Delta_{Si,w}} Gr_S' , run
-- -- inw(w, I37#i) == limitTSC(ring I37#i, matroidSubdivision(simpled3n7#i, w)) 
-- -- or since the matroid subdivivisions were already computed, run
-- -- inw(w, I37#i) == limitTSC(ring I37#i, MSD37S#i#w) 


-- -- to check in_w Gr_Si == limit_{Delta_{Si,w}} Gr_S', for all simple (3,[7])-matroids Si  and all 
-- -- w in TGr_Si  one could run:

-- all((0..11)|(14..22), i-> all(TGr37S#i#"relativeInteriorVectors", w-> inw(w, I37#i) == limitTSC(ring I37#i, MSD37S#i#w)))



------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- -- Verification of Lemma 5.10  for simple (3,[6]) matroids: i.e. rank 3 on {0,1,2,3,4,5}. 
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


-- -- As before, Si denotes the i-th matroid in simpled3n6 (there are 9 of these, but the 5th one 
-- -- has a tropicalization that is a linear space; there is nothing to check for this case).

-- -- To compute the dual graph of a subdivision MSD36S#i#w for i in (0..4)|(6..8) and w a relative interior point
-- -- of a cone of TGr_Si, run graph(adjacencyMatrixSubDivision(MSD36S#i#w)). To see if this graph has no leaves
-- -- apply the function noLeaves to this graph.

-- -- now say that the subdivision MSD36S#i#w has no leaves. to find a basis common to all of the matroids in
-- -- MSD36S#i#w, run commonBasis(MSD36S#i#w). Finally, to compute the data of the limit of these thin Schubert cells
-- -- in affine coordinates, run affineLimitTSC(simpled3n6#i, MSD36S#i#w, commonBasis(MSD36S#i#w), QQ). For more information, see
-- -- the documentation of that function in functions.m2. 


-- -- To  find all subdivisions of Delta_{Si,w} that have no leaves and compute their limits in affine coordinates, run:



-- noLeavesAffineLimit36S = flatten for i in (0..4)|(6..8) list (
--     for j in (0..#TGr36S#i#"relativeInteriorVectors"-1) list (
-- 	w := TGr36S#i#"relativeInteriorVectors"#j;
--         if noLeaves(graph(adjacencyMatrixSubDivision(MSD36S#i#w))) then (
-- 	    affineLimitTSC(simpled3n6#i, MSD36S#i#w, commonBasis(MSD36S#i#w), QQ)
-- 	    ) else continue
-- 	)
--     )

-- -- to get all of the ideals that appear without repetitions, run

-- RGr36 = QQ[(0..2)/ ( i-> (0..2)/(j-> x_(i,j)) )]
-- uniqueIdeals36S = unique for i in (0..#noLeavesAffineLimit36S-1) list sub(noLeavesAffineLimit36S#i#"ideal",RGr36)


------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
-- -- Verification of Lemma 5.10  for simple (3,[7]) matroids: i.e. rank 3 on {0,1,2,3,4,5,6}. 
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


-- -- As before, Si denotes the i-th matroid in simpled3n7 (there are 23 of these, but the 12th one 
-- -- has a tropicalization that is a linear space and the 13th one is the fano matroid
-- --  there is nothing to check for these cases).
-- -- we follow a similar strategy as for the (3,[6]) case. 


-- noLeavesAffineLimit37S = flatten for i in (0..11)|(14..22) list (
--     for j in (0..#TGr37S#i#"relativeInteriorVectors"-1) list (
-- 	wj := TGr37S#i#"relativeInteriorVectors"#j;
--         if noLeaves(graph(adjacencyMatrixSubDivision(MSD37S#i#wj))) then (
-- 	    affineLimitTSC(simpled3n7#i, MSD37S#i#wj, commonBasis(MSD37S#i#wj), QQ)
-- 	    ) else continue
-- 	)
--     )

-- RGr37 = QQ[(0..2)/ ( i-> (0..3)/(j-> x_(i,j)) )]
-- uniqueIdeals37S = unique for i in (0..#noLeavesAffineLimit37S-1) list sub(noLeavesAffineLimit37S#i#"ideal",RGr37)










