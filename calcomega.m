function [omega]=calcomega(x_xbarre,U,l)

[h,w] = size(x_xbarre);
omega = zeros(1,w);

for i=1:w
    ret = 1;
    omega(:,i) = x_xbarre(:,i)'*U(:,1:l);
end
