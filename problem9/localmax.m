function result=localmax(M,Theta)
% perform the nonmaximal supression. M is the input gradient magnitude
% image, Theta is the edge direction image.
    [x,y]=size(M);
    result=M;
    for i=3:x-2
        for j=3:y-2
           m=0;
           % if the gradient magnitude is smaller than that of the adjacent
           % pixels along the quantized direction, set the magnitude to 0
           switch Theta(i,j)/45
               case {0,4,8}
                   m=max([M(i,j),M(i,j+1),M(i,j-1)]);
               case {1,5}
                   m=max([M(i,j),M(i-1,j+1),M(i+1,j-1)]);    
               case {2,6}
                   m=max([M(i,j),M(i-1,j),M(i+1,j)]); 
               case {3,7}
                   m=max([M(i,j),M(i-1,j-1),M(i+1,j+1)]);     
           end  
           if(result(i,j)<m)
               result(i,j)=0;
           end
        end
    end
end

