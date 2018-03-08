clc;
clear all;
format compact
in_img=imread('origin\Fig0929(a)(text_image).tif');
% ImOrgData=imread('images\test.bmp');
[m,n]=size(in_img);
%% Opening by reconstruction based on 929
figure(1);
set(gcf,'Position',get(0,'ScreenSize'),'Name','Opening by reconstruction');
subplot(2,2,1);imshow(in_img);title('a original');
ImEroData = erosion(in_img,51,1);
subplot(2,2,2);imshow(ImEroData);title('b erosion 51¡Á1');
ImOpenData = dilation( erosion(in_img,51,1) ,51,1);
subplot(2,2,3);imshow(ImOpenData);title('c open operation 51¡Á1');
ImRecData = recon(ImEroData,3,3,in_img);% reconstruction R(mask,m.n(represent the unit B),Gstandard)
subplot(2,2,4);imshow(ImRecData);title('Opening by reconstruction');
saveas(figure(1),'outimage/Opening by reconstruction.jpg');
%% Filling holes based on 9.31
in_img=imread('origin\Fig0931(a)(text_image).tif');
figure(2);
set(gcf,'Position',get(0,'ScreenSize'),'Name','Filling holes');
subplot(2,2,1);imshow(in_img);title('a original');
subplot(2,2,2);imshow(~in_img);title('b Complement ');
ImSignData=sign_edge(in_img,1);
subplot(2,2,3);imshow(ImSignData);title('c sign_edge');
H= ~recon(ImSignData,3,3,~in_img) ;
subplot(2,2,4);imshow(H);title('d after Filling holes');
saveas(figure(2),'outimage/Filling holes.jpg');
%% Border clearing
figure(3);
set(gcf,'Position',get(0,'ScreenSize'),'Name','erase edge');
ImESData=sign_edge(in_img,0);
ImEdgeData = recon(ImESData,3,3,in_img);
subplot(2,1,1);imshow(ImEdgeData);title('a sign at edge');
ImCenterData = in_img - ImEdgeData;
subplot(2,1,2);imshow(ImCenterData);title('b left mask');
saveas(figure(3),'outimage/erase edge.jpg');