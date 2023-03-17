function [U,VecP,ValP] =calcU1(data_train)

[h,n]=size(data_train);
X_mean = mean(data_train, 2);
X = 1/sqrt(n) * (data_train - repmat(X_mean, [1, n]));

%Calcul des valeurs de gram
[VecP,ValP] = matGram(X);

%calcul de U

U= X*VecP*(VecP'*X'*X*VecP)^(-1/2);