function [Z, W] = CSP_fn(C1, C2)

R1 = (C1*C1')/trace(C1*C1');	
R2 = (C2*C2')/trace(C2*C2');
R = R1 + R2;
[Uo, seta, UoT] = svd(R);

P = (power(diag(seta),-0.5)).*Uo;

[B1, Lamb1, B1T] = svd(P * R1 * P');
[B2, Lamb2, B2T] = svd(P * R2 * P');
S1 = P * R1 * P';
S2 = P * R2 * P';
[B Bt] = chol(S1+S2);

W = B' * P;
%W = B1' * P;
%W = sort(W);
[W_temp idx] = sort(diag(W), 'descend');
W = W(idx,:);

Z1 = W *C1;
Z2 = W *C2;
Z = [Z1; Z2];
end

