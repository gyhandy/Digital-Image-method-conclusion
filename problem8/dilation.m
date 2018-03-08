%% dilation binary image
function C=dilation(A,s1,s2)
    %A input image  s1,s2 unit odd only
    [m,n]=size(A);
    AM = zeros(m+s1-1,n+s2-1);
    AM( floor(s1/2)+1:m+floor(s1/2),floor(s2/2)+1:n+floor(s2/2) ) = A;
    [cnx,cny,cnv] = find(AM);
    CM=false(m+s1-1,n+s2-1);
    Oplt = ones(s1,s2);
    for cnt = 1 : size(cnv)
        CM( (cnx(cnt)-(s1-1)/2) : (cnx(cnt)+(s1-1)/2), (cny(cnt)-(s2-1)/2) : (cny(cnt)+(s2-1)/2) ) = Oplt;
    end
    C=CM( floor(s1/2)+1:m+floor(s1/2),floor(s2/2)+1:n+floor(s2/2) );
end

