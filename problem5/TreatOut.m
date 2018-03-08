%% �˻����� TreatOut= BlurFlt(a, b, T, uMax, vMax)  % a:x��,b:y��,T:����,uMax/vMax:Ƶ��ߴ�
function TreatOut= BlurFlt(a, b, T, uMax, vMax)
    TreatOut = 1i .* ones(uMax, vMax) ;
    for u = 1: 1: uMax
        for v = 1: 1: vMax
            clt = pi*( ( u-floor(uMax/2) )*a + ( v-floor(vMax/2) )*b);
            if clt==0
                TreatOut(u,v) = T;
            else
                TreatOut(u,v) = T/( clt ) * sin( clt ) * exp( -1i*clt );
            end
%             TreatOut(u,v) = T/( clt ) * sin( clt ) * exp( -1i*clt );
        end
    end
end

