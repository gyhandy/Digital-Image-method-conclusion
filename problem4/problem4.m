clc
clear all
format compact

CountFgr = 0;
%% --------------------------------noise Show---------------------------------
% %{
FileName = 'images\NoiseTestBlack.jpg';
ImOrgData = rgb2gray(imread(FileName));
[ImOrgPixRow,ImOrgPixCol] = size(ImOrgData);  % ����������
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','���� 1:NoneNoise, 2:Uniform, 3:Gaussian, 4:LogNormal');
StrCount = {'NoneNoise';'Uniform';'Gaussian';'LogNormal';'RayLeigh';'Exponential';'Erlang';'Salt&Pepper'};
NoiseNum = 8;       %�������� 1:NoneNoise, 2:Uniform, 3:Gaussian, 4:LogNormal, 5:RayLeigh, 6:Exponential, 7:Erlang, 8:Salt&Pepper
NoiseCount = 1;     %��ʼ�������� 
ImNewData = zeros(ImOrgPixRow,ImOrgPixCol,NoiseNum); %����ͼ��ʼ��
bNextFig = 0;
for NoiseCount = 1:1:NoiseNum       %ѭ�������������
    switch NoiseCount
        case 1
            ImNewData( : , : , NoiseCount) = TreatNoneNoise(ImOrgData); 
        case 2
            ImNewData( : , : , NoiseCount) = TreatUniform(ImOrgData, 0.0, 1.0);
            %%% #TreatOut = TreatUniform(ImOrgData,NoiseLowerBound,NoiseUpperBound) %ImOrgData:ͼ,NoiseLowerBound:�����½�,NoiseUpperBound:�����Ͻ�
            %%% #default: NoiseLowerBound=0,NoiseUpperBound=1
        case 3
            ImNewData( : , : , NoiseCount) = TreatGaussian(ImOrgData, 0.0, 1.0);
            %%% #TreatOut = TreatGaussian(ImOrgData,NoiseMean,NoiseVar)	%ImOrgData:ͼ,NoiseMean:������ֵ,NoiseVar:��������
            %%% #default:NoiseMean=0,NoiseVar=1
        case 4
            ImNewData( : , : , NoiseCount) = TreatLogNormal(ImOrgData, 1.0, 0.25);
            %%% #TreatOut = TreatLogNormal(ImOrgData,ParaA,ParaB)	%ImOrgData:ͼ,ParaA:������ֵ,ParaB:��������
            %%% #default:ParaA=1,ParaB=0.25
        case 5
            bNextFig = 1;       %��figure��ʾ
            CountFgr = CountFgr+1;
            figure(CountFgr);
            set(gcf,'Position',get(0,'ScreenSize'),'Name','���� 5:RayLeigh, 6:Exponential, 7:Erlang, 8:Salt&Pepper');
            ImNewData( : , : , NoiseCount) = TreatRayLeigh(ImOrgData,0.0,1.0);
            %%% #TreatOut = TreatRayLeigh(ImOrgData, ParaA, ParaB)	%ImOrgData:ͼ,ParaA:-,ParaB:-
            %%% #default:ParaA=0.0,ParaB=1.0
        case 6
            ImNewData( : , : , NoiseCount) = TreatExponential(ImOrgData, 1.0);
            %%% #TreatOut = TreatExponential(ImOrgData, ParaA)	%ImOrgData:ͼ,ParaA:-
            %%% #default:ParaA=1, ��ParaA�� MUST BE ��POSITIVE�� !!!
        case 7
            ImNewData( : , : , NoiseCount) = TreatErlang(ImOrgData, 2, 5);
            %%% #TreatOut = TreatErlang(ImOrgData, ParaA, ParaB)	%ImOrgData:ͼ,ParaA:-,ParaB:-
            %%% #default:ParaA=2,ParaB=5, ��ParaA�� MUST BE ��POSITIVE��!!!��ParaB�� MUST BE ��POSITIVE����INTEGER�� !!!
        case 8
            ImNewData( : , : , NoiseCount) = TreatSaltPepper(ImOrgData, 0.05, 0.05, 255);
            %%% #TreatOut = TreatSaltPepper(ImOrgData, ProbPepper, ProbSalt, Gray)	%ImOrgData:ͼ,ProbPepper:����,ProbSalt:����,Gray:����Scaling
            %%% $default:ProbPepper = 0.05, ProbSalt = 0.05, Gray = 255
        otherwise
            error('Undifined');
    end
    subplot( 2, 4, NoiseCount - bNextFig*4 ),imshow( uint8( ImNewData(:,:,NoiseCount) ) ),title(['�ռ�ͼ',StrCount(NoiseCount)]);
    subplot( 2, 4, NoiseCount - bNextFig*4 + 4 ),hist( ImNewData(:,:,NoiseCount) ),title(['ֱ��ͼ',StrCount(NoiseCount)]);
%     subplot( 3, NoiseNum, NoiseCount+NoiseNum*2 ),imshow(log(abs(fftshift(fft2( ImNewData(:,:,NoiseCount) )))),[]),title(['������',StrCount(NoiseCount)]);
end

%% load image
FileName = 'images\Circuit.tif';
ImOrgData = imread(FileName);
[ImOrgPixRow,ImOrgPixCol] = size(ImOrgData);  % ����������
%% ---------------------------��ֵ�˲�����ͼ5.7��----------------------------
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','��˹������Ⱦ�������/���ξ�ֵ�ռ��˲�');
subplot(2,2,1),imshow(ImOrgData),title('(a) ԭͼ');
%��˹��Ⱦ��������title
ImGaussianPltData = uint8(TreatGaussian(ImOrgData,0,20));
subplot(2,2,2),imshow(ImGaussianPltData),title('(b) ��˹������Ⱦ ��=0����^2=400');
% ������ֵ�˲�
subplot(2,2,3),imshow(TreatArithmeticMean(ImGaussianPltData,3,3)),title('(c) 3��3������ֵ�˲�');  
% ���ξ�ֵ�˲�
subplot(2,2,4),imshow( TreatGeometricMean(ImGaussianPltData,3,3) ),title('(d) 3��3���ξ�ֵ�˲�');  
%% -------------------------��ֵ�˲�����ͼ5.8��5.9��------------------------
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','����������Ⱦ�����г����ֵ�˲���');
subplot(2,3,1),imshow(ImOrgData),title('(z) ԭͼ');
%����������Ⱦ��������title
%%% TreatOut = TreatSaltPepper(ImOrgData, ProbPepper, ProbSalt, Gray)	%ImOrgData:ͼ,ProbPepper:����,ProbSalt:����,Gray:����Scaling
ImPltPepperData = uint8(TreatSaltPepper(ImOrgData, 0.1, 0, 255));
subplot(2,3,1),imshow(ImPltPepperData),title('(a) ���ΰ�����Ⱦ ProbPepper=0.1');
ImPltSaltData = uint8(TreatSaltPepper(ImOrgData, 0, 0.1, 255));
subplot(2,3,4),imshow(ImPltSaltData),title('(b) ����������Ⱦ ProbSalt=0.1');
%��г����ֵ�˲���������title
% ImContraHarmonicData = TreatContraHarmonic(ImData, FltWidth, FltHeight, ParaQ) %%ImData:ͼ, FltWidth:�˲���M, FltHeight:�˲���N, ParaQ:����Q
subplot(2,3,2),imshow( TreatContraHarmonic(ImPltPepperData, 3, 3, 1.5) ),title('(c) 3��3,Q=1.5��г����ֵ�˲���������'); 
subplot(2,3,3),imshow( TreatContraHarmonic(ImPltPepperData, 3, 3, -1.5) ),title('(e) 3��3,Q=-1.5��г����ֵ�˲���������'); 
subplot(2,3,5),imshow( TreatContraHarmonic(ImPltSaltData, 3, 3, -1.5) ),title('(d) 3��3,Q=-1.5��г����ֵ�˲�����������'); 
subplot(2,3,6),imshow( TreatContraHarmonic(ImPltSaltData, 3, 3, 1.5) ),title('(f) 3��3,Q=1.5��г����ֵ�˲�����������'); 

%% -----------------------ͳ�������˲�(ͼ5.10)------------------------
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','����������Ⱦ�����ֵ�˲���');
subplot(2,3,1),imshow(ImOrgData),title('(a) ԭͼ');
%����������Ⱦ��������title
%%% TreatOut = TreatSaltPepper(ImOrgData, ProbPepper, ProbSalt, Gray)	%ImOrgData:ͼ,ProbPepper:����,ProbSalt:����,Gray:����Scaling
ImPltData = uint8(TreatSaltPepper(ImOrgData, 0.1, 0.1, 255));
subplot(2,2,1),imshow(ImPltData),title('(a) ���ΰ�����Ⱦ ProbPepper=ProbSalt=0.1');
% TreatOut = TreatOrdStaticFlt(ImData, FltWidth, FltHeight, FltType) %��ֵ�˲�-ImData, FltWidth:�˲���M, FltHeight:�˲���N,FltType:1-��ֵ,2-���ֵ,3-��Сֵ
ImNewData = TreatOrdStaticFlt(ImPltData,3,3,1);
subplot(2,2,2),imshow(ImNewData),title('(b) ��1��3��3��ֵ�˲�');
ImNewData = TreatOrdStaticFlt(ImNewData,3,3,1);
subplot(2,2,3),imshow(ImNewData),title('(c) ��2��3��3��ֵ�˲�');
ImNewData = TreatOrdStaticFlt(ImNewData,3,3,1);
subplot(2,2,4),imshow(ImNewData),title('(d) ��3��3��3��ֵ�˲�');

%% -----------------------ͳ�������˲�(ͼ5.11)------------------------
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','����������Ⱦ��������Сֵ�˲���');
subplot(2,2,1),imshow(ImPltPepperData),title('(a) ���ΰ�����Ⱦ ProbPepper=0.1');
subplot(2,2,2),imshow(ImPltSaltData),title('(b) ����������Ⱦ ProbSalt=0.1');
subplot(2,2,3),imshow(TreatOrdStaticFlt(ImPltPepperData,3,3,2)),title('(c) �԰�����Ⱦ���ֵ�˲�');
subplot(2,2,4),imshow(TreatOrdStaticFlt(ImPltSaltData,3,3,3)),title('(d) ��������Ⱦ��Сֵ�˲�');
%}
%% -----------------------ͳ�������˲�(ͼ5.12)------------------------
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','���������ͽ����������ͳ���˲�����');
ImPltData = TreatUniform(ImOrgData,-20, 20 );
subplot(2,3,1),imshow(ImPltData),title('(a) ���Ծ�������,��=0,��^2=800');
ImPltData = uint8(TreatSaltPepperAdd(ImPltData, 0.1, 0.1, 255));
subplot(2,3,4),imshow(ImPltData),title('(b) �������ӽ������� ProbPepper=ProbSalt=0.1');
% ������ֵ�˲�
subplot(2,3,2),imshow( TreatArithmeticMean(ImPltData,5,5) ),title('(c) 5��5������ֵ�˲�');  
% ���ξ�ֵ�˲�
subplot(2,3,5),imshow( TreatGeometricMean(ImPltData,5,5) ),title('(d) 5��5���ξ�ֵ�˲�');  
% ��ֵ�˲���
subplot(2,3,3),imshow( TreatOrdStaticFlt(ImPltData,5,5,1) ),title('(e) 5��5��ֵ�˲�');  
%����ֵ�˲�
subplot(2,3,6),imshow( TreatAlphaMean(ImPltData,5,5,5) ),title('(f) 5��5,d=5�Ħ���ֵ�˲�');  
%% ----------------------------Functions-----------------------------
%% ������
function TreatOut = TreatNoneNoise(ImOrgData)
    TreatOut = ImOrgData;
end
%% Uniform-ImOrgData:ͼ,NoiseLowerBound:�����½�,NoiseUpperBound:�����Ͻ�
function TreatOut = TreatUniform(ImOrgData, NoiseLowerBound, NoiseUpperBound) 
    TreatOut = uint8(double(ImOrgData) + [NoiseLowerBound.* ones(size(ImOrgData)) + (NoiseUpperBound-NoiseLowerBound).*rand( size(ImOrgData) )]) ;
end
%% Gaussian-ImOrgData:ͼ,NoiseMean:������ֵ,NoiseVar:��������
function TreatOut = TreatGaussian(ImOrgData, NoiseMean, NoiseVar)	
    TreatOut = uint8(double(ImOrgData) + NoiseMean.* ones(size(ImOrgData)) + NoiseVar.*randn( size(ImOrgData) )) ;
end
%% LogNormal-ImOrgData:ͼ,ParaA:������ֵ,ParaB:��������
function TreatOut = TreatLogNormal(ImOrgData, ParaA, ParaB)	
    TreatOut = uint8(double(ImOrgData) + exp([ParaA + ParaB.*randn( size(ImOrgData) )])) ;
end
%% RayLeigh-ImOrgData:ͼ,ParaA:-,ParaB:-
function TreatOut = TreatRayLeigh(ImOrgData, ParaA, ParaB)	
    TreatOut = uint8(double(ImOrgData) + ParaA.* ones(size(ImOrgData)) + ( - ParaB.* log( 1-rand(size(ImOrgData)) )).^0.5);
end
%% Exponential-ImOrgData:ͼ,ParaA:-
function TreatOut = TreatExponential(ImOrgData, ParaA)	
    if ParaA <= 0
        error('ParaA must Be POSITIVE For Exponential !!!')
    end
    TreatOut = uint8(double(ImOrgData) + (-1/ParaA) .* log( 1.0 - rand(size(ImOrgData)) )) ;
end
%% Erlang-ImOrgData:ͼ,ParaA:-,ParaB:-
function TreatOut = TreatErlang(ImOrgData, ParaA, ParaB)	
    if ParaA <= 0
        error('ParaA must Be POSITIVE For Exponential !!!')
    end
    if ParaB <= 0
        error('ParaB must Be a ��POSITIVE�� Integer For Erlang !!!')
    end
    if ParaB ~= floor(ParaB)
        error('ParaB must Be a Positive ��INTEGER�� For Erlang !!!')
    end
        TreatTemp = double(zeros(size(ImOrgData)));
    for count = 1:1:ParaB
        TreatTemp = double(ImOrgData) + TreatTemp + (-1/ParaA) .* log( 1.0 - rand(size(ImOrgData)) ) ;
    end
    TreatOut = uint8(TreatTemp);
end
%% Salt&Pepper-ImOrgData:ͼ,ProbPepper:����,ProbSalt:����,Gray:����Scaling
function TreatOut = TreatSaltPepper(ImOrgData, ProbPepper, ProbSalt, Gray)	
    if ProbPepper + ProbSalt > 1
        error('The Sum Of Prob Must be ��no more than 1��!');
    end
    TreatTemp = double(ImOrgData);
    GenM = rand(size(ImOrgData));
    TreatTemp ( GenM <= ProbPepper ) = 0;
    TreatTemp ( GenM > ProbPepper & GenM <= ProbSalt + ProbPepper ) = 1 * Gray;
    TreatOut = uint8(TreatTemp);
end
function TreatOut = TreatSaltPepperAdd(ImOrgData, ProbPepper, ProbSalt, Gray)	
    if ProbPepper + ProbSalt > 1
        error('The Sum Of Prob Must be ��no more than 1��!');
    end
    TreatTemp = double(ImOrgData);
    GenM = rand(size(ImOrgData));
    TreatTemp ( GenM <= ProbPepper ) = 1;
    TreatTemp ( GenM > ProbPepper & GenM <= ProbSalt + ProbPepper ) = 1 * Gray;
    TreatOut = uint8(TreatTemp);
end
%% ������ֵ�˲��� TreatArithmeticMean(ImData,FltWidth,FltHeight)
function TreatOut = TreatArithmeticMean(ImData,FltWidth,FltHeight)
    [ImPixRow,ImPixCol] = size(ImData);
    ConvPad = double( zeros(ImPixRow+FltWidth-1,ImPixCol+FltHeight-1) );
    for ConvWidth = 1:1:FltWidth
        for ConvHeight = 1:1:FltHeight
            ConvPad( ConvWidth:ConvWidth+ImPixRow-1, ConvHeight:ConvHeight+ImPixCol-1 ) = ...
                ConvPad( ConvWidth:ConvWidth+ImPixRow-1, ConvHeight:ConvHeight+ImPixCol-1 ) + double(ImData);
        end
    end
    TreatOut = uint8(( 1/(FltWidth*FltHeight) ).*ConvPad( floor(ConvWidth/2)+1:floor(ConvWidth/2)+ImPixRow, floor(ConvHeight/2)+1:floor(ConvHeight/2)+ImPixCol ));
end
%% ���ξ�ֵ�˲��� TreatGeometricMean(ImData,FltWidth,FltHeight)
function TreatOut = TreatGeometricMean(ImData,FltWidth,FltHeight)
    [ImPixRow,ImPixCol] = size(ImData);
    ConvPad = double( ones(ImPixRow+FltWidth-1,ImPixCol+FltHeight-1) );
    for ConvWidth = 1:1:FltWidth
        for ConvHeight = 1:1:FltHeight
            ConvPad( ConvWidth:ConvWidth+ImPixRow-1, ConvHeight:ConvHeight+ImPixCol-1 ) =...
                ConvPad( ConvWidth:ConvWidth+ImPixRow-1, ConvHeight:ConvHeight+ImPixCol-1 ) .* double(ImData);
        end
    end
    TreatOut = ...
        uint8( (ConvPad( floor(ConvWidth/2)+1:floor(ConvWidth/2)+ImPixRow, floor(ConvHeight/2)+1:floor(ConvHeight/2)+ImPixCol )).^(1/(FltWidth*FltHeight)) );
end
%% ContraHarmonic-ImData:ͼ, FltWidth:�˲���M, FltHeight:�˲���N, ParaQ:����Q
function ImContraHarmonicData = TreatContraHarmonic(ImData, FltWidth, FltHeight, ParaQ)
    [ImPixRow,ImPixCol] = size(ImData);  % ����������
    ConvPadNumerator = double( zeros(ImPixRow+FltWidth-1,ImPixCol+FltHeight-1) );
    ConvPadDenominator = double( zeros(ImPixRow+FltWidth-1,ImPixCol+FltHeight-1) );
    for ConvWidth = 1:1:FltWidth
        for ConvHeight = 1:1:FltHeight
            ConvPadNumerator( ConvWidth:ConvWidth+ImPixRow-1, ConvHeight:ConvHeight+ImPixCol-1 ) =  ...
                ConvPadNumerator( ConvWidth:ConvWidth+ImPixRow-1, ConvHeight:ConvHeight+ImPixCol-1 ) + double(ImData).^(ParaQ+1);
            ConvPadDenominator( ConvWidth:ConvWidth+ImPixRow-1, ConvHeight:ConvHeight+ImPixCol-1 ) =  ...
                ConvPadDenominator( ConvWidth:ConvWidth+ImPixRow-1, ConvHeight:ConvHeight+ImPixCol-1 ) + double(ImData) .^(ParaQ);
        end
    end
    ImContraHarmonicData = uint8( ConvPadNumerator( floor(ConvWidth/2)+1:floor(ConvWidth/2)+ImPixRow, floor(ConvHeight/2)+1:floor(ConvHeight/2)+ImPixCol)...
        ./ ConvPadDenominator( floor(ConvWidth/2)+1:floor(ConvWidth/2)+ImPixRow, floor(ConvHeight/2)+1:floor(ConvHeight/2)+ImPixCol) );
end

%% ��ֵ�˲�-ImData, FltWidth:�˲���M, FltHeight:�˲���N,FltType:1-��ֵ,2-���ֵ,3-��Сֵ
function TreatOut = TreatOrdStaticFlt(ImData, FltWidth, FltHeight, FltType)
	[ImPixRow,ImPixCol] = size(ImData);  % ����������
    TempPad = uint8( zeros(ImPixRow+FltWidth-1,ImPixCol+FltHeight-1) );
    TreatTemp = uint8(zeros(ImPixRow,ImPixCol));
    TempPad( floor(FltWidth/2)+1 : floor(FltWidth/2)+ImPixRow , floor(FltHeight/2)+1 : floor(FltHeight/2)+ImPixCol ) = ImData; % Padding
    for i = floor(FltWidth/2)+1 : 1 : floor(FltWidth/2)+ImPixRow
        for j = floor(FltHeight/2)+1 : 1 : floor(FltHeight/2)+ImPixCol
            TempCur = TempPad( i-floor(FltWidth/2) : i+floor(FltWidth/2) , j-floor(FltHeight/2) : j+floor(FltHeight/2) );
            switch FltType
                case 1
                    TreatTemp ( i-floor(FltWidth/2) , j-floor(FltHeight/2) ) = median( TempCur(:) );
                case 2
                    TreatTemp ( i-floor(FltWidth/2) , j-floor(FltHeight/2) ) = max( TempCur(:) );
                case 3
                    TreatTemp ( i-floor(FltWidth/2) , j-floor(FltHeight/2) ) = min( TempCur(:) );
                otherwise
                        error('Undefined Type!!!')
            end
        end
    end
    TreatOut = TreatTemp(2:ImPixRow-1 , 2:ImPixCol-1);
end
%% ����ֵ�˲�
function TreatOut = TreatAlphaMean(ImData,FltWidth,FltHeight,ParaD)
	[ImPixRow,ImPixCol] = size(ImData);  % ����������
    TempPad = zeros(ImPixRow+FltWidth-1,ImPixCol+FltHeight-1) ;
    TreatTemp = zeros(ImPixRow,ImPixCol);
    TempPad( floor(FltWidth/2)+1 : floor(FltWidth/2)+ImPixRow , floor(FltHeight/2)+1 : floor(FltHeight/2)+ImPixCol ) = ImData; % Padding
    for i = floor(FltWidth/2)+1 : 1 : floor(FltWidth/2)+ImPixRow
        for j = floor(FltHeight/2)+1 : 1 : floor(FltHeight/2)+ImPixCol
            TempCur = TempPad( i-floor(FltWidth/2) : i+floor(FltWidth/2) , j-floor(FltHeight/2) : j+floor(FltHeight/2) );
            TempCur2 = sort(TempCur(:),'descend');
            TreatTemp( i-floor(FltWidth/2) , j-floor(FltHeight/2) ) =...
                sum( TempCur2( ceil(ParaD/2) : FltWidth*FltHeight - ceil(ParaD/2) ) ) / (FltWidth*FltHeight - 2*floor(ParaD/2));
        end
    end
    TreatOut = uint8(TreatTemp);
end