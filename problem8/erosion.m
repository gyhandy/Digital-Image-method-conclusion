%% erose binary image 
function C=erosion(A,s1,s2)
    %Ainput image  s1,s2Ϊerose unite length and width odd only
    [m,n]=size(A);
    [cnx,cny,cnv] = find(A);
    C=false(m,n);
    for cnt = 1 : size(cnv)
        if (cnx(cnt) >= 1+(s1-1)/2) && (cnx(cnt) <= m-(s1-1)/2) && (cny(cnt) >= 1+(s2-1)/2) && (cny(cnt) <= n-(s2-1)/2)
            if A((cnx(cnt)-(s1-1)/2):(cnx(cnt)+(s1-1)/2),(cny(cnt)-(s2-1)/2):(cny(cnt)+(s2-1)/2))==true(s1,s2)
                C(cnx(cnt),cny(cnt))=1;
            end
        end
    end
end

