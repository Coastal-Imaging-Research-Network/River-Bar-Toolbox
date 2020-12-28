function[T]=DrawBar(Imm,filename)

%%%% DrawBar lets the user draw the contour of the bar and provides the geometric characteristics of the bar in T.
%%%% Imm = RGB image;
%%%% filename = name of the input image.

figure (5)
imshow(Imm);
disp('Draw the contour of the bar');
disp('Double-click on any vertex of the polygon to display the result');
bar=roipoly; 
subplot(1,2,1);imshow(Imm);
subplot(1,2,2);imshow(labeloverlay(Imm,bar));
pp=input('Do you want to save the data?: 1=yes, 0=no       ');
switch pp
    case 1
BWoutline = bwperim(bar);                         % List of pixels included in the perimeter
P=regionprops(BWoutline,'PixelList');                 
S=regionprops(bar,'Area','Centroid','PixelList'); % Area, centre of mass and list of pixels inlcuded in the area 
T.Name= string(filename);
T.Type= "Visible Bar";
T.Area= S.Area; 
T.Centroid= S.Centroid; 
T.Perimeter= P.PixelList; 
T.PixelList= S.PixelList;

    case 0
 T.Name= string(filename);    
 T.Type= "Dark Image";            
 T.Area= NaN; 
 T.Centroid= NaN; 
 T.Perimeter= NaN; 
 T.PixelList= NaN;
        
              
end                  