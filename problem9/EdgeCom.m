%% Prewitt, Sobel  convelution
function grad=EdgeCom(f,A,B)
    %f: input image，A,B分别为计算x，y偏导数的卷积模板（3*3）
    [m,n]=size(f);
    gx=zeros(m+2,n+2);
    gy=zeros(m+2,n+2);
    for i=-1:1
        for j=-1:1
            gx((2-i):(m+1-i),(2-j):(n+1-j))=gx((2-i):(m+1-i),(2-j):(n+1-j))+A(2+i,2+j)*f;
            gy((2-i):(m+1-i),(2-j):(n+1-j))=gy((2-i):(m+1-i),(2-j):(n+1-j))+B(2+i,2+j)*f;
        end
    end
    grad=sqrt(gx(2:m+1,2:n+1).^2+gy(2:m+1,2:n+1).^2);
end
