% P. Vallet (Bordeaux INP), 2019

clc;
clear all;
close all;

%% Data extraction
% Training set
adr = './database/training1/';
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
    m = 1;
    
end

X = 1/sqrt(n)*X;

Xt = transpose(X);

[VecP,ValP] = eig(Xt*X);

VecP = VecP(:,2:n);



U = X*VecP*(transpose(VecP)*Xt*X*VecP)^(-1/2);
U = [U zeros(h,1)];

% Display the U 
F = zeros(192*Nc,168*max(size_cls_trn));
figure,
title("Affichage des n eigenfaces");
m = 1;
for i=1:Nc
    for j=1:size_cls_trn(i)
          pos = sum(size_cls_trn(1:i-1))+j;
          F(192*(i-1)+1:192*i,168*(j-1)+1:168*j) = reshape(U(:,pos),[192,168]);
          subplot(6,10,m)
          imagesc(real(F(192*(i-1)+1:192*i,168*(j-1)+1:168*j)));
          colormap(gray);
          axis off;
          m = m+1;
    end
end


figure(1);
imagesc(real(F));
colormap(gray);
title("Affichage des eigenfaces");
axis off;

%Question 3
    %On récupère des images à traiter
l=10;
index = 2;
images = zeros(h,6);

for i=1:6
    images(:,i) = data_trn(:,index+10*(i-1));
end

imagescentrees = images - Xbarre;

piS = zeros(h,6);
    %Calcul de piS
for j=1:6
    for m=n-l:n
        piS(:,j) = piS(:,j) +  (U(:,m)'*imagescentrees(:,j))*U(:,m);
    end
end

piS = piS + Xbarre;

    %Affichage
F2 = zeros(192*Nc,168*Nc);
figure(2),
m = 1;
for i=1:Nc
      pos = i;
      F2(192*(i-1)+1:192*i,1:168) = reshape(piS(:,pos),[192,168]);
      subplot(2,3,m)
      imagesc(real(F2(192*(i-1)+1:192*i,1:168)));
      colormap(gray);
      axis off;
      m = m+1;
end
title("Images reconstruites après ACP");

F3 = zeros(192*Nc,168*Nc);
figure(3),
m = 1;
for i=1:Nc
      pos = i;
      F3(192*(i-1)+1:192*i,1:168) = reshape(images(:,pos),[192,168]);
      subplot(2,3,m)
      imagesc(real(F3(192*(i-1)+1:192*i,1:168)));
      colormap(gray);
      axis off;
      m = m+1;
end
title("Images de références");

% inter = abs(piS).^2;
% 
% sumhaut = zeros(h,1);
% 
% for p=1:6
%     sumhaut = sumhaut + inter(:,p);
% end
% 
% sumbas = zeros(h,1);
% 
% for q=1:6
%     sumbas = sumbas + abs(imagescentrees(:,q)).^2;
% end
% 
% Kl = sumhaut/sumbas;

    %Calcul du ratio de l'énergie de projection
sumhaut = 0;

for i=1:l
    sumhaut = sumhaut + ValP(i,i);
end

sumbas = 0;

for i=1:n
    sumbas = sumbas + ValP(i,i);
end

Kl = sumhaut/sumbas;

