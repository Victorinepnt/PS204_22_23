function [omega]=calcomega(images,U,l)

[h,w] = size(images);
omega = zeros(l,w);
X_mean = mean(images,2);
for i=1:w
    x_xbarre = images(:,i) - X_mean;
    omega(:,i) = x_xbarre'*U(:,1:l);
end
