%%% Bar_detection is a semi-automatic code to detect emerged deposits on images of rivers. 
%%% If you want to use a mask on your images in order to cover everything except from the area you want to investigate, use the code MASK.  
%%% This is an important passage if there are some regions in the image with a color similar to the one of the deposit. By applying a mask, you prevent the code to detect them.

clear 
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUT PARAMETERS

D=dir('Images\*.png'); % set the input directory and the image format
start= 1;              % index of the first image you want to analyze in D (if you want to start with the first image in D, start=1)
outDir=('Results\');   % set the output directory

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
mask=load('mask.mat');        
catch
mask.mask=ones(451,251);
end


path=D(start).folder;
for z=start:size(D,1)
        filename=D(z).name;
        file=fullfile(path,'\',filename);
        Imm=im2double(imread(file)); 
        Ic=rgb2gray(Imm); 
        figure (1);  imshow(Imm); title(filename); pause (3)
        
        
        bb=input('Is the bar visible?: 1=yes, 0=no, 2=breaking, 3=dark image       ');  
        %%%%%% Is the bar visible? %%%%%%%
        switch bb
            
        case 0
              T.Name= string(filename);
              T.Type= "No bar";        
              T.Area= NaN; 
              T.Centroid= NaN; 
              T.Perimeter= NaN; 
              T.PixelList= NaN;
              save([outDir,filename(1:7) '.mat'],'T');
              T   
              disp('Next image');
        continue; % go to the next image
               
        case 2 
              T.Name= string(filename);    
              T.Type= "Visible Breaking"; 
              T.Area= NaN; 
              T.Centroid= NaN; 
              T.Perimeter= NaN; 
              T.PixelList= NaN;  
              save([outDir,filename(1:7) '.mat'],'T');
              T
              disp('Next image');
        continue; % go to the next image
                             
        case 3
              T.Name= string(filename);    
              T.Type= "Dark Image";            
              T.Area= NaN; 
              T.Centroid= NaN; 
              T.Perimeter= NaN; 
              T.PixelList= NaN;
              save([outDir,filename(1:7) '.mat'],'T');
              T
              disp('Next image');
        continue; % go to the next image
                            
        case 1                                 % start the detection of the bar
                  
              %%% apply mask and draw roi %%%
              m=mask.mask;
                for i=1:size(Ic,1)
                for j=1:size(Ic,2)
                    I(i,j)=Ic(i,j)*m(i,j);
                end
                end
              disp('Draw your Region Of Interest');
              disp('Double-click on any vertex of the polygon to save it and go on with the analysis');
              roi=roipoly;
                      
              %%% search the bar %%%
              [BWfin]= CreateBW(I,roi);
        
              %%% check BWfin: is it totally black? %%%
              B=any(BWfin);
        
              if B==0                                   % If the image is totally black, try the CLAHE contrast enhancement             
              [BWfin]=CreateBWCLAHE(Ic,roi,m);
        
              %%% second check BWfin: still totally black? %%%
              Bbis=any(BWfin);
        
              if Bbis==0                                % If the image is still totally black, draw the image manually
              [T]=DrawBar(Imm,filename);
              save([outDir,filename(1:7) '.mat'],'T');
              close Figure 5
              T
              disp('Next image');
              continue; 
              elseif isvector(Bbis)                     % If the image is not totally black, the code detects the bar
              [Segout,BWoutline]= FindBar(BWfin,Ic);
              figure (2)
              subplot(1,3,1);imshow(Ic);               
              subplot(1,3,2);imshow(labeloverlay(Ic,BWfin)); 
              subplot(1,3,3);imshow(Segout);
            
              %%% check the result %%%    
              aa=input('Is the result ok?: 1=yes, 0=no       ');  
              close Figure 2
              
              switch aa
              case 1
                    [T]= prop(BWfin,BWoutline,filename);
                    save([outDir,filename(1:7) '.mat'],'T');
                    T
                    disp('Next image');
              continue;
            
              case 0
                
                    [T]= DrawBar(Imm,filename);
                    save([outDir,filename(1:7) '.mat'],'T');
                    close Figure 5
                    T
                    disp('Next image');
              continue;
              end
              end
              elseif isvector(B)                        % If the image is not totally black, the code detects the bar
              [Segout,BWoutline]= FindBar(BWfin,Ic);
              figure (3)
              subplot(1,3,1);imshow(Ic);               
              subplot(1,3,2);imshow(labeloverlay(Ic,BWfin)); 
              subplot(1,3,3);imshow(Segout); 
            
              %%% check the result %%%    
              cc=input('Is the result ok?: 1=yes, 0=no       ');     
              close Figure 3
              
              switch cc
              case 1
                 
                    [T]= prop(BWfin,BWoutline,filename);
                    save([outDir,filename(1:7) '.mat'],'T');
                    T
                    disp('Next image');
              continue;  
             
              case 0                                    % try CLAHE contrast enhancement
             
                    [BWfin]= CreateBWCLAHE(Ic,roi,m); 
             
              %%% check BWfin: is the image totally black? %%%    
              Btris=any(BWfin);
              if Btris==0                               % If the image is totally black, draw the bar manually
              [T]=DrawBar(Imm,filename);
              save([outDir,filename(1:7) '.mat'],'T');
              close Figure 5
              T
              disp('Next image');
              continue;
              elseif isvector(Btris)                    % If the image is not totally black, the code detects the bar
              [Segout,BWoutline]=FindBar(BWfin,Ic);
              figure (4)
              subplot(1,3,1);imshow(Ic);               
              subplot(1,3,2);imshow(labeloverlay(Ic,BWfin)); 
              subplot(1,3,3);imshow(Segout); 
            
              %%% check the result %%%    
              dd=input('Is the result ok?: 1=yes, 0=no       ');  
              close Figure 4
              
              switch dd
              case 1
                
                    [T]= prop(BWfin,BWoutline,filename);
                    save([outDir,filename(1:7) '.mat'],'T');
                    T
                    disp('Next image');
              continue;
            
              case 0
                
                    [T]= DrawBar(Imm,filename);
                    save([outDir,filename(1:7) '.mat'],'T');
                    close Figure 5
                    T
                    disp('Next image');
              continue;
            
              end
              end
              end
              end 
        end
        
close Figure 1   
end
           