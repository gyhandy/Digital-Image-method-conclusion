%% Canny
function result=Canny(I,T1,T2)
    % perform Canny edge detector. I is the input image, sz indicates the size
    % of gaussian, T1 is the lower threshold and T2 is the upper threshold.

    % smooth the image with a gaussian filter
    h=fspecial('gaussian',5,5/6);
    I=imfilter(I,h,'replicate');
    I=double(I);

    % choose priwitt to compute the gradient magnitude image g(x,y)
    GX=[-1 -1 -1; 0 0 0; 1 1 1]  ;% Gx
    GY=[-1 0 1;-1 0 1; -1 0 1];   % Gy
    I1=imfilter(I,GX,'replicate');
    I2=imfilter(I,GY,'replicate');
    g=sqrt(I1.^2+I2.^2);

    [x,y]=size(I); % get the size of I.
    % compute the edge direction image theta(x,y)
    theta=zeros(x,y);
    for i=1:x
        for j=1:y
            if(I1(i,j)==0 && I2(i,j)==0)     % if both Gx and Gy are equal to 0, set the direction to be 0
                theta(i,j)=0;
            else
                theta(i,j)=atan(I2(i,j)./I1(i,j))*180/3.1415926; % get the direction in degrees.
            end
            % set the direction's range to be [0,360]
           if(I1(i,j)>=0&&I2(i,j)<0)
               theta(i,j)=theta(i,j)+360;
           elseif(I1(i,j)<0&&I2(i,j)>=0)
               theta(i,j)=theta(i,j)+180;
           elseif(I1(i,j)<0&&I2(i,j)<0)
               theta(i,j)=theta(i,j)+180;
           end

        end
    end

    % quantize the angle to the nearest angle:{0,45,90,135,180,225,270,315,360}
    angle=(0:8)*45;
    for i=1:x
        for j=1:y
            for k=1:9
                if(abs(theta(i,j)-angle(k))<=45/2)
                    theta(i,j)=angle(k);
                end
            end
        end
    end

    % call localmax function to perform the nonmaximal supression
    G=localmax(g,theta);
    G=uint8(G);

    G(find(G>T2*max(G(:))))=255; % change the pixels above upper threshold to be edges.
    G(find(G<T1*max(G(:))))=0;  %  change the pixels below lower threshold to be background.

    % deal with the weak edges. if a weak edge pixel is adjacent to a edge  pixel, mark the pixel as an edge pixel.
    % repeat this for 20 times and then set the rest weak edge pixels to be background.
    n=0;
    while(size(find(G>0 & G<255))~=[1 0]) 
      for i=2:x-1
          for j=2:y-1
              if (G(i,j)>0 && G(i,j)<255)
                  if (G(i-1,j-1)==255 || G(i-1,j)==255 || G(i-1,j+1)==255 || ...
                      (G(i,j-1)==255) || (G(i,j+1)==255) ||(G(i+1,j-1)==255) || G(i+1,j)==255 || G(i+1,j+1)==255)
                  G(i,j)=255;
                  end
              end
          end
      end
      n=n+1;
      if(n==20)
          break;
      end
    end
    G(find(G>0 & G<255))=0;
    result=im2bw(G); % change the image, which only has intensity of 0 and 255, to a binary image.
end


