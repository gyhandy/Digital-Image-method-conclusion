%Andy(Ge Yunhao) DIP
%problem1
clc;
clear all;
%%（a）computing the histogram
% im=imread('original/Fig1.jpg'); %read image
im=imread('original/Fig2.jpg'); %read image
if size(im,3)>1  %if rgb, change into gray
    im=rgb2gray(im);
end
hist_im=imhist(im); %computing the histogram
[height,width]=size(im);


%%(b)histogram equalization technique
% hist_eq_im = zeros(size(hist_im,1),1);
pdf = hist_im./(height*width); %get the pdf
S = zeros(size(hist_im,1),1);

for k=1:256
    S(k) = floor(255*sum(pdf(1:k,:)));% histogram equalization
%     m(k) = sum(pdf(1:k,:));
end %这一步只需要找到变换前后每个像素的对应关系

%%求新图像的时候，按照像素进行遍历查找，新图像的每一个元素变为了拿个值im（新）= s（im（旧））
eq_im=im;
for i=1:height
   for j=1:width
       eq_im(i,j)= S(im(i,j)+1);
   end
end

% %%plot image(1)
% figure(1)
% set(gcf,'Position',get(0,'ScreenSize'),'Name','Fig1-histogram and histogram equalization image');
% subplot(2,3,1);
% imshow(im);
% title('Original gray image');
% 
% subplot(2,3,2);
% imhist(im);
% title('Original histogram image');
% 
% subplot(2,3,4);
% imshow(eq_im);
% title('histogram equalization image');
% 
% subplot(2,3,5);
% imhist(eq_im);
% title('histogram of histogram equalization image');
% saveas(figure(1),'output/Fig1-histogram and histogram equalization image.jpg')

%%plot image(2)
figure(2)
set(gcf,'Position',get(0,'ScreenSize'),'Name','Fig1-histogram and histogram equalization image');
subplot(2,3,1);
imshow(im);
title('Original gray image');

subplot(2,3,2);
imhist(im);
title('Original histogram image');

subplot(2,3,4);
imshow(eq_im);
title('histogram equalization image');

subplot(2,3,5);
imhist(eq_im);
title('histogram of histogram equalization image');
saveas(figure(2), 'output/Fig2-histogram and histogram equalization image.jpg')



