%% Gaussian-ImOrgData:ͼ,NoiseMean:������ֵ,NoiseVar:��������
function TreatOut = TreatGaussian(ImOrgData, NoiseMean, NoiseVar)	
%     TreatOut = uint8(double(ImOrgData) + NoiseMean.* ones(size(ImOrgData)) + NoiseVar.*randn( size(ImOrgData) )) ;
    TreatOut = double(ImOrgData) + NoiseMean.* ones(size(ImOrgData)) + NoiseVar.*randn( size(ImOrgData) );
end

