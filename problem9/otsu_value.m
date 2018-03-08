%%
function a=otsu_value(f)
    [m,n]=size(f);
    hist=zeros(1,256);
    var=zeros(1,256);
    for i=1:m         %统计各灰度级像素数
        for j=1:n
            temp=f(i,j)+1;
            hist(temp)=hist(temp)+1;
        end
    end
    p=hist/(m*n);     %第i级出现的概率
    u=0;
    for k=1:256
        u=u+(k-1)*p(k);   %图像平均灰度级
    end
    for k=1:256
        w0(k)=sum(p(1:k-1));
        w1(k)=1-w0(k);
        u0(k)=0;
        for i=1:k-1
            u0(k)=u0(k)+(i-1)*p(i);
        end
        u1(k)=1-u0(k);
    end
    var=w1.*w0.*((u0-u1).^2);
    a=1;
    for i=1:256
        if var(i)>var(a)
            a=i;
        end
    end
    a=a-1;
end
