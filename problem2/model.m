%???骨骼图像增强??
clear all;
clc;
im=imread('skeleton_orig.tif');
im=im2double(im);


%---原始图像??
subplot(2,4,1);
imshow(im);
title('1：原始图像');

%---为图2，使用模板为[-1,-1,-1;-1,8,-1;-1,-1,-1]的滤波器对原图像进行拉普拉斯操作，为了便于显示，对图像进行了标定，这一步先对图像进行初步的锐化滤波。??
subplot(2,4,2);
h=[-1,-1,-1;-1,8,-1;-1,-1,-1];
im1=imfilter(im,h);
imshow(im1);
title('2：拉普拉斯操作后图像');
%---图3，由于使用的模板如上，让常数c=1，简单的将原图和图2相加就可以得到一幅经过锐化过的图像。??
subplot(2,4,3);
im2=im+im1;
imshow(im2)
title('3:1图和2图相加后图像');

%---图4，对原图像试用Sobel梯度操作，分量gx为[-1,-2,-1;0,0,0;1,2,1],而分量gy为[-1,0,1;-2,0,2;-1,0,1]的模板。??
subplot(2,4,4);
hx=[-1,-2,-1;0,0,0;1,2,1];%生产sobel垂直梯度模板??
hy=[-1,0,1;-2,0,2;-1,0,1];%生产sobel水平梯度模板??
gradx=filter2(hx,im,'same');
gradx=abs(gradx);%计算图像的sobel垂直梯度??
grady=filter2(hy,im,'same');
grady=abs(grady);%计算图像的sobel水平梯度??
im3=gradx+grady;%得到图像的sobel梯度??
imshow(im3,[]);
title('4:1图sobel梯度处理后图像');

%?---图5，使用大小为5*5的一个均值滤波器得到平滑后的Sobel梯度图像。??
subplot(2,4,5);
h1=fspecial('average',5);
im4=imfilter(im3,h1);
imshow(im4);
title('5:使用5*5均值滤波器平滑后的sobel图像');

%?--图6，将拉普拉斯图像（即图3）与平滑后的梯度图像（即图5）进行点乘。??
subplot(2,4,6);
%?im5=immultiply(im2,im4);??
im5=im2.*im4;
imshow(im5);
title('6:3图和5图相乘相乘的掩蔽图像');

%?--图7，将乘积图像（即图6）与原图像相加就产生一幅需要的锐化图像。??
subplot(2,4,7);
im6=im+im5;
imshow(im6);
title('7:1图和6图求和得到的锐化图像');

%?--图8，我们希望扩展灰度范围，对图7进行幂率变换处理，r=0.5，c=1，然后即可对图像进行幂率变换??
subplot(2,4,8);
gamma=0.5;
c=1;
im7=c.*im6.^gamma;
imshow(im7);
title('8:图7进行幂率变换后的最终图像');