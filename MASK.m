%%% MASK lets the user create a mask for the images.

filename=uigetfile('Images/*.png');
file=fullfile('Images',filename);
I=imread(file);
disp('Draw the mask: draw a polygon around the area you want to investigate');
disp('Double-click on any vertex of the polygon to save the mask');
disp('The area outside the polygon will be covered by the mask');
mask=roipoly(I);
Imm=rgb2gray(I);
Imm_1=I.*uint8(mask);
imshow(Imm_1)
save('mask','mask');


