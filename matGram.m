function [VecP,ValP] = matGram(X)

mtG = X' * X;

[VecP,D] = eig(mtG);

[h,n]=size(X);

%calcul des valeurs propres

ValP = zeros(1,n);

for i = 1:n
        ValP(i) = D(i,i);
end

[ValP, order] = sort(ValP, 'descend');
VecP = VecP(:, order);