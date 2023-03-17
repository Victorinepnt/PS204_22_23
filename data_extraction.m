function [lb,data_bis,size_cls_trn,Nc, cls_trn] = data_extraction(adr)

fld = dir(adr);
nb_elt = length(fld);
% Data matrix containing the training images in its columns 
data = []; 
% Vector containing the class of each training image
lb = []; 
for i=1:nb_elt
    if fld(i).isdir == false
        lb = [lb ; str2num(fld(i).name(6:7))];
        img = double(imread([adr fld(i).name]));
        data = [data img(:)];
    end
end

% Size of the training set
[P,N] = size(data);

% Classes contained in the training set
[~,I]=sort(lb);
data_bis = data(:,I);
[cls_trn,bd,~] = unique(lb);
Nc = length(cls_trn); 

% Number of training images in each class
size_cls_trn = [bd(2:Nc)-bd(1:Nc-1);N-bd(Nc)+1];