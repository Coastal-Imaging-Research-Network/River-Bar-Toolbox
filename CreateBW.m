function[BWfin]=CreateBW(I,roi)

%%%% CreateBW creates the binary image of the bar (BWfin)starting from I and roi.
%%%% I = grayscale image after the application of the mask;
%%%% roi = Region of Interest drawn by the user.

grad = imgradient(I,'sobel');           % compute the gradient of the image
for i=1:size(I,1)
   for j=1:size(I,2)
       Ig(i,j)=grad(i,j)*roi(i,j);      % apply the ROI
   end
end
thre=graythresh(Ig);
Ibw=imbinarize(Ig,thre);                % binarize the image
BWfill = imfill(Ibw,'holes'); 
se1=strel('disk',2); 
BWfin=imopen(BWfill,se1);