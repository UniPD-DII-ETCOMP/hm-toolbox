function A = hm2hss(B)
%HM2HSS Conversion between data-sparse formats.
%
% A = HM2HSS(B) constructs an HSS representation of the HM matrix B. 

m = size(B, 1);
n = size(B, 2);

[rowcluster, colcluster] = cluster(B);
A = hss('zeros', m, n, 'cluster', rowcluster, colcluster);

if isempty(B.A11)
    A.D = full(B);
else
    UU = [ B.U12 , zeros(size(B.U12,1), size(B.U21,2)) ; ...
        zeros(size(B.U21, 1), size(B.U12, 2)) , B.U21 ];
    VV = [ zeros(size(B.V21, 1), size(B.V12, 2)) , B.V21 ; ...
        B.V12 , zeros(size(B.V12,1), size(B.V21,2))];
    
    A = blkdiag(hm2hss(B.A11), hm2hss(B.A22)) + ...
        hss('low-rank', UU, VV, 'cluster', rowcluster, colcluster);
end

end

