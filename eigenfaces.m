% P. Vallet (Bordeaux INP), 2019

clc;
clear all;
close all;

%% Data extraction
% Training set
adr = './Database/training1/';
fld = dir(adr);
nb_elt = length(fld);
% Data matrix containing the training images in its columns 
data_trn = []; 
% Vector containing the class of each training image
lb_trn = []; 
for i=1:nb_elt
    if fld(i).isdir == false
        lb_trn = [lb_trn ; str2num(fld(i).name(6:7))];
        img = double(imread([adr fld(i).name]));
        data_trn = [data_trn img(:)];
    end
end
% Size of the training set
[P,N] = size(data_trn);
% Classes contained in the training set
[~,I]=sort(lb_trn);
data_trn = data_trn(:,I);
[cls_trn,bd,~] = unique(lb_trn);
Nc = length(cls_trn); 
% Number of training images in each class
size_cls_trn = [bd(2:Nc)-bd(1:Nc-1);N-bd(Nc)+1]; 
% Display the database
% F = zeros(192*Nc,168*max(size_cls_trn));
% for i=1:Nc
%     for j=1:size_cls_trn(i)
%           pos = sum(size_cls_trn(1:i-1))+j;
%           F(192*(i-1)+1:192*i,168*(j-1)+1:168*j) = reshape(data_trn(:,pos),[192,168]);
%     end
% end
% figure;
% imagesc(F);
% colormap(gray);
% axis off;

%Calcul de U, matrice des vecteurs propres de R chapeau
[h,n] = size(data_trn);

Xbarre = zeros(h,1);

for i=1:n
    Xbarre = Xbarre + data_trn(:,i);
end

Xbarre = 1/n*Xbarre;

X = zeros(h,n);

for j=1:n
    X(:,j) = data_trn(:,j) - Xbarre;
    k = 1;
    
end

X = 1/sqrt(n)*X;

Xt = transpose(X);

[VecP,ValP] = eig(Xt*X);



U = X*VecP*(transpose(VecP)*Xt*X*VecP)^(-1/2);

% Display the U 
F = zeros(192*Nc,168*max(size_cls_trn));
for i=1:Nc
    for j=1:size_cls_trn(i)
          pos = sum(size_cls_trn(1:i-1))+j;
          F(192*(i-1)+1:192*i,168*(j-1)+1:168*j) = reshape(U(:,pos),[192,168]);
    end
end

figure;
imagesc(F);
colormap(gray);
axis off;
