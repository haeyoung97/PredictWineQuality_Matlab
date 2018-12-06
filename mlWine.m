function quality = mlWine(trainXlsFileName, testXlsFileName, kenelFunction)
%MLWINE �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ

trainData = readtable(trainXlsFileName);
trainedModel = trainRegressionModel(trainData, kenelFunction);

testData = readtable(testXlsFileName);
quality = trainedModel.predictFcn(testData);

end

