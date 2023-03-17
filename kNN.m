function [res]=kNN(wtest,wtrain,k,class,cls_trn)

%Calculer la distance entre les composantes principales,
%ranger par ordre croissant, prendre les k plus proche

%deuxième formule: classe la plus représentée
n=size(wtrain,2);
nu=zeros(1,n-1);

for i=1:n-1
    nu(i)=norm(wtest-wtrain(:,i));
end

nutriee = sort(nu);



phi = nutriee(1:k);

ind = zeros(1,k);

for i=1:k
    ind(i)=find(phi(i)==nu);
end

classe=class(ind);
len=length(cls_trn);
totsum=zeros(2,len);

for i=1:len
    totsum(2,i)=sum(classe==cls_trn(i));
    totsum(1,i)=cls_trn(i);
end

maxi = max(totsum(2,:));

[k,j] = find(totsum(2,:) == maxi,1);

res = totsum(1,j);

    