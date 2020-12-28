function[Segout,BWoutline]=FindBar(BWfin,Ic)

%%%% FindBar provides the binary image of the perimeter of the bar (BWoutline) and the grayscale image with the perimeter superimposed (Segout), starting from Ic and BWfin.
%%%% Ic = grayscale image;
%%%% BWfin = binary image of the bar. 

BWoutline = bwperim(BWfin); 
Segout = Ic; 
Segout(BWoutline) = 255; 


