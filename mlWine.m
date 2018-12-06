function quality = mlWine(trainXlsFileName, testXlsFileName, kenelFunction)
%MLWINE 이 함수의 요약 설명 위치
%   자세한 설명 위치

trainData = readtable(trainXlsFileName);
trainedModel = trainRegressionModel(trainData, kenelFunction);

testData = readtable(testXlsFileName);
quality = trainedModel.predictFcn(testData);

end

