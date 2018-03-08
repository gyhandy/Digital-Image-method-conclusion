close all
clear all
clc
format compact

%% load data
FileName = 'images\book_cover.jpg';
ImOrgData = imread(FileName);
[ImOrgPixRow,ImOrgPixCol] = size(ImOrgData);  % ����������
figure(1);
set(gcf,'Position',get(0,'ScreenSize'),'Name','ģ���˻����˹����');
subplot( 2, 3, 1 ),imshow( ImOrgData,[] ),title('ԭͼ�ռ�ͼ');
subplot( 2, 3, 4 ),imhist( ImOrgData ),title('ԭͼֱ��ͼ');
FFrqData = fftshift(fft2(ImOrgData)); %ԭͼ-Ƶ��
HFrqData = BlurFlt(0.1, 0.1, 1, ImOrgPixRow, ImOrgPixCol);  %�˻�����-Ƶ��
GFrqData = FFrqData .* HFrqData ;   %ģ��-Ƶ��
GSptlData = ifft2(fftshift(GFrqData));  %ģ��-�ռ�
subplot( 2, 3, 2 ),imshow( real(GSptlData),[] ),title('ģ���˻���ռ�ͼ');
subplot( 2, 3, 5 ),imhist( uint8(real(GSptlData)) ),title('ģ���˻���ֱ��ͼ');
GNSptlData = TreatGaussian(ifft2(fftshift(GFrqData)), 0, (650)^0.5);    %ģ��-��Ⱦ-�ռ�
GNFrqData = fftshift(fft2(GNSptlData)); %ģ��-��Ⱦ-Ƶ��
subplot( 2, 3, 3 ),imshow( real(GNSptlData) , [] ),title('ģ���˻��Ӹ�˹������=0����^2=650��ռ�ͼ');
subplot( 2, 3, 6 ),imhist( uint8(real(GNSptlData)) ),title('ģ���˻��Ӹ�˹������=0����^2=650��ֱ��ͼ');

%% �������������˲��Ƚ�
% %{
figure(2);
set(gcf,'Position',get(0,'ScreenSize'),'Name','�������������˲�');
subplot( 2, 2, 1 ),imshow( real(ifft2(fftshift(GFrqData))),[] ),title('ģ���˻���ռ�ͼ');
subplot( 2, 2, 2 ),imshow( real(GNSptlData) , [] ),title('ģ����˹��=0����^2=650�ռ�ͼ');
FESptlData = ifft2(fftshift( GFrqData./HFrqData )); %ģ��-��ģ��-�ռ�
subplot( 2, 2, 3 ),imshow( real(FESptlData) , [] ),title('ģ���˻������˲�');
FNEFrqData = fftshift(fft2(GNSptlData))./HFrqData;  %ģ��-��Ⱦ-��ģ��-Ƶ��
FNESptlData = ifft2(fftshift(FNEFrqData));  %ģ��-��Ⱦ-��ģ��-�ռ�
subplot( 2, 2, 4 ),imshow( real(FNESptlData), [] ),title('ģ����˹���������˲�');
%}
%% ģ���˻��Ӹ�˹���������˲�,Butterworth��ͨ�˲�����ͬ�뾶�˲��Ƚ�
%{
figure(3);
set(gcf,'Position',get(0,'ScreenSize'),'Name','���벻ͬ�뾶�˲��Ƚ�');
% Butterworth��ͨ
ParaD0 = [10.0 20.0 30.0 40.0 50.0];
n = 10;
FltNum = length(ParaD0);
subplot(2,(FltNum+1)/2,1),imshow( real(FNESptlData) , [] ),title('��Butterworth��ͨ�˲�');
FltBLPF = double( zeros(ImOrgPixRow,ImOrgPixCol,FltNum) );  %�˲�����ʼ��
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
    subplot(2,(FltNum+1)/2,FltPnt+1),imshow(real(FNESptlData), [] ),title(['Butterworth��ͨ�˲���,d=',num2str(FltD0)]);
end
%}
%% ά���˲� K����ɸѡ:0.6��0.6^13
% %{
figure(4);
set(gcf,'Position',get(0,'ScreenSize'),'Name','ά���˲� K����ɸѡ:0.6��0.6^13�ݼ���ɸѡ');
subplot( 3, 5, 1 ),imshow( real(GNSptlData),[] ),title('ģ����˹��=0����^2=650�ռ�ͼ');
subplot( 3, 5, 2 ),imshow( real(FNESptlData),[] ),title('���˲�');
for iCount = 1:1:13
    ParaK = 0.6^(iCount);
    FEWFrqData = ( abs( HFrqData .* HFrqData ) ./ ( abs( HFrqData .* HFrqData ) + ParaK ) )./ HFrqData .* GNFrqData;
    FEWSptlData =  ifft2(fftshift(FEWFrqData)) ;
    subplot( 3, 5, 2 + iCount ),imshow( real(FEWSptlData) , [] ),title(['ά���˲�,K=',num2str(ParaK)]);
end
%}
%% ά���˲� K��һ��ɸѡ:0.010��0.047
% %{
figure(5);
set(gcf,'Position',get(0,'ScreenSize'),'Name','ά���˲� K��һ��ɸѡ:0.010��0.047����ɸѡ');
for iCount = 1:1:15
    ParaK = 0.01 + (0.047-0.010)/14 * (iCount-1);
    FEWFrqData = ( abs( HFrqData .* HFrqData ) ./ ( abs( HFrqData .* HFrqData ) + ParaK ) )./ HFrqData .* GNFrqData;
    FEWSptlData =  ifft2(fftshift(FEWFrqData)) ;
    subplot( 3, 5, iCount ),imshow( real(FEWSptlData) , [] ),title(['ά���˲�,K=',num2str(ParaK)]);
end
% ����ѡȡ 0.0153
%}
%% ʹ�ò�ͬ�Ħң���֤ά���˲�����
% %{
figure(6);
set(gcf,'Position',get(0,'ScreenSize'),'Name','ʹ�ò�ͬ�Ħң���֤ά���˲�����');
    ParaK = 0.0153;
for iCount = 1:1:5
    GNSptlData = TreatGaussian(ifft2(fftshift(GFrqData)), 0, ( ( 650 * 10^(2-2*iCount) )^0.5));    %ģ��-��Ⱦ-�ռ�
    GNFrqData = fftshift(fft2(GNSptlData)); %ģ��-��Ⱦ-Ƶ��
    subplot( 3, 5, iCount ),imshow( real(GNSptlData),[] ),title(['ģ����˹��=0����^2=',num2str( 650 * 10^(2-2*iCount) ),'�ռ�ͼ']);
    subplot( 3, 5, iCount+5 ),imshow( real(ifft2(fftshift( GNFrqData./HFrqData ))) , [] ),title(['���˲�']);
    FEWFrqData = ( abs( HFrqData .* HFrqData ) ./ ( abs( HFrqData .* HFrqData ) + ParaK ) )./ HFrqData .* GNFrqData;
    FEWSptlData =  ifft2(fftshift(FEWFrqData)) ;
    subplot( 3, 5, iCount+5*2 ),imshow( real(FEWSptlData) , [] ),title(['ά���˲�,K=',num2str(ParaK)]);
end
%}
