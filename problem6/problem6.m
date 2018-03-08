clc
clear all
format compact

f=imread('origin\ray_trace_bottle.tif');
[m,n]=size(f);
A=rotate(pi*1/2);
for k=1:m
    for h=1:n
        xx=k-(1+m)/2;
        yy=h-(1+n)/2;
        oricoor=A*[xx;yy;1];
        g11(k,h)=nearest(f,oricoor(1)+(1+m)/2,oricoor(2)+(1+n)/2);
        g21(k,h)=bilinear(f,oricoor(1)+(1+m)/2,oricoor(2)+(1+n)/2);
    end
end

A=translate(60,170);
for k=1:m
    for h=1:n
        oricoor=A*[k;h;1]; %求原图像中坐标
        g12(k,h)=nearest(f,oricoor(1),oricoor(2)); %最邻近插值
        g22(k,h)=bilinear(f,oricoor(1),oricoor(2)); %双线性插值
    end
end
s=0.5;
A=scale(s); %s 为放缩规模
for k=1:floor(m*s)
    for h=1:floor(n*s)
        oricoor=A*[k;h;1]; %求原图像中坐标
        g13(k,h)=nearest(f,oricoor(1),oricoor(2)); %最邻近插值
        g23(k,h)=bilinear(f,oricoor(1),oricoor(2)); %双线性插值
    end
end

figure(1);
set(gcf,'Position',get(0,'ScreenSize'),'Name','平移 Tx=170, Ty=50');
subplot(1,1,1),imshow(uint8(g12)),title('平移');
figure(2)
set(gcf,'Position',get(0,'ScreenSize'),'Name','缩放');
subplot(1,2,1),imshow(uint8(g13)),title('放缩Sx=Sy=0.5，近邻');
subplot(1,2,2),imshow(uint8(g23)),title('放缩Sx=Sy=0.5，双线性插值');
figure(3);
set(gcf,'Position',get(0,'ScreenSize'),'Name','旋转');
subplot(1,2,1),imshow(uint8(g11)),title('旋转theta=0.5*pi，近邻');
subplot(1,2,2),imshow(uint8(g21)),title('旋转theta=0.5*pi，双线性插值');

%% 求平移矩阵；offx，offy为移动距离
function A=translate(offx,offy)
    A=[1,0,-offx;0,1,-offy;0,0,1];
end

%% 求放缩矩阵，b为放缩尺度
function A=scale(b)
    b=1/b;
    A=[b,0,0;0,b,0;0,0,1];
end

%% 求旋转变换矩阵，b为顺时针旋转角度
function A=rotate(b)
    A=[cos(b),-sin(b),0;sin(b),cos(b),0;0,0,1];
end

%% 最近插值，ori为原图像
function value=nearest(ori,x,y)
    [m,n]=size(ori);
    if x<1||x>m||y<1||y>n
        value=0;
    else
        value=ori(round(x),round(y));
    end
end
%% 双线性插值
function value=bilinear(ori,x,y)
    [m,n]=size(ori);
    if x<1||x>m||y<1||y>n
        value=0;
    else
        x1=floor(x);    %向下取整
        x2=ceil(x);     %向上取整
        y1=floor(y);
        y2=ceil(y);
        a1=x-x1;
        b1=y-y1;
        value=(1-a1)*(1-b1)*ori(x1,y1)+a1*(1-b1)*ori(x2,y1)...
        +(1-a1)*b1*ori(x1,y2)+a1*b1*ori(x2,y2);
    end
end
