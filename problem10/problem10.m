clc;
clear all;

%% first question
img_ori = imread('origin/noisy_stroke.tif');
img_ori = medfilt2(img_ori, [12, 12]); % smooth
l1 = graythresh(img_ori);
img_bi = im2bw(img_ori ,l1);

[m,n] = size(img_bi);

% boudary 
boundary = zeros(m, n);
[initial_x,initial_y] = fun_getStartPoint(img_bi);    
lx = initial_x; ly = initial_y; kx = initial_x; ky = initial_y - 1;
[l1x,l1y,k1x,k1y] = fun_getNextPoint(img_bi,lx,ly,kx,ky);    
while (true)
    boundary(lx, ly) = 1;
    [lx,ly,kx,ky] = fun_getNextPoint(img_bi,lx,ly,kx,ky);
    if lx==initial_x && ly==initial_y
        [l2x,l2y,k2x,k2y]=fun_getNextPoint(img_bi,lx,ly,kx,ky);
        if l2x==l1x && l2y==l1y
            break;
        end
    end
end
% grid 
density = 28;
biggrid = zeros(m, n);
gridrows = floor(m/density);
gridcols = floor(n/density);
grid = zeros(gridrows,gridcols);
for i=1:m
    for j=1:n
        if(boundary(i, j) == 1)
            grid_x = floor(gridrows*i/m);
            grid_y = floor(gridcols*j/n);
            biggrid_x = floor(grid_x/gridrows*m);
            biggrid_y = floor(grid_y/gridcols*n);
            grid(grid_x,grid_y) = 1;
            biggrid(biggrid_x, biggrid_y) = 1;
        end
    end
end
figure(1);
subplot(221); imshow(img_ori); title('Original smoothed image');
subplot(222); imshow(boundary,[]); title('Boundary');
subplot(223); imshow(biggrid,[]); title('Big-grid');
subplot(224); imshow(grid,[]); title('Grid');  
saveas(figure(1), 'outimage/original somthed image, boundary,Big-grid and Grid image.jpg');
  
% code and difference code    
code = []; differentCode = []; count = 0;
[initial_x,initial_y] = fun_getStartPoint(grid);    
lx = initial_x; ly = initial_y; kx = initial_x; ky = initial_y - 1; di=0;
[l1x,l1y,k1x,k1y]=fun_getNextPoint(grid,lx,ly,kx,ky); 
while 1
    [lx,ly,kx,ky,di] = fun_getNextPoint(grid,lx,ly,kx,ky);
    count= count+1;
    code = [code,di];  
    if count>=2
        tmp = code(count)-code(count-1);
        if tmp<0 
            tmp=tmp+8;
        end;
        differentCode = [differentCode,tmp];  
    end
    if lx==initial_x && ly==initial_y
        [l2x,l2y,k2x,k2y]=fun_getNextPoint(grid,lx,ly,kx,ky);
        if l2x==l1x && l2y==l1y
            break;
        end
    end        
end
tmp = code(1)-code(count);
if tmp < 0 
    tmp = tmp+8;
end
differentCode = [differentCode,tmp];
display(num2str(code));
display(num2str(differentCode));

%% second question
pic1 = imread('origin/WashingtonDC_Band1.tif');
pic2 = imread('origin/WashingtonDC_Band2.tif');
pic3 = imread('origin/WashingtonDC_Band3.tif');
pic4 = imread('origin/WashingtonDC_Band4.tif');
pic5 = imread('origin/WashingtonDC_Band5.tif');
pic6 = imread('origin/WashingtonDC_Band6.tif');
% Vectorization
[m, n] = size(pic1);
images = {pic1,pic2,pic3,pic4,pic5,pic6};
vectors = zeros(m * n, 6);
ctr = 1;
for i=1:m
    for j=1:n
        for k=1:6
            vectors(ctr, k) = images{k}(i, j);
        end
        ctr = ctr + 1;
    end
end
% PCA
mx = zeros(1, 6);
for i = 1:m * n
    mx = mx + vectors(i, :);
end
mx = mx' / (m * n);
kx = zeros(6, 6);
for i=1:m * n
    kx = kx + vectors(i, :)' * vectors(i, :);
end
kx = kx / (m * n);
kx = kx - mx * mx';
[A, ~] = eig(kx);
A = flipud(A);
% Reconstruction
PCs = 2;
vector_metas = zeros(m * n, PCs);
for i=1:m * n
    vector_metas(i, :) = (A(1:PCs,:) * (vectors(i, :)' - mx))';
end
vector_reconstructs = zeros(m * n, 6);
for i=1:m * n
    vector_reconstructs(i, :) = (A(1:PCs,:)' * vector_metas(i, :)' + mx)';
end
reconstructs = {pic1,pic2,pic3,pic4,pic5,pic6};
ctr = 1;
for i=1:m
    for j=1:n
        for k=1:6
            reconstructs{k}(i, j) = vector_reconstructs(ctr, k);
        end
        ctr = ctr + 1;
    end
end
% Output
figure(2);
imshow(uint8(reconstructs{1})); title('reconstruct1');
saveas(figure(2),'outimage/reconstruct1.jpg')
figure(3);
imshow(uint8(reconstructs{2})); title('reconstruct2');
saveas(figure(3),'outimage/reconstruct2.jpg')
figure(4);
imshow(uint8(reconstructs{3})); title('reconstruct3');
saveas(figure(4),'outimage/reconstruct3.jpg')
figure(5);
imshow(uint8(reconstructs{4})); title('reconstruct4');
saveas(figure(5),'outimage/reconstruct4.jpg')
figure(6);
imshow(uint8(reconstructs{5})); title('reconstruct5');
saveas(figure(6),'outimage/reconstruct5.jpg')
figure(7);
imshow(uint8(reconstructs{6})); title('reconstruct6');
saveas(figure(7),'outimage/reconstruct6.jpg')

