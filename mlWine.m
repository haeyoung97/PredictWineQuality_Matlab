function quality = mlWine(trainXlsFileName, testXlsFileName, index)
%MLWINE 이 함수의 요약 설명 위치
%   자세한 설명 위치

trainData = readtable(trainXlsFileName);

%% 필요한 데이터를 만들어낸다
% 데이터의 균형이 맞지 않다면 정규화 하여 작업해본다.
%rawData = trainData.FixAcid;
%rawData = (rawData - min(rawData))/(max(rawData) - min(rawData));

% trainData.meanAcid = (trainData.CitAcid + trainData.FixAcid + trainData.VolAcid)
if index == 1
    trainedModel = trainRegressionModelEnsemble(trainData);
elseif index == 2
    trainedModel = trainRegressionModelEnsemblePCA(trainData);
else
    trainedModel = trainRegressionModelSVM(trainData);
end
testData = readtable(testXlsFileName);
quality = trainedModel.predictFcn(testData);

end

