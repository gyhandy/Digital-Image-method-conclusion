function [bx,by,cx,cy,di] = fun_getNextPoint(img_bi,lx,ly,kx,ky)
    dx=[0,-1,-1,-1, 0, 1,1,1,   0,-1,-1,-1, 0, 1,1,1];
    dy=[1, 1, 0,-1,-1,-1,0,1,   1, 1, 0,-1,-1,-1,0,1];
    
    bx = lx; by=ly; cx=kx; cy=ky; di=0;
    [rows,cols] = size(img_bi);
    
    for i=1:8
        if bx+dx(i)==cx && by+dy(i)==cy 
            for j=i+1:i+8
                tx=bx+dx(j); ty=by+dy(j);
                if tx>=1 && tx<=rows && ty>=1 && ty<=cols                    
                    if img_bi(tx,ty)==1 
                        bx=tx; by=ty;
                        di = j; 
                        if di>8 
                            di=di-8; 
                        end
                        break;                       
                    end              
                end
                cx=tx; cy=ty;
            end            
            break;
        end
    end  
end

