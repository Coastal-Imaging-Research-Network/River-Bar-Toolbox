function[BWfin]=CreateBWCLAHE(Ic,roi,m)

%%%% CreateBWCLAHE creates the binary image of the bar (BWfin)using CLAHE, starting from Ic, roi and m.
%%%% Ic = grayscale image;
%%%% roi = Region of Interest drawn by the user;
%%%% m = mask. (If the user does not provide a mask, the code uses a dummy one).

Icmod=adapthisteq(Ic);                   % compute CLAHE 
for i=1:size(Ic,1)
  for j=1:size(Ic,2)
      I(i,j)=Icmod(i,j)*m(i,j);          % apply the mask
  end
end
grad = imgradient(I,'sobel');            % compute the gradient of the image
for i=1:size(Ic,1)
  for j=1:size(Ic,2)
      Ig(i,j)=grad(i,j)*roi(i,j);        % apply the ROI
  end
end
thre=graythresh(Ig);
Ibw=imbinarize(Ig,thre);                 % binarize the image
BWfill = imfill(Ibw,'holes'); 
se1=strel('disk',2); 
BWfin=imopen(BWfill,se1);
