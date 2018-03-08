clc
clear all
format compact

CountFgr = 0;
%% --------------------------------noise Show---------------------------------
% %{
FileName = 'images\NoiseTestBlack.jpg';
ImOrgData = rgb2gray(imread(FileName));
[ImOrgPixRow,ImOrgPixCol] = size(ImOrgData);  % 行列像素数
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','噪声 1:NoneNoise, 2:Uniform, 3:Gaussian, 4:LogNormal');
StrCount = {'NoneNoise';'Uniform';'Gaussian';'LogNormal';'RayLeigh';'Exponential';'Erlang';'Salt&Pepper'};
NoiseNum = 8;       %噪声种类 1:NoneNoise, 2:Uniform, 3:Gaussian, 4:LogNormal, 5:RayLeigh, 6:Exponential, 7:Erlang, 8:Salt&Pepper
NoiseCount = 1;     %初始噪声种类 
ImNewData = zeros(ImOrgPixRow,ImOrgPixCol,NoiseNum); %噪声图初始化
bNextFig = 0;
for NoiseCount = 1:1:NoiseNum       %循环输出噪声样例
    switch NoiseCount
        case 1
            ImNewData( : , : , NoiseCount) = TreatNoneNoise(ImOrgData); 
        case 2
            ImNewData( : , : , NoiseCount) = TreatUniform(ImOrgData, 0.0, 1.0);
            %%% #TreatOut = TreatUniform(ImOrgData,NoiseLowerBound,NoiseUpperBound) %ImOrgData:图,NoiseLowerBound:噪声下界,NoiseUpperBound:噪声上界
            %%% #default: NoiseLowerBound=0,NoiseUpperBound=1
        case 3
            ImNewData( : , : , NoiseCount) = TreatGaussian(ImOrgData, 0.0, 1.0);
            %%% #TreatOut = TreatGaussian(ImOrgData,NoiseMean,NoiseVar)	%ImOrgData:图,NoiseMean:噪声均值,NoiseVar:噪声方差
            %%% #default:NoiseMean=0,NoiseVar=1
        case 4
            ImNewData( : , : , NoiseCount) = TreatLogNormal(ImOrgData, 1.0, 0.25);
            %%% #TreatOut = TreatLogNormal(ImOrgData,ParaA,ParaB)	%ImOrgData:图,ParaA:噪声均值,ParaB:噪声方差
            %%% #default:ParaA=1,ParaB=0.25
        case 5
            bNextFig = 1;       %换figure显示
            CountFgr = CountFgr+1;
            figure(CountFgr);
            set(gcf,'Position',get(0,'ScreenSize'),'Name','噪声 5:RayLeigh, 6:Exponential, 7:Erlang, 8:Salt&Pepper');
            ImNewData( : , : , NoiseCount) = TreatRayLeigh(ImOrgData,0.0,1.0);
            %%% #TreatOut = TreatRayLeigh(ImOrgData, ParaA, ParaB)	%ImOrgData:图,ParaA:-,ParaB:-
            %%% #default:ParaA=0.0,ParaB=1.0
        case 6
            ImNewData( : , : , NoiseCount) = TreatExponential(ImOrgData, 1.0);
            %%% #TreatOut = TreatExponential(ImOrgData, ParaA)	%ImOrgData:图,ParaA:-
            %%% #default:ParaA=1, 【ParaA】 MUST BE 【POSITIVE】 !!!
        case 7
            ImNewData( : , : , NoiseCount) = TreatErlang(ImOrgData, 2, 5);
            %%% #TreatOut = TreatErlang(ImOrgData, ParaA, ParaB)	%ImOrgData:图,ParaA:-,ParaB:-
            %%% #default:ParaA=2,ParaB=5, 【ParaA】 MUST BE 【POSITIVE】!!!【ParaB】 MUST BE 【POSITIVE】【INTEGER】 !!!
        case 8
            ImNewData( : , : , NoiseCount) = TreatSaltPepper(ImOrgData, 0.05, 0.05, 255);
            %%% #TreatOut = TreatSaltPepper(ImOrgData, ProbPepper, ProbSalt, Gray)	%ImOrgData:图,ProbPepper:暗点,ProbSalt:亮点,Gray:亮点Scaling
            %%% $default:ProbPepper = 0.05, ProbSalt = 0.05, Gray = 255
        otherwise
            error('Undifined');
    end
    subplot( 2, 4, NoiseCount - bNextFig*4 ),imshow( uint8( ImNewData(:,:,NoiseCount) ) ),title(['空间图',StrCount(NoiseCount)]);
    subplot( 2, 4, NoiseCount - bNextFig*4 + 4 ),hist( ImNewData(:,:,NoiseCount) ),title(['直方图',StrCount(NoiseCount)]);
%     subplot( 3, NoiseNum, NoiseCount+NoiseNum*2 ),imshow(log(abs(fftshift(fft2( ImNewData(:,:,NoiseCount) )))),[]),title(['幅度谱',StrCount(NoiseCount)]);
end

%% load image
FileName = 'images\Circuit.tif';
ImOrgData = imread(FileName);
[ImOrgPixRow,ImOrgPixCol] = size(ImOrgData);  % 行列像素数
%% ---------------------------均值滤波器（图5.7）----------------------------
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','高斯噪声污染后的算数/几何均值空间滤波');
subplot(2,2,1),imshow(ImOrgData),title('(a) 原图');
%高斯污染，参数见title
ImGaussianPltData = uint8(TreatGaussian(ImOrgData,0,20));
subplot(2,2,2),imshow(ImGaussianPltData),title('(b) 高斯噪声污染 μ=0，σ^2=400');
% 算术均值滤波
subplot(2,2,3),imshow(TreatArithmeticMean(ImGaussianPltData,3,3)),title('(c) 3×3算数均值滤波');  
% 几何均值滤波
subplot(2,2,4),imshow( TreatGeometricMean(ImGaussianPltData,3,3) ),title('(d) 3×3几何均值滤波');  
%% -------------------------均值滤波器（图5.8、5.9）------------------------
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','椒盐噪声污染后的逆谐波均值滤波器');
subplot(2,3,1),imshow(ImOrgData),title('(z) 原图');
%椒盐噪声污染，参数见title
%%% TreatOut = TreatSaltPepper(ImOrgData, ProbPepper, ProbSalt, Gray)	%ImOrgData:图,ProbPepper:暗点,ProbSalt:亮点,Gray:亮点Scaling
ImPltPepperData = uint8(TreatSaltPepper(ImOrgData, 0.1, 0, 255));
subplot(2,3,1),imshow(ImPltPepperData),title('(a) 椒盐暗噪污染 ProbPepper=0.1');
ImPltSaltData = uint8(TreatSaltPepper(ImOrgData, 0, 0.1, 255));
subplot(2,3,4),imshow(ImPltSaltData),title('(b) 椒盐亮噪污染 ProbSalt=0.1');
%逆谐波均值滤波，参数见title
% ImContraHarmonicData = TreatContraHarmonic(ImData, FltWidth, FltHeight, ParaQ) %%ImData:图, FltWidth:滤波器M, FltHeight:滤波器N, ParaQ:阶数Q
subplot(2,3,2),imshow( TreatContraHarmonic(ImPltPepperData, 3, 3, 1.5) ),title('(c) 3×3,Q=1.5逆谐波均值滤波处理暗噪声'); 
subplot(2,3,3),imshow( TreatContraHarmonic(ImPltPepperData, 3, 3, -1.5) ),title('(e) 3×3,Q=-1.5逆谐波均值滤波处理暗噪声'); 
subplot(2,3,5),imshow( TreatContraHarmonic(ImPltSaltData, 3, 3, -1.5) ),title('(d) 3×3,Q=-1.5逆谐波均值滤波处理亮噪声'); 
subplot(2,3,6),imshow( TreatContraHarmonic(ImPltSaltData, 3, 3, 1.5) ),title('(f) 3×3,Q=1.5逆谐波均值滤波处理亮噪声'); 

%% -----------------------统计排序滤波(图5.10)------------------------
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','椒盐噪声污染后的中值滤波器');
subplot(2,3,1),imshow(ImOrgData),title('(a) 原图');
%椒盐噪声污染，参数见title
%%% TreatOut = TreatSaltPepper(ImOrgData, ProbPepper, ProbSalt, Gray)	%ImOrgData:图,ProbPepper:暗点,ProbSalt:亮点,Gray:亮点Scaling
ImPltData = uint8(TreatSaltPepper(ImOrgData, 0.1, 0.1, 255));
subplot(2,2,1),imshow(ImPltData),title('(a) 椒盐暗噪污染 ProbPepper=ProbSalt=0.1');
% TreatOut = TreatOrdStaticFlt(ImData, FltWidth, FltHeight, FltType) %中值滤波-ImData, FltWidth:滤波器M, FltHeight:滤波器N,FltType:1-中值,2-最大值,3-最小值
ImNewData = TreatOrdStaticFlt(ImPltData,3,3,1);
subplot(2,2,2),imshow(ImNewData),title('(b) 第1次3×3中值滤波');
ImNewData = TreatOrdStaticFlt(ImNewData,3,3,1);
subplot(2,2,3),imshow(ImNewData),title('(c) 第2次3×3中值滤波');
ImNewData = TreatOrdStaticFlt(ImNewData,3,3,1);
subplot(2,2,4),imshow(ImNewData),title('(d) 第3次3×3中值滤波');

%% -----------------------统计排序滤波(图5.11)------------------------
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','椒盐噪声污染后的最大最小值滤波器');
subplot(2,2,1),imshow(ImPltPepperData),title('(a) 椒盐暗噪污染 ProbPepper=0.1');
subplot(2,2,2),imshow(ImPltSaltData),title('(b) 椒盐亮噪污染 ProbSalt=0.1');
subplot(2,2,3),imshow(TreatOrdStaticFlt(ImPltPepperData,3,3,2)),title('(c) 对暗噪污染最大值滤波');
subplot(2,2,4),imshow(TreatOrdStaticFlt(ImPltSaltData,3,3,3)),title('(d) 对亮噪污染最小值滤波');
%}
%% -----------------------统计排序滤波(图5.12)------------------------
CountFgr = CountFgr+1;
figure(CountFgr);
set(gcf,'Position',get(0,'ScreenSize'),'Name','均匀噪声和椒盐噪声后的统计滤波处理');
ImPltData = TreatUniform(ImOrgData,-20, 20 );
subplot(2,3,1),imshow(ImPltData),title('(a) 加性均匀噪声,μ=0,σ^2=800');
ImPltData = uint8(TreatSaltPepperAdd(ImPltData, 0.1, 0.1, 255));
subplot(2,3,4),imshow(ImPltData),title('(b) 继续叠加椒盐噪声 ProbPepper=ProbSalt=0.1');
% 算术均值滤波
subplot(2,3,2),imshow( TreatArithmeticMean(ImPltData,5,5) ),title('(c) 5×5算数均值滤波');  
% 几何均值滤波
subplot(2,3,5),imshow( TreatGeometricMean(ImPltData,5,5) ),title('(d) 5×5几何均值滤波');  
% 中值滤波器
subplot(2,3,3),imshow( TreatOrdStaticFlt(ImPltData,5,5,1) ),title('(e) 5×5中值滤波');  
%α均值滤波
subplot(2,3,6),imshow( TreatAlphaMean(ImPltData,5,5,5) ),title('(f) 5×5,d=5的α均值滤波');  
%% ----------------------------Functions-----------------------------
%% 无噪声
function TreatOut = TreatNoneNoise(ImOrgData)
    TreatOut = ImOrgData;
end
%% Uniform-ImOrgData:图,NoiseLowerBound:噪声下界,NoiseUpperBound:噪声上界
function TreatOut = TreatUniform(ImOrgData, NoiseLowerBound, NoiseUpperBound) 
    TreatOut = uint8(double(ImOrgData) + [NoiseLowerBound.* ones(size(ImOrgData)) + (NoiseUpperBound-NoiseLowerBound).*rand( size(ImOrgData) )]) ;
end
%% Gaussian-ImOrgData:图,NoiseMean:噪声均值,NoiseVar:噪声方差
function TreatOut = TreatGaussian(ImOrgData, NoiseMean, NoiseVar)	
    TreatOut = uint8(double(ImOrgData) + NoiseMean.* ones(size(ImOrgData)) + NoiseVar.*randn( size(ImOrgData) )) ;
end
%% LogNormal-ImOrgData:图,ParaA:噪声均值,ParaB:噪声方差
function TreatOut = TreatLogNormal(ImOrgData, ParaA, ParaB)	
    TreatOut = uint8(double(ImOrgData) + exp([ParaA + ParaB.*randn( size(ImOrgData) )])) ;
end
%% RayLeigh-ImOrgData:图,ParaA:-,ParaB:-
function TreatOut = TreatRayLeigh(ImOrgData, ParaA, ParaB)	
    TreatOut = uint8(double(ImOrgData) + ParaA.* ones(size(ImOrgData)) + ( - ParaB.* log( 1-rand(size(ImOrgData)) )).^0.5);
end
%% Exponential-ImOrgData:图,ParaA:-
function TreatOut = TreatExponential(ImOrgData, ParaA)	
    if ParaA <= 0
        error('ParaA must Be POSITIVE For Exponential !!!')
    end
    TreatOut = uint8(double(ImOrgData) + (-1/ParaA) .* log( 1.0 - rand(size(ImOrgData)) )) ;
end
%% Erlang-ImOrgData:图,ParaA:-,ParaB:-
function TreatOut = TreatErlang(ImOrgData, ParaA, ParaB)	
    if ParaA <= 0
        error('ParaA must Be POSITIVE For Exponential !!!')
    end
    if ParaB <= 0
        error('ParaB must Be a 【POSITIVE】 Integer For Erlang !!!')
    end
    if ParaB ~= floor(ParaB)
        error('ParaB must Be a Positive 【INTEGER】 For Erlang !!!')
    end
        TreatTemp = double(zeros(size(ImOrgData)));
    for count = 1:1:ParaB
        TreatTemp = double(ImOrgData) + TreatTemp + (-1/ParaA) .* log( 1.0 - rand(size(ImOrgData)) ) ;
    end
    TreatOut = uint8(TreatTemp);
end
%% Salt&Pepper-ImOrgData:图,ProbPepper:暗点,ProbSalt:亮点,Gray:亮点Scaling
function TreatOut = TreatSaltPepper(ImOrgData, ProbPepper, ProbSalt, Gray)	
    if ProbPepper + ProbSalt > 1
        error('The Sum Of Prob Must be 【no more than 1】!');
    end
    TreatTemp = double(ImOrgData);
    GenM = rand(size(ImOrgData));
    TreatTemp ( GenM <= ProbPepper ) = 0;
    TreatTemp ( GenM > ProbPepper & GenM <= ProbSalt + ProbPepper ) = 1 * Gray;
    TreatOut = uint8(TreatTemp);
end
function TreatOut = TreatSaltPepperAdd(ImOrgData, ProbPepper, ProbSalt, Gray)	
    if ProbPepper + ProbSalt > 1
        error('The Sum Of Prob Must be 【no more than 1】!');
    end
    TreatTemp = double(ImOrgData);
    GenM = rand(size(ImOrgData));
    TreatTemp ( GenM <= ProbPepper ) = 1;
    TreatTemp ( GenM > ProbPepper & GenM <= ProbSalt + ProbPepper ) = 1 * Gray;
    TreatOut = uint8(TreatTemp);
end
%% 算数均值滤波器 TreatArithmeticMean(ImData,FltWidth,FltHeight)
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
%% 几何均值滤波器 TreatGeometricMean(ImData,FltWidth,FltHeight)
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
%% ContraHarmonic-ImData:图, FltWidth:滤波器M, FltHeight:滤波器N, ParaQ:阶数Q
function ImContraHarmonicData = TreatContraHarmonic(ImData, FltWidth, FltHeight, ParaQ)
    [ImPixRow,ImPixCol] = size(ImData);  % 行列像素数
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

%% 中值滤波-ImData, FltWidth:滤波器M, FltHeight:滤波器N,FltType:1-中值,2-最大值,3-最小值
function TreatOut = TreatOrdStaticFlt(ImData, FltWidth, FltHeight, FltType)
	[ImPixRow,ImPixCol] = size(ImData);  % 行列像素数
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
%% α均值滤波
function TreatOut = TreatAlphaMean(ImData,FltWidth,FltHeight,ParaD)
	[ImPixRow,ImPixCol] = size(ImData);  % 行列像素数
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