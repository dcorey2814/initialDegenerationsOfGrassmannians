needsPackage "Polyhedra"
needsPackage "Matroids"
needsPackage "Graphs"




stepwiseSaturate = (I,g) -> (
    for i from 0 to #g-1 do (
        I=saturate(I,sub(g#i, ring I), Strategy=>Bayer);
	);
    return I
    )
-- I is an ideal of a polynomial ring.
-- g is a list of homogeneous elements of ring I.
-- returns the saturation of I with respect to the elements in g.


stepwiseSaturateNoBayer = (I,g) -> (
    for i from 0 to #g-1 do (
        I=saturate(I,sub(g#i, ring I));
        );
    return I
    )
-- I is an ideal of a polynomial ring.
-- g is a list of homogeneous elements of ring I.
-- returns the saturation of I with respect to the elements in g.



inw=(w,I)->(
    R := ring I;
    Rw := newRing(R, Weights=>w, Global => false);
    inwI := sub(ideal(leadTerm(1, sub(I,Rw))),R);
    return stepwiseSaturate(inwI, gens R)
    )
--w is the vector in TGr_M, in the min convention, revLex ordered.
--I is the ideal of the thin Schubert cell.



-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-- The following functions use Pluecker coordinates to: create the ideals of thin schubert cells and limits of thin Schubert cells
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------



GrGfan = (d,n) -> (
    nCd := subsets(n,d);
    Gr := Grassmannian(d-1,n-1,CoefficientRing=>QQ);
    RGrGfan := QQ[apply(nCd, l->value("p"|l#0|l#1|l#2))];
    gfanConversion := map(RGrGfan,ring Gr, matrix{for l from 0 to #nCd-1 list (gens RGrGfan)#l});
    gfanConversion(Gr)    
    )
-- input: positive integers d,n d<n ! only works for d=3 right now.
-- output: the polynomial ring QQ[pijk] where 0<=i<j<k<=n-1


TSC = S -> (
    d := rank(S);
    n := #(S.groundSet);
    Gr := GrGfan(d,n);
    output := Gr; 
    if #nonbases(S) != 0 then (
	pBases := (bases(S) / (l-> sort toList l)) / (l -> sub(value("p"|l#0|l#1|l#2), ring Gr));
	pNonBases := (nonbases(S) / (l -> sort toList l)) / (l -> sub(value("p"|l#0|l#1|l#2), ring Gr));
    	GrM := eliminate(Gr + ideal(pNonBases), pNonBases);
    	output = sub(stepwiseSaturate(GrM,pBases), QQ[pBases]); 
	);
    return output
    )
-- Input: a matroid S
-- output: the ideal of the thin Schubert cell. Note that we saturate with respect to the 
-- pijk where ijk is a basis of S



TSCpreSaturate = S -> (
    d := rank(S);
    n := #(S.groundSet);
    Gr := GrGfan(d,n);
    output := Gr; 
    if #nonbases(S) != 0 then (
	pBases := (bases(S) / (l-> sort toList l)) / (l -> sub(value("p"|l#0|l#1|l#2), ring Gr));
	pNonBases := (nonbases(S) / (l -> sort toList l)) / (l -> sub(value("p"|l#0|l#1|l#2), ring Gr));
   	output = eliminate(Gr + ideal(pNonBases), pNonBases);
	);
    return output
    )
-- Input: a matroid S
-- output: the ideal of the thin Schubert cell. Note that we do not saturate with respect to the 
-- pijk where ijk is a basis of S



limitTSC = (ringS, SD) -> (
    idealsPreSat := SD / (Si -> TSCpreSaturate(Si));
    idealsPreSat = idealsPreSat / (I -> sub(I,ringS));
    idealPreSat := sum idealsPreSat;
    return stepwiseSaturate(idealPreSat, gens ringS)
    )
-- input: ringS - the polynomial ring where Gr_S lives and SD - a list of matroids representing a 
-- subdivision of Delta_S
-- output: the ideal of ringS generated by the ideals of the thin Schubert cells from the matroids in SD
-- this is the limit of the thin Schubert cells over the subdivision.




-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- The following functions use gfan to compute the tropicalizations of thin Schubert cells. These functions 
-- use gfan0.5 for all tropical computations
-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------


makeInitialFormsInFile = (R,M,w) -> (  
    foutName := temporaryFileName () | ".txt";
    fout := openOut(foutName);
    fout << substring(toString(R), 1, #(toString(R)) -1) << endl;
    fout << toString(M) << endl; 
    if #w > 1 then (
	fout << toString(toSequence(w)) << endl; 
	) else (
	fout << "("|toString(w#0)|")";
	);
    close fout;
    return foutName
    )
-- Input: R a ring, M a list of elements of R, w a list of length (gens R).
-- Output: makes temporary file to compute the initial ideal generated by M wrt w using gfan_initialforms. Uses max convention. Returns the name of the file.


makeTropicalStartingConeFile = (R,M) -> (
    foutName := temporaryFileName () | ".txt";
    fout := openOut(foutName); 
    fout << substring(toString(R), 1, #(toString(R)) -1) << endl;
    fout << toString(M) << endl; 
    close fout;
    return foutName
    )
-- Input: R a ring, M a list of elements of R generating  a prime ideal.
-- Output: makes temporary file to compute starting cone using gfan_tropicalstartingcone. Returns name of file. 

    
makeTropicalTraverseFile = (startFile, sym, signs) -> (
    fout := openOutAppend(startFile); 
    fout << toString(sym) << endl;
    fout << toString(signs) << endl;
    close fout;
    return startFile
    )
-- Input: startFile a file to use for gfan_tropicaltraverse, sym a list of symmetries of ideal, signs a list of signs of the symmetries, see gfan documentation. 
-- Output: makes temporary file to compute tropicalization using gfan_tropicaltraverse. Returns name of file. 


makeGroebnerConeFile = (R,M,w) -> (
    inFormsFile := makeInitialFormsInFile(R,M,w); 
    outInFormsFile :=  temporaryFileName () | ".txt";
    grobConeFile := temporaryFileName () | ".txt"; 
    run ("gfan_initialforms --ideal --pair < "|inFormsFile|" > "|outInFormsFile);
    run ("gfan_groebnercone --pair --asfan < "|outInFormsFile|" > "|grobConeFile);
    return grobConeFile
    )



gfanRay = (r,lr) -> (
    tr := separate(" ", r);
    for i in (0..lr-1) list value(tr#i)
    )
-- Input: r a string coming from gfan_tropicaltraverse output representing a RAY, lr an integer representing the ambient dimension of r. 
-- Output: a list of integers representing the ray r.


gfanRaysToM2 = (rs, lr) -> for i from 0 to #rs-1 list gfanRay(rs#i, lr)
-- Input: rs a list of strings r as in gfanRay, lr an integer representing the ambient dimension of each r.
-- Output: a list of lists of integers, representing the rays of the tropicalization. 

gfanLinealityToM2 = (ls, d) -> (
    tls := for i from 0 to #ls-1 list separate(" ", ls#i);
    for i from 0 to #ls-1 list( for j from 0 to d-1 list value(tls#i#j)  )
    )


gfanConeLineToList = l -> (
    Cstr := (separate("#", l))#0;
    rightBracket := position(characters Cstr, i->i== "}");
    CstrNoBrackets := substring(Cstr, 1, rightBracket-1);
    if #CstrNoBrackets == 0 then return {} else return apply(separate(" ", CstrNoBrackets), i->value(i))
    )

parseTropFile = f -> (
     lf := lines get f;
     T := new MutableHashTable;
     ambDimLoc := position(lf, i-> i == "AMBIENT_DIM"); 
     dimLoc := position(lf, i-> i == "DIM"); 
     nRaysLoc := position(lf, i-> i == "N_RAYS"); 
     linDimLoc := position(lf, i-> i == "LINEALITY_DIM");
     
     T#"ambDim" = value(lf#(ambDimLoc+1));
     T#"dim" = value(lf#(dimLoc+1)); 
     T#"linealityDim" = value(lf#(linDimLoc+1)); 
     T#"nRays" = value(lf#(nRaysLoc+1));
    
     if T#"nRays"==0 then T#"rays" = {} else (
	 
         raysLoc := position(lf, i-> i== "RAYS");
 	 conesLoc := position(lf, i-> i=="CONES_ORBITS"); 
     	 maxConesLoc := position(lf, i-> i=="MAXIMAL_CONES_ORBITS");
    	 multLoc := position(lf, i-> i == "MULTIPLICITIES_ORBITS");
	 conesLines := for i in (conesLoc+1..maxConesLoc-2) list lf#i;
         maxConesLines := for i in (maxConesLoc+1..multLoc-2) list lf#i;
	 
         T#"rays" = gfanRaysToM2(for i from raysLoc+1 to raysLoc+T#"nRays" list lf#i, T#"ambDim");
	 T#"conesOrbits" = for i in (0..#conesLines-1) list gfanConeLineToList(conesLines#i);
         T#"relativeInteriorVectors" = for i in (1..#(T#"conesOrbits")-1) list sum(for j in T#"conesOrbits"#i list T#"rays"#j);    
	 T#"maximalConesOrbits" = for i in (0..#maxConesLines-1) list gfanConeLineToList(maxConesLines#i);
	 );
     
     if T#"linealityDim" == 0 then T#"lineality" = {} else (
	 linLoc := position(lf, i-> i=="LINEALITY_SPACE"); 
	 T#"lineality" = gfanLinealityToM2(for i from linLoc+1 to linLoc+T#"linealityDim" list lf#i, T#"ambDim");
	 ); 
     
     return T
    )

-- Input: file f, the output of gfan_tropicaltraverse
-- Output: a MutableHashTable T:
--    T#"ambDim" = integer, the ambient dimension of the tropicalization
--    T#"dim" = integer, the dimension of the tropicalization
--    T#"linealityDim" = integer, dimension of the lineality space
--    T#"nRays" = integer, number of rays
--    T#"rays" = list of lists of integers, the rays of the tropicalization
--    T#"conesOrbits" = list of lists of integers,  the cones of the tropicalization (as lists of indices of rays)
--    T#"relativeInteriorVectors" = list of lists of integers, the sum of all rays of a given cone, this is a vector in the relative interior of the cone. 
--    T#"lineality" = list of lists of integers, span of these vectors form the lineality space. 
 


parseGroebnerConeFile = f -> (
     lf := lines get f;
     GC := new MutableHashTable;
     
     ambDimLoc := position(lf, i-> i == "AMBIENT_DIM");
     dimLoc := position(lf, i-> i == "DIM");
     nRaysLoc := position(lf, i-> i== "N_RAYS");
     linDimLoc := position(lf, i-> i=="LINEALITY_DIM");
     
     GC#"ambDim" = value(lf#(ambDimLoc+1));
     GC#"dim" = value(lf#(dimLoc+1));
     GC#"linealityDim" = value(lf#(linDimLoc+1));
     GC#"nRays" = value(lf#(nRaysLoc+1));
    
     
     if GC#"nRays"==0 then GC#"rays" = {} else (
	 raysLoc := position(lf, i-> i== "RAYS");
         GC#"rays" = gfanRaysToM2(for i from raysLoc+1 to raysLoc+GC#"nRays" list lf#i, GC#"ambDim");
         );
     if GC#"linealityDim" == 0 then GC#"lineality" = {} else (
	 linLoc := position(lf, i-> i=="LINEALITY_SPACE"); 
	 GC#"lineality" = gfanLinealityToM2(for i from linLoc+1 to linLoc+GC#"linealityDim" list lf#i, GC#"ambDim");
	 ); 
     
     return GC
    )


groebnerCone = (R, M, w) -> (
    f:=makeGroebnerConeFile(R,M,w); 
    d:=parseGroebnerConeFile(f);
    outp := false;
    if (d#"nRays" != 0 and d#"linealityDim" != 0) then (
	outp = coneFromVData(transpose matrix d#"rays", transpose matrix d#"lineality");
	) else if (d#"nRays" != 0 and d#"linealityDim" == 0 ) then (
	outp = coneFromVData(transpose matrix d#"rays");
	) else if (d#"nRays" == 0 and d#"linealityDim" != 0 ) then (
	z := for i from 0 to d#"ambDim"-1 list 0; 
	outp = coneFromVData(transpose matrix {z}, transpose matrix d#"lineality");
	) else outp = false;
    return outp
    )



groebnerConeData = (R, M, w) -> (
    f:=makeGroebnerConeFile(R,M,w); 
    return parseGroebnerConeFile(f)
    )


tropicalize = (GrS, sym, signs) -> (
    inFileName := makeTropicalStartingConeFile(ring GrS, GrS_*); 
    outFileName := temporaryFileName () | ".txt"; 
    tropFileName :=  temporaryFileName () | ".txt"; 
    run ("gfan_tropicalstartingcone < "|inFileName|" > "|outFileName);
    makeTropicalTraverseFile(outFileName, sym, signs);
    run ("gfan_tropicaltraverse --symmetry --symsigns --nocones < "|outFileName|" > "|tropFileName);
    T := parseTropFile(tropFileName);
    return T
    )
-- Input: GrS an ideal of a thin schubert cell (should be prime), sym list of sequences, signs list of sequences. These are for --symmetry and --symsigns for gfan_tropicaltraverse.
-- Output: a MutableHashTable from parseTropFile

tropicalizeWithVector = (GrS, w, sym, signs) -> (
    inFileName := makeInitialFormsInFile(ring GrS, GrS_*, w);
    outFileName := temporaryFileName () | ".txt";
    tropFileName :=  temporaryFileName () | ".txt";
    run ("gfan_initialforms --ideal --pair < "|inFileName|" > "|outFileName);
    makeTropicalTraverseFile(outFileName, sym, signs);
    run ("gfan_tropicaltraverse --symmetry --symsigns --nocones< "|outFileName|" > "|tropFileName);
    T := parseTropFile(tropFileName);
    return T
    )
-- Input: GrS an ideal of a thin schubert cell (should be prime), w a list of integers (should be in the relative interior of a maximal cone), sym list of sequences, signs list of sequences. These are for --symmetry and --symsigns for gfan_tropicaltraverse.
-- Output: a MutableHashTable from parseTropFile



makeTropicalTraverseFileNoSym = startFile -> (
    fout := openOutAppend(startFile); 
    close fout;
    return startFile
    )
-- Input: startFile a file to use for gfan_tropicaltraverse, sym a list of symmetries of ideal, signs a list of signs of the symmetries, see gfan documentation. 
-- Output: makes temporary file to compute tropicalization using gfan_tropicaltraverse. Returns name of file. 








-------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- The following functions compute matroid subdivisions of matroid polytopes 
-- by interfacing with polymake 3.2. 
-------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------


basisToPolymakeVector = (b,n) -> (
    str := toString({1}|for i in (0..n-1) list (if any(toList b, x-> x ==  i) then 1 else 0));
    return ("["|substring(str, 1, #str-2)|"]")
    )
    
makePolyFile = (S,w) -> (
    B := bases(S);
    n := #(S.groundSet);
    polyFileName := temporaryFileName () | ".poly";
    f := openOut(polyFileName);
    f << "use application 'polytope';" << endl; 
    f << ("my $w = -new Vector<Rational>(["|substring(toString(w), 1, #(toString(w))-2) |"]);") << endl; 
    f << ("my $p = new Polytope(POINTS => ["|demark(", ", for i in (0..#B-1) list basisToPolymakeVector(B#i,n))|"]);") << endl;
    f << "my $msd = regular_subdivision($p->VERTICES, $w);" << endl; 
    f << "print $msd;";
    close f;
    return polyFileName
    )

matroidSubdivision =  (S,w) -> (
    d := rank(S);
    n := #(S.groundSet);
    f := makePolyFile(S,w);    
    o := temporaryFileName () | ".txt";
    run ("polymake --script "|f|">"|o);
    msdStrs := lines get o;	
    msdIndices := for i in (0..#msdStrs-1) list ( apply(separate(" ", substring(msdStrs#i, 1, #(msdStrs#i)-2)), x->value(x)));
    basesS :=  bases(S) / ( x-> sort toList x); 
    msdBases := for i in (0..#msdIndices-1) list (for j in msdIndices#i list basesS#j);
    return for i in (0..#msdBases-1) list matroid(toList S.groundSet, msdBases#i)
    )







-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-- The following functions are used to determine dual graphs to subdivisions and which ones have no leaves
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------

intersectionSets = l -> (
    x := l#0; 
    (0..#l-1) / (i -> x = x * l#i);
    return x
    )
-- Input: l - a list of sets.
-- Output: the intersection of these sets.


commonBasis = SD -> (
    bs := toList intersectionSets(for j in (0..#SD-1) list set bases(SD#j));
    if #bs==0 then return {} else return bs#0
    )
-- Input: SD a list of matroids (should represent the maximal cells of a matroid subidivision of a matroid polytope)
-- Output: a basis common to all matroids in SD, or {} if there is no such basis.


shareEdge = (n, S1, S2) -> (
    bS12 := toList (set bases(S1) * set bases(S2));
    if #bS12 == 0 then return false else (
	S12 := matroid(toList((0..n-1)), bS12);   
	if #(components(S12)) == #(components(S1)) + 1 then return true else return false
        );
    )
-- Input: integer n, matroids S1 and S2 (should represent maximal cells of a matroid subdivision).
-- Output: true if the polytopes of S1 and S2 share a facet, false otherwise.


adjacencyMatrixSubDivision = SD -> (
    n := #((SD#0).groundSet);
    A := matrix( SD/(Si -> SD / (Sj -> if shareEdge(n,Si,Sj) then 1 else 0)) );
    return A
    )
-- Input: SD a list of matroids (should represent the maximal cells of a matroid subidivision of a matroid polytope)
-- Output: a matrix representing the dual graph to the subdivision SD 

noLeaves = G -> not any(vertexSet(G), v->degree(G,v)==1)
-- Input: a connected graph G
-- Output: true if there are no one-valent vertices, false otherwise.







-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-- the following functions use affine coordinates to compute ideals of thin schubert cells, limits of thin Schubert cells 
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------



affineTSC = (S, B, k) -> (
    oB := sort toList B;
    D := new MutableHashTable;
    d := rank(S);
    n := #(S.groundSet);
    xij := for j in (0..n-4) list (for i in (0..d-1) list x_(i,j) );
    R := k[flatten xij]; 
    I := entries id_(R^d); 
    xij = for j in (0..n-4) list (for i in (0..d-1) list sub(x_(i,j), R) ); 
    scan(toList (0..d-1), c-> xij = insert(oB#c, I#c, xij) ); 
    X := transpose matrix xij; 
    D#"ideal" = ideal(0_R);
    basesXij := bases(S) / (b -> det submatrix(X,, toList b));
    nonBasesXij := {}; 
        
    if #(nonbases(S)) != 0 then (
	variablesNonbases := flatten apply (for i in (0..#(nonbases(S))-1) list ( if #(((nonbases(S))#i) * B) == 2 then (nonbases(S))#i else continue), nb -> support det submatrix(X,, toList nb));
	basesXij = unique(apply(basesXij, f  ->  sub(f, variablesNonbases / (g -> g=>0))));
	nonBasesXij = (nonbases(S))/ (nb -> det submatrix(X,, toList nb));
	nonBasesXij = unique(apply(nonBasesXij, f  ->  sub(f, variablesNonbases/ (g -> g=>0 ))) );
	IMpreS := ideal nonBasesXij;
    	D#"ideal" = stepwiseSaturateNoBayer(IMpreS, basesXij);  
        );
    
    D#"ring" = R;
    D#"matrix" = X;
    D#"basesX" = basesXij;
    D#"nonBasesX" = nonBasesXij;
    return D
    )
-- Input: a matroid S, basis B of S, and field k
-- Output: a MutableHashTable D. Say S is a rank d matroid on n elements.  
--    D#"matrix" is a d-by-n matrix whose columns from B form the d-by-d identity matrix, and remaining entries filled in with x_(i,j).
--    D#"ring" = k[x_(i,j)]
--    D#"nonBasesX" = minors of D#"matrix" corresponding to nonbases of S, after setting x_(i,j) corresponding to nonbases = 0.
--    D#"basesX" = minors of D#"matrix" corresponding to bases of S, after setting x_(i,j) corresponding to nonbases = 0.
--    D#"ideal" = ideal generated by D#"nonBasesX" and saturated wrt D#"basesX"
 



 
affineLimitTSC = (S, SD, B, k) -> (
    D := new MutableHashTable;
    tscS := affineTSC(S,B,k);
    tscSD := SD/(Si ->  affineTSC(Si, B, k));
    ideals  := for i in (0..#SD-1) list sub(tscSD#i#"ideal", tscS#"ring");
    limitIdealPreSat := sum(for i in (0..#SD-1) list sub(tscSD#i#"ideal", tscS#"ring"));
    basesSD := unique apply( flatten for i in (0..#SD-1) list tscSD#i#"basesX", b -> sub(b,tscS#"ring"));
    
    D#"matrix" = tscS#"matrix";
    D#"ring" = tscS#"ring";
    D#"idealPreSat" = limitIdealPreSat;
    D#"ideal" = stepwiseSaturateNoBayer(limitIdealPreSat, basesSD);
    D#"basesX" = basesSD;
    D#"tsc" = tscSD;
    D#"graph" = graph(adjacencyMatrixSubDivision(SD));
    D#"ideals" = ideals;
    return D
    )
-- Input: a matroid S, a list of matroids SD (representing the maximal cells of a subdivision of S), basis B of S common to all matroids in SD, and field k
-- Output: a MutableHashTable D. Say S is a rank d matroid on n elements.  
--    D#"matrix" is a d-by-n matrix whose columns from B form the d-by-d identity matrix, and remaining entries filled in with x_(i,j).
--    D#"ring" = k[x_(i,j)]
--    D#"tsc" is a list of MutableHashTables affineTSC(Si, B ,k) for Si in SD. 
--    D#"basesX" = list of "basesX" from the elements of D#"tsc".
--    D#"idealPreSat" = ideal of D#"ring", this is the sum of the ideals from D#"tsc".
--    D#"ideal" = D#"idealPreSat" saturated with respect to D#"basesX".
--    D#"graph" = dual graph to the subdivision SD.
--    D#"ideals" = list of the ideals D#"tsc" as ideals of D#"ring".



