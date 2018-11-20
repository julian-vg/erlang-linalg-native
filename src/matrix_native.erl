-module(matrix_native). 
-vsn('1.0').
-author('simon.klassen').
-export([transpose/1,multiply/2]). 

transpose([[]]) -> [[]];
transpose([[] | XXs]) -> transpose(XXs);
transpose([[X | Xs] | XXs]) -> [[X | [H || [H | _Tail ] <- XXs]] | transpose([Xs | [Tail || [_|Tail] <- XXs]])].

sumprod([],[],_) ->[];
sumprod([A],[B],Sum) ->Sum+A*B;
sumprod([A|VecA],[B|VecB],Sum) ->sumprod(VecA,VecB,Sum+A*B).
sumprod(VecA,VecB) ->sumprod(VecA,VecB,0).

rowmult(_, 0, _, L, _, _) -> L;
rowmult(I, C, R, L, M1, M2) -> 
	SumProd = sumprod(lists:nth(R,M1),lists:nth(C,M2)),
	rowmult(I, C-1, R, [SumProd|L], M1, M2).

multiply(_, _, 0, MM, _, _) -> MM;
multiply(I, C, R, MM, M1, M2) ->
	NewRow = rowmult(I, C, R, [], M1, M2),
	multiply(I, C, R-1, [NewRow|MM], M1, M2).

multiply(M1, M2) -> 
	Inner = length(M2),
	NCols = length(lists:nth(1,M2)), 
	NRows = length(M1), 
	multiply(Inner, NCols, NRows,[], M1, transpose(M2)).

