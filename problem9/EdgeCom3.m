%% Marr-Hildreth���Ӻ���
function g=EdgeCom3(f,A)
    %fΪ����ͼ��AΪģ��
    [m,n]=size(f);
    gg=zeros(m+4,n+4);
    for i=-2:2
        for j=-2:2
            gg((3-i):(m+2-i),(3-j):(n+2-j))=gg((3-i):(m+2-i),(3-j):(n+2-j))+A(3+i,3+j)*f;
        end
    end
    g=gg(3:m+2,3:n+2);
end
