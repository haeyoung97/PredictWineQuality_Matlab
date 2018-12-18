function quality = mlWine(trainXlsFileName, testXlsFileName)
%MLWINE Summary of this function goes here
%   Detailed explanation goes here

trainData = readtable(trainXlsFileName);
trainedModel = trainRegressionModel(trainData);

testData = readtable(testXlsFileName);
quality = trainedModel.predictFcn(testData);


end

