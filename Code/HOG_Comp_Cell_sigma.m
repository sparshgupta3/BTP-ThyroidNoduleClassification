 function [feature] = HOG_Comp_Cell_sigma(im,sigma)
%   im = imresize(im,[128 128],'bicubic');
% The given code finds the HOT feature vector for any given image. HOT
% feature vector/descriptor can then be used for detection of any
% particular object. The Matlab code provides the exact implementation of
% the formation of HOG feature vector as detailed in the paper "Pedestrian
% detection using HOG" by Dalal and Triggs

% INPUT => im (input image)
% OUTPUT => HOT feature vector for that particular image

% Example: Running the code
%  im = adapthisteq(im,'NumTiles',[16,16]);
%  im = adapthisteq(im,'NumTiles',[8,8]);
%  im = adapthisteq(im,'NumTiles',[4,4]);

% Convert RGB iamge to grayscale
if size(im,3)==3
    im=rgb2gray(im);
end
im=im2double(im);
[Fv] = HOLG(im,sigma);
angle = (Fv.index);
magnitude = Fv.m;
m1 = max(magnitude(:));
m2 = min(magnitude(:));
magnitude =(magnitude-m2)./(m1-m2);

size(angle);

% Remove redundant pixels in an image. 
angle(isnan(angle))=0;
magnitude(isnan(magnitude))=0;
s= size(angle);

for W = [16]
    W1 = W;
    W2 =W;
s1 =fix(s(1)/W1);
s2 = fix(s(2)/W2);
x1 = mod(s(1),W1);
x2 = mod(s(2),W2);
i1 = 0;

 feature=[];
 
for i =1:s1:s(1)-x1-s1
    i1 = i1+1;
    j1 = 0;
    for j = 1:s2:s(2)-x2-s2
        j1 = j1+1;       
        ang_patch{i1,j1} = angle(i:1:i+2*s1-1,j:1:j+2*s2-1);
        size(ang_patch{i1,j1});
        mag_patch{i1,j1} = magnitude(i:1:i+2*s1-1,j:1:j+2*s2-1);
        [Blockhistogram]= patchformation(ang_patch{i1,j1},mag_patch{i1,j1},2);
        Blockhistogram = Blockhistogram/sqrt(norm(Blockhistogram)^2+.001); 
        feature=[feature Blockhistogram]; 
    end
end
end

 end

 function [histr]= patchformation(angle,magnitude,W)

    W1 = W;
    W2 =W;
    s = size(angle);
s1 =fix(s(1)/W1);
 s2 = fix(s(2)/W2);
 x1 = mod(s(1),W1);
 x2 = mod(s(2),W2);
 i1 = 0;
 histr =[];

for i =1:s1:s(1)-x1
    i1 = i1+1;
    j1 = 0;
    for j = 1:s2:s(2)-x2
        j1 = j1+1;       
        ang_patch{i1,j1} = angle(i:1:i+s1-1,j:1:j+s2-1);
        mag_patch{i1,j1} = magnitude(i:1:i+s1-1,j:1:j+s2-1); 
        histr = [histr cellhistogram(ang_patch{i1,j1},mag_patch{i1,j1})];
    end
end
end





 function histr = cellhistogram(ang_patch12,mag_patch12)
                histr  =zeros(1,8);
                size(ang_patch12);
                for p=1:size(ang_patch12,1)
                    for q=1:size(ang_patch12,2)                       
                        alpha= ang_patch12(p,q);
                        histr(ang_patch12(p,q)+1)=histr(ang_patch12(p,q)+1)+1+mag_patch12(p,q);  
                        
                    end
            end
 histr= histr/sqrt(norm( histr)^2+.001); 

end