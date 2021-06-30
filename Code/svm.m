function [sensitivity,specificity,precision,FPR,Accuracy,recall,F1] = svm(dataTrain,outTrain, dataTest, outTest)

%     Model =  fitcsvm(dataTrain,outTrain, 'KernelFunction', 'polynomial');
    Model =  fitcsvm(dataTrain,outTrain);
        
    [label,~] = predict(Model,dataTest);
    
    tp = sum((label == 1) & (outTest == 1));
    fp = sum((label == 1) & (outTest == 2));
    fn = sum((label == 2) & (outTest == 1));
    tn = sum((label == 2) & (outTest == 2));
    sensitivity = tp/(tp + fn);  %TPR
    specificity = tn/(tn + fp);  %TNR
    precision = tp / (tp + fp);
    FPR = fp/(tn+fp);
    Accuracy = (tp+tn)./(tp+fp+tn+fn);
    recall = tp / (tp + fn);
    F1 = (2 * precision * recall) / (precision + recall);