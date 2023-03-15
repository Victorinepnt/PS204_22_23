% P. Vallet (Bordeaux INP), 2019

clc;
clear all;
close all;

%% Data extraction
% Training set
adrtr = './database/training1/';
adrte = './database/test1/';

[lb_trn,data_train,size_trn,Nc_trn,cls_trn] = data_extraction(adrtr);
[lb_te,data_test,size_te,Nc_te,cls_te] = data_extraction(adrte);


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

[U,VecP,ValP, Xbarre]=calcU(data_train,size_trn,Nc_trn);
[h,n] = size(data_train);
%Question 3
%l que l'on choisi pour le facespace
%On doit prendre les U dans l'autre sens pour 
%que notre prennent en compte les images les plus 
%énergétique
l=10;
%index de la photo sur laquelle on veut travailler
index = 3;
images = zeros(h,6);

for i=1:6
    images(:,i) = data_train(:,index+10*(i-1));
end


for i=1:6
    images(:,i) = data_train(:,index+10*(i-1));
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
F2 = zeros(192*Nc_trn,168*Nc_trn);
figure(2),
m = 1;
for i=1:Nc_trn
      pos = i;
      F2(192*(i-1)+1:192*i,1:168) = reshape(piS(:,pos),[192,168]);
      subplot(2,3,m)
      imagesc(real(F2(192*(i-1)+1:192*i,1:168)));
      colormap(gray);
      axis off;
      m = m+1;
end
title("Images reconstruites après ACP");

F3 = zeros(192*Nc_trn,168*Nc_trn);

figure(3),
m = 1;
for i=1:Nc_trn
      pos = i;
      F3(192*(i-1)+1:192*i,1:168) = reshape(images(:,pos),[192,168]);
      subplot(2,3,m)
      imagesc(real(F3(192*(i-1)+1:192*i,1:168)));
      colormap(gray);
      axis off;
      m = m+1;
end
title("Images de références");

%Question 4
    %Calcul du ratio de l'énergie de projection

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
title("Evolution du ratio de l'énergie de projection en fonction de la dimension de l'espace de projection");

W_train = center_project_firsts(data_train, U, l);
%W_train = calcomega(imagescentrees, U, l);
W_test = center_project_firsts(data_test,U,l);
%%Classification

k=10;

classe_estim=zeros(1,n);

for i=1:n
    classe_estim(1,i)=kNN(ValP(i,i),ValP,k,n,lb_trn,cls_trn);
end



matconf=confusionmat(lb_trn,classe_estim);

imgsuite = [imagescentrees(:,1) imagescentrees(:,2) imagescentrees(:,3) imagescentrees(:,4) imagescentrees(:,5) imagescentrees(:,6)];













