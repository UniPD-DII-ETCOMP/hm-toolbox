function [Xu, VA, AA] = ek_lyap(A, u, k, tol, debug)
%EK_LYAP Approximate the solution of a AX + XA' = u * u'
%
% XU = EK_LYAP(A, U, K) approximates the solution of the Lyapunov equation
%     in the factored form XU * XU'. 
%
% [XU, VA] = EK_LYAP(A, U, K, TOL, DEBUG) also returns the basis VA, and
%     the optional parameters TOL and DEBUG control the stopping criterion
%     and the debugging during the iteration. 

if ~exist('debug', 'var')
    debug = false;
end

if ~isstruct(A)
	AA = ek_struct(A, true);
	nrmA = normest(A, 1e-2);
	AA.nrm = nrmA;
else
	AA = A;
	nrmA = AA.nrm;
end

% Start with the initial basis
[VA, KA, HA] = rat_krylov(AA, u, inf);

% Dimension of the space
sa = size(u, 2);

bsa = sa;

Cprojected = ( VA(:,1:size(u,2))' * u ) * ( u' * VA(:,1:size(u,2)) );
	
if ~exist('tol', 'var')
    tol = 1e-8;
end

it = 1;

while sa - 2*bsa < k
    [VA, KA, HA] = rat_krylov(AA, VA, KA, HA, [0 inf]);
    
    sa = size(VA, 2);
    
    % Compute the solution and residual of the projected Lyapunov equation
    As = HA(1:end-bsa,:) / KA(1:end-bsa,:);
    Cs = zeros(size(As, 1), size(As, 2));
    
    % FIXME: The above steps can be carried out much more efficiently, just
    % computing the new columns and rows of As and Bs. 
    
    Cs(1:size(u,2), 1:size(u,2)) = Cprojected;    
    
    [Y, res] = lyap_galerkin(As, Cs, 2*bsa);

    % You might want to enable this for debugging purposes
    if debug
        fprintf('%d Residue: %e\n', it, res / norm(Y));
    end

    if res < norm(Y) * tol
        break
    end        
it = it + 1;   
end

[QQ, DD] = eig(Y);
ii = find(diag(DD) > max(diag(DD)) * tol / nrmA);

Xu = VA(:,1:size(QQ,1)) * QQ(:,ii) * sqrt(DD(ii,ii));

end