function [Fv] = HOLG(I,sigma) 
% I = imresize(I,[128 128],'bicubic');
% figure
% imagesc(I)
% sigma =2.5;
% sz =11;
% sigma = 5.6971;
% f = 0.0961;
  f= sigma*2*sqrt(2);
  sz =2*round(2.575*sigma) + 1;
% f = 0.1*2;
no= 8;
theta = (0:no-1)*(180/no);
for i =1:length(theta)
[H] = gabormask(sz, sigma,f,theta(i));
J = imfilter(I,real(H),'same','replicate');
J2 = imfilter(I,imag(H),'same','replicate');

% figure
% imagesc(J)
% colormap(gray)
C1(:,:,i)=J;
C2(:,:,i) = J2;
end
[l,m,n]= size(C1);
for i = 1:l
    for j = 1:m
        mini = C1(i,j,1);
        ma =abs(complex(C1(i,j,1),C2(i,j,1)));
        index = 0;
        for k = 1: n
            
            if (mini>C1(i,j,k))
                mini = C1(i,j,k);
                 ma = abs(complex(C1(i,j,k),C2(i,j,k)));
                index = k-1;
            end
        end
    C3(i,j) = ma; 
    idx(i,j)=(index);
    end
end
Fv.m =C3; 
% size(Fv.m)
Fv.index = idx;
end
