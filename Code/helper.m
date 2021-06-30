function [res] = helper(input, output, inc)
    idex = rankfeatures(input',output);
    [~,c] = size(input);

    outCount = arrayfun(@(x)length(find(output==x)),unique(output),'Uniform',false);
    outCount = cell2mat(outCount);

    if outCount(1) >= outCount(2)
        k = ceil(outCount(1)/outCount(2));
    else
        k = ceil(outCount(2)/outCount(1));
    end

    [input , output] = smote(input, [], k, 'Class', output);

    %sensitivity,specificity,precision,FPR,Accuracy,recall,F1
    res = [];

    for i=1:10
        n = inc;
        
        cv = cvpartition(size(input,1),'HoldOut',0.5);
        idx = cv.test;

        % Separate to training and test data
        dataTrain = input(~idx,:);
        dataTest  = input(idx,:);

        outTrain = output(~idx);
        outTest = output(idx);

        res1 = [];
        res2 = [];

        while n<=c && n<=5000
            disp([num2str(i),' ',num2str(n)]);
            dataTrainx = dataTrain(:, idex(1:n));
            dataTestx = dataTest(:, idex(1:n));

            [sensitivity,specificity,precision,FPR,Accuracy,recall,F1] = svm(dataTrainx, outTrain, dataTestx, outTest);
            res1 = [res1; [n,sensitivity,specificity,precision,FPR,Accuracy,recall,F1]];

            [sensitivity,specificity,precision,FPR,Accuracy,recall,F1] = svm(dataTestx, outTest, dataTrainx, outTrain);
            res2 = [res2; [n,sensitivity,specificity,precision,FPR,Accuracy,recall,F1]];

            n = n + inc;
        end

        if i==1
            res = (res1+res2)/2;
        else
            res = res + (res1+res2)/2;

        end
        
    end
    res = res/10;
end