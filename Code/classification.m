function [] = classification()
    data = jsondecode(fileread('features.json'));
    
    [~,~,raw] = xlsread('../Data/labels.xlsx','A1:C480');
    map = containers.Map(raw(:,1),raw(:,2));
    
    [r,~] = size(data.names);
    out = [];
    for i = 1:r
        out = [map(string(data.names(i)));out];
    end
    
    out = [];
    for i = 1:r
        out = [map(string(data.names(i)));out];
    end
    
    %HOG
        in = data.HOG_featurevectors(:,:);
        %sensitivity,specificity,precision,FPR,Accuracy,recall,F1
        [ res ] = helper(in, out, 10, 100);

        %PLOT
        plotter(res,'HOT');
   
    
    %DCT
        in = data.DCT_featurevectors(:,:);
        %sensitivity,specificity,precision,FPR,Accuracy,recall,F1
        [ res ] = helper(in,out,10, 100);

        %PLOT
        plotter(res,'DCT');

end