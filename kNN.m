function [phi]=kNN(wtest,ValP,k,n)

%Calculer la distance entre les composantes principales,
%ranger par odre croissant, prendre les k plus proche

%deuxième formule: classe la plus représenter

nu=zeros(:,:,n);

for i=1:n
    nu(:,:,i)=abs(wtest,w())
    
end

