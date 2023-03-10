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
%l que l'on choisi pour le facespace
%On doit prendre les U dans l'autre sens pour 
%que notre prennent en compte les images les plus 
%??nerg??tique
l=10;
%index de la photo sur laquelle on veut travailler
index = 3;
images = zeros(h,6);

for i=1:6
    images(:,i) = data_trn(:,index+10*(i-1));
end


for i=1:6
    images(:,i) = data_trn(:,index+10*(i-1));
    imagescentrees = images - Xbarre;
end

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
title("Images reconstruites apr??s ACP");

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
title("Images de r??f??rences");

%Question 4
    %Calcul du ratio de l'??nergie de projection

Kl = zeros(1,n);
lindex = [1:n];
lstar = 0;

for P=1:n
    sumhaut = 0;
    sumbas = 0;
    for i=1:lindex(1,P)
        sumhaut = sumhaut + ValP(n-i+1,n-i+1);
    end

    for i=1:n
        sumbas = sumbas + ValP(i,i);
    end

    Kl(1,P) = sumhaut/sumbas;
    
    if(Kl(1,P)>0.9 && lstar==0)
        lstar = P;
    end
end

figure(4);
plot(Kl);
title("Evolution du ratio de l'??nergie de projection en fonction de la dimension de l'espace de projection");

%%Classification

k=10;

classe_estim=zeros(1,n);

for i=1:n
    classe_estim(1,i)=kNN(ValP(i,i),ValP,k,n,lb_trn,cls_trn);
end



matconf=confusionmat(lb_trn,classe_estim);

imgsuite = [imagescentrees(:,1) imagescentrees(:,2) imagescentrees(:,3) imagescentrees(:,4) imagescentrees(:,5) imagescentrees(:,6)];

omegas = zeros(l,n);

i=1;
for y=1:6
    z=1
    while z<h
        omegas(:,i) = calcomega(imgsuite(z:z+(192+168),y),U,l);
        z = z+(192+168);
    end
end







