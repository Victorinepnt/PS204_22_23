% P. Vallet (Bordeaux INP), 2019

clc;
clear all;
close all;

%% Data extraction
% Training set
adrtr = './database/training1/';
adrte = './database/test3/';

%Extraction des données
[lb_trn,data_train,size_trn,Nc_trn,cls_trn] = data_extraction(adrtr);
[lb_te,data_test,size_te,Nc_te,cls_te] = data_extraction(adrte);

%Calcul de U
[U,VecP,ValP] = calcU1(data_train);

%Calcul de omega
W_train = calcomega(data_train, U, l);
W_test = calcomega(data_test,U,l);

%Classification