function[T]= prop(BWfin,BWoutline,filename)

%%%% prop provides the geometric characteristics of the bar in T, starting from BWfin, BWoutline and filename.
%%%% BWfin = binary image of the bar;
%%%% BWoutline = binary image of the perimeter of the bar;
%%%% filename = name of the input image.

P=regionprops(BWoutline,'PixelList');               % Perimeter = List of pixels included in the perimeter
S=regionprops(BWfin,'Area','Centroid','PixelList'); % Area, centre of mass, list of pixels included in the area
for i=1:length(S)
    Avec(i)=S(i).Area;
end
[maxA,maxIdx]=max(Avec);
T.Name= string(filename);
T.Type= "Visible Bar";
T.Area= S(maxIdx).Area; 
T.Centroid= S(maxIdx).Centroid; 
T.Perimeter= P(maxIdx).PixelList; 
T.PixelList= S(maxIdx).PixelList;
             

                  