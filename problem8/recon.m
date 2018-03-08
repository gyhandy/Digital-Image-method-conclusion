%% Geodesic expansion 
% Geodesic expansion  R(A:point that be mask,s1,s2:m.n(represent the unit B),B:G(standard)
function C=recon(A,s1,s2,B)
    C = A;
    T = ones(size(C))-C;
    J = zeros(size(C));
    while ( sum(sum(T-C)) ) % stop when empty
        T = C;% record the C
        C = dilation(C,s1,s2) & B;% ≈Ú’Õ
    end
end