function [U,VecP,ValP, Xbarre] = calcU(data_train,size_trn,Nc)

[h,n] = size(data_train);

Xbarre = zeros(h,1);

for i=1:n
    Xbarre = Xbarre + data_train(:,i);
end

Xbarre = 1/n*Xbarre;

X = zeros(h,n);

for j=1:n
    X(:,j) = data_train(:,j) - Xbarre;
    m = 1;
    
end

X = 1/sqrt(n)*X;

Xt = transpose(X);

[VecP,ValP] = eig(Xt*X);

VecP = VecP(:,2:n);



U = X*VecP*(transpose(VecP)*Xt*X*VecP)^(-1/2);
U = [U zeros(h,1)];

% Display the U 
F = zeros(192*Nc,168*max(size_trn));
figure,
title("Affichage des n eigenfaces");
m = 1;
for i=1:Nc
    for j=1:size_trn(i)
          pos = sum(size_trn(1:i-1))+j;
          F(192*(i-1)+1:192*i,168*(j-1)+1:168*j) = reshape(U(:,pos),[192,168]);
          subplot(6,10,m)
          imagesc(real(F(192*(i-1)+1:192*i,168*(j-1)+1:168*j)));
          colormap(gray);
          axis off;
          m = m+1;
    end
end


% figure(1);
% imagesc(real(F));
% colormap(gray);
% title("Affichage des eigenfaces");
% axis off;