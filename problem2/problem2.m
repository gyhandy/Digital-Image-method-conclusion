%Andy(Ge Yunhao) DIP
%problem2
clc;
clear all;
im=imread('skeleton_orig.tif'); %read image
figure(1)
set(gcf,'Position',get(0,'ScreenSize'),'Name','skeleton');
subplot(2,4,1);
imshow(im);
title('Original image');
im_a = im2double(im);% turn to double to calculate 先用in2double 映射到0到1的区间，然后处理完成用imshow（）就可以再次映射到0-255
%% Laplace mask(b)
%original Laplace mask
im_b_ori=im_a;
[m,n,c]=size(im_b_ori);
A=zeros(m,n,c);
for i=2:m-1
    for j=2:n-1
        A(i,j,1) = 8*im_b_ori(i,j,1)-im_b_ori(i-1,j-1,1)-im_b_ori(i-1,j,1)-im_b_ori(i-1,j+1,1)-im_b_ori(i,j-1,1)-im_b_ori(i,j+1,1)-im_b_ori(i+1,j-1,1)-im_b_ori(i+1,j,1)-im_b_ori(i+1,j+1,1);  
    end
end
%normalizaion Laplace mask
A_min = min(min(A));
im_b_m = A - A_min;
A_max = max(max(im_b_m));
im_b = 1.*(im_b_m./A_max);% 此处最大值是1因为已经映射到0-1了 
subplot(2,4,2);
imshow(im_b);
title('normalizaion Laplace mask');

%%Laplace sharpen(c)
im_c = im_a + A;
subplot(2,4,3);
imshow(im_c);
title('Laplace sharpen');


%%Sobel(d)
im_d_ori=im_a;
[m,n,c]=size(im_d_ori);
D=zeros(m,n,c);
for i=2:m-1
    for j=2:n-1
        D_x = -im_d_ori(i-1,j-1,1)-2*im_d_ori(i-1,j,1)-im_d_ori(i-1,j+1,1)+im_d_ori(i+1,j-1,1)+2*im_d_ori(i+1,j,1)+im_d_ori(i+1,j+1,1);
        D_y = -im_d_ori(i-1,j-1,1)+im_d_ori(i-1,j+1,1)-2*im_b_ori(i,j-1,1)+2*im_b_ori(i,j+1,1)-im_d_ori(i+1,j-1,1)+im_d_ori(i+1,j+1,1);
        D(i,j,1) = abs(D_x)+abs(D_y);
    end
end
im_d = D;
subplot(2,4,4);
imshow(im_d);
title('Sobel');

%%average filter(e)
im_e_ori=im_d;
[m,n,c]=size(im_e_ori);
E=zeros(m,n,c);
E_sum = 0;
for i=3:m-2
    for j=3:n-2
        % get sum to average
        for x=-2:2
            for y= -2:2
                E_sum =im_e_ori(i+x,j+y)+E_sum;
            end
        end
        E(i,j,1) = E_sum./25;
        E_sum = 0;
    end
end
im_e = E;
subplot(2,4,5);
imshow(im_e);
title('average filter image');

%% (f)=(c)*(e)
im_f = im_c.*im_e;
subplot(2,4,6);
imshow(im_f);
title('(f)=(c)*(e)');


%% (g)=(a)+(f)
im_g = im_a + im_f;
subplot(2,4,7);
imshow(im_g);
title('(g)=(a)*(f)');


%% Power rate transformation
gamma = 0.5
im_h = (im2double(im_g)).^gamma;
subplot(2,4,8);
imshow(im_h);
title('Power rate transformation');
saveas(figure(1),'output/Combining spatial enhancement methods.jpg' )








