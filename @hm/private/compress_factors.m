function [ U, V ] = compress_factors(Uold, Vold)
%COMPRESS_FACTORS Compress a low-rank representation U*V'. 

if size(Uold, 2) < 16
	U = Uold;
	V = Vold;
else
	[QU,RU] = qr(Uold, 0);
	[QV,RV] = qr(Vold, 0);

	[U,S,V] = svd(RU * RV');
	rk = sum(diag(S) > threshold);
	U = QU * U(:,1:rk) * S(1:rk,1:rk);
	V = QV * V(:,1:rk);
end

end

