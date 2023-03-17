% P. Vallet (Bordeaux INP), 2019

clc;
clear all;
close all;

%% Data extraction
% Training set
adrtr = './database/training1/';
adrte = './database/test3/';
l=10;

%Extraction des données
[lb_trn,data_train,size_trn,Nc_trn,cls_trn] = data_extraction(adrtr);
[lb_te,data_test,size_te,Nc_te,cls_te] = data_extraction(adrte);

%Calcul de U
[U,VecP,ValP] = calcU1(data_train);

%Calcul de omega
W_train = calcomega(data_train, U, l);
W_test = calcomega(data_test,U,l);

%Classification

mu = zeros(1,Nc_trn);

for j=1:Nc_trn
    mu(1,j) = 1/cls_trn(1,j)*sum(W_test(:,;
end


sigma = 0;

for j=1:Nc_trn
    for i=1:Nc_trn %C'est pas ça mais j'écris la structure
        sigma = sigma + (W_test(:,i) - mu(1,j))*(W_test(:,i) - mu(1,j))';
    end
end

sigma = sigma/n;

res = sigma^(-1/2).*(W_test-mu);

[max_val, max_ind]=min(res);

phi =x(max_ind);
