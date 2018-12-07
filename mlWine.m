function quality = mlWine(trainXlsFileName, testXlsFileName, index)
%MLWINE �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ

trainData = readtable(trainXlsFileName);

%% �ʿ��� �����͸� ������
% �������� ������ ���� �ʴٸ� ����ȭ �Ͽ� �۾��غ���.
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

