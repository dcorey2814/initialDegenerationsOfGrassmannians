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

-- -- to compute the tropicalization of Gr_Si 
-- -- run tropicalize(TSC(simpled3n7#i), sym37#i, signs37#i)

-- -- we set 

-- TGr37S = hashTable for i in (0..12)|(14..22) list {i, tropicalize(TSC(simpled3n7#i), syms37#i, signs37#i)}

-- TGr37S = applyValues(set((0..11)|(14..22)), i->tropicalize(TSC(simpled3n7#i), syms37#i, signs37#i))

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


-- I37 = hashTable for i in (0..11)|(14..22) list {i, TSC(simpled3n7#i)};  -- this is a list of the ideals of the Gr_S


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










