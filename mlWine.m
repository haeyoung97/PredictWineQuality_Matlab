function quality = mlWine(trainXlsFileName, testXlsFileName, index,BasisFunction,KernelFunction,kfold)
%MLWINE 이 함수의 요약 설명 위치
%   자세한 설명 위치

trainData = readtable(trainXlsFileName);
trainData.ResSugar = log10(trainData.ResSugar);
%% 필요한 데이터를 만들어낸다
% 데이터의 균형이 맞지 않다면 정규화 하여 작업해본다.
%rawData = trainData.FixAcid;
%rawData = (rawData - min(rawData))/(max(rawData) - min(rawData));

% trainData.meanAcid = (trainData.CitAcid + trainData.FixAcid + trainData.VolAcid)
if index == 1
    trainedModel = trainRegressionModelEnsemble(trainData);
elseif index == 2
    trainedModel = trainRegressionModelEnsemblePCA(trainData);
elseif index == 3
    trainedModel = trainRegressionModelSVM(trainData,BasisFunction,KernelFunction);
elseif index == 4
     trainedModel = trainRegressionModelGauss(trainData,BasisFunction,KernelFunction,kfold);
elseif index == 5
     trainedModel = trainRegressionModelGaussPCA(trainData,BasisFunction,KernelFunction,kfold);
end
testData = readtable(testXlsFileName);
testData.ResSugar = log10(testData.ResSugar);
quality = trainedModel.predictFcn(testData);

end

