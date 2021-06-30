function [] = features(path)
    file_area = dir(string(path) + '*.jpg');
    num = length(file_area);

    names = [];
    HOG_featurevectors = [];
    DCT_featurevectors = [];
    
    for k=1:num
        filename = fullfile(file_area(k).folder,file_area(k).name);
        [~,name_test, ~] = fileparts(filename);
        
        I = imread(filename);

        names = [string(name_test) names];
        HOG_featurevectors = [[HOG_Comp_Cell_sigma(I, 2.5)] ; HOG_featurevectors];
        DCT_featurevectors = [[DCT_feature(I)] ; DCT_featurevectors];

        disp(k);
    end
    
    data_struct = struct('names',names,'HOG_featurevectors',HOG_featurevectors,'DCT_featurevectors',DCT_featurevectors);
    data_json = jsonencode(data_struct);

    fileID = fopen('features.json','w');
    fprintf(fileID,'%s',data_json);
 
    fclose(fileID);
end