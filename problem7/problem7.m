function p7()
img = double(imread('lenna.tif'));
figure(1);
subplot(2, 3, 1);
imshow(uint8(img));
title('ori');

 dct_img = DCT(img, 'zonal mask', 7);
%dct_img = DCT(img, 'threshold mask', 64);
subplot(2, 3, 2);
imshow(uint8(dct_img));
title('mask');

subplot(2, 3, 3);
diff_img = scale(img - dct_img);
imshow(uint8(diff_img));
title('diff');

% [sca_tran_img, recon_img, sca_diff_img] = waveletTransform(img, 'db4', 1);
% [sca_tran_img, recon_img, sca_diff_img] = waveletTransform(img, 'sym4', 1);
[sca_tran_img, recon_img, sca_diff_img] = waveletTransform(img, 'bior6.8', 1);
% [sca_tran_img, recon_img, sca_diff_img] = waveletTransform(img, 'haar', 1);
subplot(2, 3, 4);
imshow(uint8(sca_tran_img));
title('wavelet');


subplot(2, 3, 5);
imshow(uint8(recon_img));
title('compression');

subplot(2, 3, 6);
imshow(uint8(sca_diff_img));
title('difference');


%--------------------------------------------------------------------------
function z_mask = zonalMask(h, w, c)
z_mask = zeros(h, w);
for i = 1: c
    for j = 1: c - i + 1
        z_mask(i, j) = 1;
    end
end

%--------------------------------------------------------------------------
function t_masked_img = thresholdMask(img, c)
[h, w] = size(img);
t_masked_img = zeros(h, w);
sorted_img = sort(img(:), 'descend');
thre = sorted_img(c);
for i = 1: h
    for j = 1: w
        if img(i, j) >= thre
            t_masked_img(i, j) = img(i, j);
        end
    end
end

%--------------------------------------------------------------------------
% The second parameter can be 'zonal mask' or 'threshold mask'.
% c separately refers to the size of 1-masked area and the threshold of
% latter mask.
function idct_img = DCT(img, mask_name, c)
[h, w] = size(img);
size_sub_img = 8;
if mod(h, size_sub_img) ~= 0 || mod(w, size_sub_img) ~= 0
    span_img = zeros( h + mod(h, size_sub_img), w + mod(w, size_sub_img));
    span_img(1:h, 1:w) = img;
else
    span_img = img;
end
[h, w] = size(span_img);
idct_img = zeros(h, w);
for i = 1: floor(h/size_sub_img)
    for j = 1: floor(w/size_sub_img)
        sub_img = span_img((i - 1) * size_sub_img + 1: i * size_sub_img, (j - 1) * size_sub_img + 1: j * size_sub_img);
        dct_sub_img = dct2(sub_img);
        if strcmp(mask_name, 'zonal mask')
            mask_sub_img = zonalMask(size_sub_img, size_sub_img, c) .* dct_sub_img;
        else
            mask_sub_img = thresholdMask(dct_sub_img, c);
        end
        idct_img((i - 1) * size_sub_img + 1: i * size_sub_img, (j - 1) * size_sub_img + 1: j * size_sub_img) = idct2(mask_sub_img);
    end
end       

%--------------------------------------------------------------------------
% wavelet: 1: 'haar', 2: 'db4', 3: 'sym4', 4: 'bior6.8'
function [sca_tran_img, recon_img, sca_diff_img] = waveletTransform(img, wavelet, thre)
[h, w] = size(img);
[ccA1, ccH1, ccV1, ccD1] = dwt2(img, wavelet);
%cA1 = ccA1(1: h/2, 1: w/2);
cH1 = ccH1(1: h/2, 1: w/2);
cV1 = ccV1(1: h/2, 1: w/2);
cD1 = ccD1(1: h/2, 1: w/2);
[ccA2, ccH2, ccV2, ccD2] = dwt2(ccA1, wavelet);
%cA2 = ccA2(1: h/4, 1: w/4);
cH2 = ccH2(1: h/4, 1: w/4);
cV2 = ccV2(1: h/4, 1: w/4);
cD2 = ccD2(1: h/4, 1: w/4);
[ccA3, ccH3, ccV3, ccD3] = dwt2(ccA2, wavelet);
cA3 = ccA3(1: h/8, 1: w/8);
cH3 = ccH3(1: h/8, 1: w/8);
cV3 = ccV3(1: h/8, 1: w/8);
cD3 = ccD3(1: h/8, 1: w/8);

tran_img = zeros(h, w);
tran_img(1: h/8, 1: w/8) = cA3;
tran_img(1: h/8, w/8 + 1: w/4) = cH3;
tran_img(h/8 + 1: h/4, 1: w/8) = cV3;
tran_img(h/8 + 1: h/4, w/8 + 1: w/4) = cD3;
tran_img(1: h/4, w/4 + 1: w/2) = cH2;
tran_img(h/4 + 1: h/2, 1: w/4) = cV2;
tran_img(h/4 + 1: h/2, w/4 + 1: w/2) = cD2;
tran_img(1: h/2, w/2 + 1: w) = cH1;
tran_img(h/2 + 1: h, 1: w/2) = cV1;
tran_img(h/2 + 1: h, w/2 + 1: w) = cD1(1: h/2, 1: w/2);
sca_tran_img = zeros(h, w);
sca_tran_img(1: h/4, 1: w/4) = scale(tran_img(1: h/4, 1: w/4));
sca_tran_img(1: h/4, w/4 + 1: w/2) = scale(cH2);
sca_tran_img(h/4 + 1: h/2, 1: w/4) = scale(cV2);
sca_tran_img(h/4 + 1: h/2, w/4 + 1: w/2) = scale(cD2);
sca_tran_img(1: h/2, w/2 + 1: w) = scale(cH1);
sca_tran_img(h/2 + 1: h, 1: w/2) = scale(cV1);
sca_tran_img(h/2 + 1: h, w/2 + 1: w) = scale(cD1);

[h_c, w_c] = size(ccH3);
for i = 1: h_c
    for j = 1: w_c
        if ccH3(i, j) < thre
            ccH3(i, j) = 0;
        end
    end
end
[h_c, w_c] = size(ccV3);
for i = 1: h_c
    for j = 1: w_c
        if ccV3(i, j) < thre
            ccV3(i, j) = 0;
        end
    end
end
[h_c, w_c] = size(ccD3);
for i = 1: h_c
    for j = 1: w_c
        if ccD3(i, j) < thre
            ccD3(i, j) = 0;
        end
    end
end
[h_c, w_c] = size(ccH2);
for i = 1: h_c
    for j = 1: w_c
        if ccH2(i, j) < thre
            ccH2(i, j) = 0;
        end
    end
end
[h_c, w_c] = size(ccV2);
for i = 1: h_c
    for j = 1: w_c
        if ccV2(i, j) < thre
            ccV2(i, j) = 0;
        end
    end
end
[h_c, w_c] = size(ccD2);
for i = 1: h_c
    for j = 1: w_c
        if ccD2(i, j) < thre
            ccD2(i, j) = 0;
        end
    end
end
[h_c, w_c] = size(ccH1);
for i = 1: h_c
    for j = 1: w_c
        if ccH1(i, j) < thre
            ccH1(i, j) = 0;
        end
    end
end
[h_c, w_c] = size(ccV1);
for i = 1: h_c
    for j = 1: w_c
        if ccV1(i, j) < thre
            ccV1(i, j) = 0;
        end
    end
end
[h_c, w_c] = size(ccD1);
for i = 1: h_c
    for j = 1: w_c
        if ccD1(i, j) < thre
            ccD1(i, j) = 0;
        end
    end
end

rcA2 = idwt2(ccA3, ccH3, ccV3, ccD3, wavelet);
[h_t, w_t] = size(ccH2);
rcA2 = rcA2(1: h_t, 1: w_t);
rcA1 = idwt2(rcA2, ccH2, ccV2, ccD2, wavelet);
[h_t, w_t] = size(ccH1);
rcA1 = rcA1(1: h_t, 1: w_t);
recon_img = idwt2(rcA1, ccH1, ccV1, ccD1, wavelet);

diff_img = img - recon_img;
sca_diff_img = scale(diff_img);


%--------------------------------------------------------------------------
function sca_img = scale(img)
maxi = max(img(:));
mini = min(img(:));
diff = maxi - mini;
sca_img = (img - mini) / diff * 255;



        
