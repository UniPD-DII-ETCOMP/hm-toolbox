
 
%hodlroption('block-size',100);
%hodlroption('compression','svd');
%hodlroption('threshold',1e-6);

% Rhodlr=hodlr(R2); 
% Lhodlr=hodlr('handle',fun_handlejwL,N.cotree,N.cotree);

load prob2.mat

disp('sum')
tic
SYSh=Rhodlr+Lhodlr;
toc
