%% get the edge sigh
function C=sign_edge(A,s)
    [m,n]=size(A);
    if s==1 
        C = zeros(m,n);
        C(1,1:n)=1-A(1,1:n);%  up and down 
        C(2:m-1,1)=1-A(2:m-1,1);
        C(2:m-1,n)=1-A(2:m-1,n);%  left and right
    end
    if s==0
        C = A;
        C(2:m-1,2:n-1)=zeros(m-2,n-2);
    end
end

