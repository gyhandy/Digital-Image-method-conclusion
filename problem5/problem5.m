close all
clear all
clc
format compact

%% load data
FileName = 'images\book_cover.jpg';
ImOrgData = imread(FileName);
[ImOrgPixRow,ImOrgPixCol] = size(ImOrgData);  % 行列像素数
figure(1);
set(gcf,'Position',get(0,'ScreenSize'),'Name','模糊退化与高斯噪声');
subplot( 2, 3, 1 ),imshow( ImOrgData,[] ),title('原图空间图');
subplot( 2, 3, 4 ),imhist( ImOrgData ),title('原图直方图');
FFrqData = fftshift(fft2(ImOrgData)); %原图-频域
HFrqData = BlurFlt(0.1, 0.1, 1, ImOrgPixRow, ImOrgPixCol);  %退化函数-频域
GFrqData = FFrqData .* HFrqData ;   %模糊-频域
GSptlData = ifft2(fftshift(GFrqData));  %模糊-空间
subplot( 2, 3, 2 ),imshow( real(GSptlData),[] ),title('模糊退化后空间图');
subplot( 2, 3, 5 ),imhist( uint8(real(GSptlData)) ),title('模糊退化后直方图');
GNSptlData = TreatGaussian(ifft2(fftshift(GFrqData)), 0, (650)^0.5);    %模糊-污染-空间
GNFrqData = fftshift(fft2(GNSptlData)); %模糊-污染-频域
subplot( 2, 3, 3 ),imshow( real(GNSptlData) , [] ),title('模糊退化加高斯噪声μ=0，σ^2=650后空间图');
subplot( 2, 3, 6 ),imhist( uint8(real(GNSptlData)) ),title('模糊退化加高斯噪声μ=0，σ^2=650后直方图');

%% 无噪与加噪的逆滤波比较
% %{
figure(2);
set(gcf,'Position',get(0,'ScreenSize'),'Name','无噪与加噪的逆滤波');
subplot( 2, 2, 1 ),imshow( real(ifft2(fftshift(GFrqData))),[] ),title('模糊退化后空间图');
subplot( 2, 2, 2 ),imshow( real(GNSptlData) , [] ),title('模糊高斯μ=0，σ^2=650空间图');
FESptlData = ifft2(fftshift( GFrqData./HFrqData )); %模糊-逆模糊-空间
subplot( 2, 2, 3 ),imshow( real(FESptlData) , [] ),title('模糊退化后逆滤波');
FNEFrqData = fftshift(fft2(GNSptlData))./HFrqData;  %模糊-污染-逆模糊-频域
FNESptlData = ifft2(fftshift(FNEFrqData));  %模糊-污染-逆模糊-空间
subplot( 2, 2, 4 ),imshow( real(FNESptlData), [] ),title('模糊高斯噪声后逆滤波');
%}
%% 模糊退化加高斯噪声后逆滤波,Butterworth低通滤波器不同半径滤波比较
%{
figure(3);
set(gcf,'Position',get(0,'ScreenSize'),'Name','加噪不同半径滤波比较');
% Butterworth低通
ParaD0 = [10.0 20.0 30.0 40.0 50.0];
n = 10;
FltNum = length(ParaD0);
subplot(2,(FltNum+1)/2,1),imshow( real(FNESptlData) , [] ),title('无Butterworth低通滤波');
FltBLPF = double( zeros(ImOrgPixRow,ImOrgPixCol,FltNum) );  %滤波器初始化
for FltPnt = 1:1:FltNum
    FltD0 = ParaD0(FltPnt);
    for iCount = 1: 1: ImOrgPixRow
       for jCount = 1: 1: ImOrgPixCol         
           FltD = sqrt(( iCount-floor(ImOrgPixRow/2) )^2 + ( jCount-floor(ImOrgPixCol/2) )^2);
           FltBLPF( iCount,jCount,FltPnt) = 1/( 1 + ( FltD / FltD0 )^(2*n));
       end
    end
    FNEFrqData = GNFrqData ./HFrqData.* FltBLPF( :,:,FltPnt);
    FNESptlData =  ifft2(fftshift(FNEFrqData));
    subplot(2,(FltNum+1)/2,FltPnt+1),imshow(real(FNESptlData), [] ),title(['Butterworth低通滤波后,d=',num2str(FltD0)]);
end
%}
%% 维纳滤波 K初步筛选:0.6到0.6^13
% %{
figure(4);
set(gcf,'Position',get(0,'ScreenSize'),'Name','维纳滤波 K初步筛选:0.6到0.6^13幂级数筛选');
subplot( 3, 5, 1 ),imshow( real(GNSptlData),[] ),title('模糊高斯μ=0，σ^2=650空间图');
subplot( 3, 5, 2 ),imshow( real(FNESptlData),[] ),title('逆滤波');
for iCount = 1:1:13
    ParaK = 0.6^(iCount);
    FEWFrqData = ( abs( HFrqData .* HFrqData ) ./ ( abs( HFrqData .* HFrqData ) + ParaK ) )./ HFrqData .* GNFrqData;
    FEWSptlData =  ifft2(fftshift(FEWFrqData)) ;
    subplot( 3, 5, 2 + iCount ),imshow( real(FEWSptlData) , [] ),title(['维纳滤波,K=',num2str(ParaK)]);
end
%}
%% 维纳滤波 K进一步筛选:0.010到0.047
% %{
figure(5);
set(gcf,'Position',get(0,'ScreenSize'),'Name','维纳滤波 K进一步筛选:0.010到0.047线性筛选');
for iCount = 1:1:15
    ParaK = 0.01 + (0.047-0.010)/14 * (iCount-1);
    FEWFrqData = ( abs( HFrqData .* HFrqData ) ./ ( abs( HFrqData .* HFrqData ) + ParaK ) )./ HFrqData .* GNFrqData;
    FEWSptlData =  ifft2(fftshift(FEWFrqData)) ;
    subplot( 3, 5, iCount ),imshow( real(FEWSptlData) , [] ),title(['维纳滤波,K=',num2str(ParaK)]);
end
% 最终选取 0.0153
%}
%% 使用不同的σ，验证维纳滤波性能
% %{
figure(6);
set(gcf,'Position',get(0,'ScreenSize'),'Name','使用不同的σ，验证维纳滤波性能');
    ParaK = 0.0153;
for iCount = 1:1:5
    GNSptlData = TreatGaussian(ifft2(fftshift(GFrqData)), 0, ( ( 650 * 10^(2-2*iCount) )^0.5));    %模糊-污染-空间
    GNFrqData = fftshift(fft2(GNSptlData)); %模糊-污染-频域
    subplot( 3, 5, iCount ),imshow( real(GNSptlData),[] ),title(['模糊高斯μ=0，σ^2=',num2str( 650 * 10^(2-2*iCount) ),'空间图']);
    subplot( 3, 5, iCount+5 ),imshow( real(ifft2(fftshift( GNFrqData./HFrqData ))) , [] ),title(['逆滤波']);
    FEWFrqData = ( abs( HFrqData .* HFrqData ) ./ ( abs( HFrqData .* HFrqData ) + ParaK ) )./ HFrqData .* GNFrqData;
    FEWSptlData =  ifft2(fftshift(FEWFrqData)) ;
    subplot( 3, 5, iCount+5*2 ),imshow( real(FEWSptlData) , [] ),title(['维纳滤波,K=',num2str(ParaK)]);
end
%}
