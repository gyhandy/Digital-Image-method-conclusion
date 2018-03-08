%% Roberts
function grad=EdgeCom2(f,A,B)
    %f:input image，A,B分别为计算x，y偏导数的卷积模板
    [m,n]=size(f);
    gx=zeros(m+1,n+1);
    gy=zeros(m+1,n+1);
    for i=0:1
        for j=0:1
            gx((2-i):(m+1-i),(2-j):(n+1-j))=gx((2-i):(m+1-i),(2-j):(n+1-j))+A(1+i,1+j)*f;
            gy((2-i):(m+1-i),(2-j):(n+1-j))=gy((2-i):(m+1-i),(2-j):(n+1-j))+B(1+i,1+j)*f;
        end
    end
    grad=sqrt(gx(2:m+1,2:n+1).^2+gy(2:m+1,2:n+1).^2);
end
