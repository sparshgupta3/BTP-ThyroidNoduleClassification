function Fv = DCT_feature(I)
    if size(I,3)==3
         I=rgb2gray(I);
    end
    
    I=im2double(I);

    IC = dct2(I);
    Fv = [];
    for j =1:300 
        for i = 1:300
            Fv = [Fv IC(i,j)];
        end
    end