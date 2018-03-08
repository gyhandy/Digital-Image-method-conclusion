%% Gaussian-ImOrgData:Í¼,NoiseMean:ÔëÉù¾ùÖµ,NoiseVar:ÔëÉù·½²î
function TreatOut = TreatGaussian(ImOrgData, NoiseMean, NoiseVar)	
%     TreatOut = uint8(double(ImOrgData) + NoiseMean.* ones(size(ImOrgData)) + NoiseVar.*randn( size(ImOrgData) )) ;
    TreatOut = double(ImOrgData) + NoiseMean.* ones(size(ImOrgData)) + NoiseVar.*randn( size(ImOrgData) );
end

