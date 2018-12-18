function quality = mlWine(trainXlsFileName, testXlsFileName, index,BasisFunction,KernelFunction,kfold)
%MLWINE �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ

trainData = readtable(trainXlsFileName);
trainData.ResSugar = log10(trainData.ResSugar);
%% �ʿ��� �����͸� ������
% �������� ������ ���� �ʴٸ� ����ȭ �Ͽ� �۾��غ���.
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

