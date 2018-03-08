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
        oricoor=A*[k;h;1]; %��ԭͼ��������
        g12(k,h)=nearest(f,oricoor(1),oricoor(2)); %���ڽ���ֵ
        g22(k,h)=bilinear(f,oricoor(1),oricoor(2)); %˫���Բ�ֵ
    end
end
s=0.5;
A=scale(s); %s Ϊ������ģ
for k=1:floor(m*s)
    for h=1:floor(n*s)
        oricoor=A*[k;h;1]; %��ԭͼ��������
        g13(k,h)=nearest(f,oricoor(1),oricoor(2)); %���ڽ���ֵ
        g23(k,h)=bilinear(f,oricoor(1),oricoor(2)); %˫���Բ�ֵ
    end
end

figure(1);
set(gcf,'Position',get(0,'ScreenSize'),'Name','ƽ�� Tx=170, Ty=50');
subplot(1,1,1),imshow(uint8(g12)),title('ƽ��');
figure(2)
set(gcf,'Position',get(0,'ScreenSize'),'Name','����');
subplot(1,2,1),imshow(uint8(g13)),title('����Sx=Sy=0.5������');
subplot(1,2,2),imshow(uint8(g23)),title('����Sx=Sy=0.5��˫���Բ�ֵ');
figure(3);
set(gcf,'Position',get(0,'ScreenSize'),'Name','��ת');
subplot(1,2,1),imshow(uint8(g11)),title('��תtheta=0.5*pi������');
subplot(1,2,2),imshow(uint8(g21)),title('��תtheta=0.5*pi��˫���Բ�ֵ');

%% ��ƽ�ƾ���offx��offyΪ�ƶ�����
function A=translate(offx,offy)
    A=[1,0,-offx;0,1,-offy;0,0,1];
end

%% ���������bΪ�����߶�
function A=scale(b)
    b=1/b;
    A=[b,0,0;0,b,0;0,0,1];
end

%% ����ת�任����bΪ˳ʱ����ת�Ƕ�
function A=rotate(b)
    A=[cos(b),-sin(b),0;sin(b),cos(b),0;0,0,1];
end

%% �����ֵ��oriΪԭͼ��
function value=nearest(ori,x,y)
    [m,n]=size(ori);
    if x<1||x>m||y<1||y>n
        value=0;
    else
        value=ori(round(x),round(y));
    end
end
%% ˫���Բ�ֵ
function value=bilinear(ori,x,y)
    [m,n]=size(ori);
    if x<1||x>m||y<1||y>n
        value=0;
    else
        x1=floor(x);    %����ȡ��
        x2=ceil(x);     %����ȡ��
        y1=floor(y);
        y2=ceil(y);
        a1=x-x1;
        b1=y-y1;
        value=(1-a1)*(1-b1)*ori(x1,y1)+a1*(1-b1)*ori(x2,y1)...
        +(1-a1)*b1*ori(x1,y2)+a1*b1*ori(x2,y2);
    end
end
