function [] = preprocess(path)
    file_area = dir(string(path) + '*.jpg');
    num = length(file_area);

    for k=1:num
        filename = fullfile(file_area(k).folder,file_area(k).name);
        [~,name_test,ext] = fileparts(filename);

        I1 = imread(filename);

        I2 = im2bw(I1,0.05);

        I3 = bwconncomp(I2);
        numOfPixels = cellfun(@numel,I3.PixelIdxList);
        [~,indexOfMax] = max(numOfPixels);

        biggest = zeros(size(I2));
        biggest(I3.PixelIdxList{indexOfMax}) = 1;

        xmin = [9999,0];
        xmax = [0,0];
        ymin = [0,9999];
        ymax = [0,0];

        [r,c] = size(biggest);
        for x = 1:r
            for y = 1:c
                if biggest(x,y) == 1
                    if x < xmin(1)
                       xmin = [x,y];
                    end
                    if x > xmax(1)
                       xmax = [x,y];
                    end
                    if y < ymin(2)
                       ymin = [x,y];
                    end 
                    if y > ymax(2)
                       ymax = [x,y];
                    end
                end
            end
        end

        out = imcrop(I1,[ymin(2)+1,xmin(1)+1,ymax(2)-ymin(2)-1,xmax(1)-xmin(1)-1]);
        out=rgb2gray(out);
        out=im2double(out);
        
        I = adapthisteq(out,'NumTiles',[8,8]);
        out = adapthisteq(I,'NumTiles',[4,4]);
        
        out = imresize(out,[300,300]);
        
        newimagename = '../Data/datapre/' + string(name_test) + string(ext);
        imwrite(out,newimagename);

    end
end