function [vect]=affimg(dos)

adr = dos;
fld = dir(adr);
nb_elt = length(fld);
% Data matrix containing the training images in its columns 
data_trn = []; 
% Vector containing the class of each training image
lb_trn = []; 
k=1;
figure,
for i=1:nb_elt
    if fld(i).isdir == false
        lb_trn = [lb_trn ; str2num(fld(i).name(6:7))];
        img = double(imread([adr fld(i).name]));
        imgv = img(:) ;
        vect(i,:)=imgv;
        subplot(6,10,k);
        k=k+1;
        imagesc(img) ;
        colormap(gray) ;
        axis off;
        drawnow;
        data_trn = [data_trn img(:)];
        
    end
end

end