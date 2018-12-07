function [trainedModel, validationRMSE] = trainRegressionModelEnsemblePCA(trainingData)
% [trainedModel, validationRMSE] = trainRegressionModel(trainingData)
% �Ʒõ� ȸ�� �𵨰� �� RMSE��(��) ��ȯ�մϴ�. �� �ڵ�� ȸ�� �н��� �ۿ��� �Ʒõ� ��
% �� �ٽ� ����ϴ�. ������ �ڵ带 ����Ͽ� ������ ���� �� �����ͷ� �Ʒý�Ű�� ���� �ڵ�
% ȭ�ϰų�, ���� ���α׷��� ������� �Ʒý�Ű�� ����� ���� �� �ֽ��ϴ�.
%
%  �Է°�:
%      trainingData: ������ ������ �Ͱ� ������ ���� ������ ���� ���� ���� �����ϴ� ��
%       �̺��Դϴ�.
%
%  ��°�:
%      trainedModel: �Ʒõ� ȸ�� ���� ���Ե� ����ü�Դϴ�. �� ����ü���� �Ʒõ� ��
%       ���� ���� ������ ���Ե� �پ��� �ʵ尡 ��� �ֽ��ϴ�.
%
%      trainedModel.predictFcn: �� �����͸� ����Ͽ� �����ϱ� ���� �Լ��Դϴ�.
%
%      validationRMSE: RMSE�� �����ϴ� double���Դϴ�. �ۿ����� ���� ��Ͽ� �� ��
%       �� ���� RMSE�� ǥ�õ˴ϴ�.
%
% �� �����ͷ� ���� �Ʒý�Ű���� �� �ڵ带 ����Ͻʽÿ�. ���� �ٽ� �Ʒý�Ű���� �����
% ���� ���� �����ͳ� �� �����͸� �Է� �μ� trainingData(��)�� ����Ͽ� �Լ��� ȣ���Ͻ�
% �ÿ�.
%
% ���� ���, ���� ������ ��Ʈ T(��)�� �Ʒõ� ȸ�� ���� �ٽ� �Ʒý�Ű���� ������ �Է���
% �ʽÿ�.
%   [trainedModel, validationRMSE] = trainRegressionModel(T)
%
% �� ������ T2���� ��ȯ�� 'trainedModel'��(��) ����Ͽ� �����Ϸ��� ������ ����Ͻʽ�
% ��.
%   yfit = trainedModel.predictFcn(T2)
%
% T2��(��) ��� �Ʒ� �߿� ���� �Ͱ� ������ ���� ���� ���� �����ϴ� ���̺��̾�� �մ�
% ��. ���� ������ ������ ������ �Է��Ͻʽÿ�.
%   trainedModel.HowToPredict

% MATLAB���� 2018-12-07 17:18:50�� �ڵ� ������


% ���� ������ ���� ���� ����
% �� �ڵ�� ���� �Ʒý�Ű�⿡ ������ ���·� �����͸�
% ó���մϴ�.
inputTable = trainingData;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false];

% ���� ���� ��Ŀ� PCA�� �����մϴ�.
% ������ ���� ������ ���ؼ��� PCA�� �����մϴ�. categorical�� ���� ������ PCA�� ���ĵ� ���� ������� �ʽ��ϴ�.
isCategoricalPredictorBeforePCA = isCategoricalPredictor;
numericPredictors = predictors(:, ~isCategoricalPredictor);
numericPredictors = table2array(varfun(@double, numericPredictors));
% PCA�� ��� 'inf' ���� ������ �����ͷ� ó���Ǿ�� �մϴ�.
numericPredictors(isinf(numericPredictors)) = NaN;
[pcaCoefficients, pcaScores, ~, ~, explained, pcaCenters] = pca(...
    numericPredictors);
% ���ϴ� ũ���� �л��� �����ϱ⿡ ����� ���� ������ �����մϴ�.
explainedVarianceToKeepAsFraction = 95/100;
numComponentsToKeep = find(cumsum(explained)/sum(explained) >= explainedVarianceToKeepAsFraction, 1);
pcaCoefficients = pcaCoefficients(:,1:numComponentsToKeep);
predictors = [array2table(pcaScores(:,1:numComponentsToKeep)), predictors(:, isCategoricalPredictor)];
isCategoricalPredictor = [false(1,numComponentsToKeep), true(1,sum(isCategoricalPredictor))];

% ȸ�� �� �Ʒ�
% �� �ڵ�� ��� �� �ɼ��� �����ϰ� ���� �Ʒý�ŵ�ϴ�.
template = templateTree(...
    'MinLeafSize', 8);
regressionEnsemble = fitrensemble(...
    predictors, ...
    response, ...
    'Method', 'Bag', ...
    'NumLearningCycles', 30, ...
    'Learners', template);

% ���� �Լ��� ����Ͽ� ��� ����ü ����
predictorExtractionFcn = @(t) t(:, predictorNames);
pcaTransformationFcn = @(x) [ array2table((table2array(varfun(@double, x(:, ~isCategoricalPredictorBeforePCA))) - pcaCenters) * pcaCoefficients), x(:,isCategoricalPredictorBeforePCA) ];
ensemblePredictFcn = @(x) predict(regressionEnsemble, x);
trainedModel.predictFcn = @(x) ensemblePredictFcn(pcaTransformationFcn(predictorExtractionFcn(x)));

% �߰����� �ʵ带 ��� ����ü�� �߰�
trainedModel.RequiredVariables = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
trainedModel.PCACenters = pcaCenters;
trainedModel.PCACoefficients = pcaCoefficients;
trainedModel.RegressionEnsemble = regressionEnsemble;
trainedModel.About = '�� ����ü�� ȸ�� �н��� R2018b���� ������ �Ʒõ� ���Դϴ�.';
trainedModel.HowToPredict = sprintf('�� ���̺� T�� ����Ͽ� �����Ϸ��� ������ ����Ͻʽÿ�. \n yfit = c.predictFcn(T) \n���⼭ ''c''�� �� ����ü�� ��Ÿ���� ������ �̸�(��: ''trainedModel'')���� �ٲٽʽÿ�. \n \n���̺� T�� �������� ��ȯ�� ������ �����ؾ� �մϴ�. \n c.RequiredVariables \n���� ����(��: ���/����, ��������)�� ���� �Ʒ� �����Ϳ� ��ġ�ؾ� �մϴ�. \n�߰� ������ ���õ˴ϴ�. \n \n�ڼ��� ������ <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appregression_exportmodeltoworkspace'')">How to predict using an exported model</a>��(��) �����Ͻʽÿ�.');

% ���� ������ ���� ���� ����
% �� �ڵ�� ���� �Ʒý�Ű�⿡ ������ ���·� �����͸�
% ó���մϴ�.
inputTable = trainingData;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false];

% ���� ���� ����
KFolds = 5;
cvp = cvpartition(size(response, 1), 'KFold', KFolds);
% �������� ������ ũ��� �ʱ�ȭ
validationPredictions = response;
for fold = 1:KFolds
    trainingPredictors = predictors(cvp.training(fold), :);
    trainingResponse = response(cvp.training(fold), :);
    foldIsCategoricalPredictor = isCategoricalPredictor;
    
    % ���� ���� ��Ŀ� PCA�� �����մϴ�.
    % ������ ���� ������ ���ؼ��� PCA�� �����մϴ�. categorical�� ���� ������ PCA�� ���ĵ� ���� ������� �ʽ��ϴ�.
    isCategoricalPredictorBeforePCA = foldIsCategoricalPredictor;
    numericPredictors = trainingPredictors(:, ~foldIsCategoricalPredictor);
    numericPredictors = table2array(varfun(@double, numericPredictors));
    % PCA�� ��� 'inf' ���� ������ �����ͷ� ó���Ǿ�� �մϴ�.
    numericPredictors(isinf(numericPredictors)) = NaN;
    [pcaCoefficients, pcaScores, ~, ~, explained, pcaCenters] = pca(...
        numericPredictors);
    % ���ϴ� ũ���� �л��� �����ϱ⿡ ����� ���� ������ �����մϴ�.
    explainedVarianceToKeepAsFraction = 95/100;
    numComponentsToKeep = find(cumsum(explained)/sum(explained) >= explainedVarianceToKeepAsFraction, 1);
    pcaCoefficients = pcaCoefficients(:,1:numComponentsToKeep);
    trainingPredictors = [array2table(pcaScores(:,1:numComponentsToKeep)), trainingPredictors(:, foldIsCategoricalPredictor)];
    foldIsCategoricalPredictor = [false(1,numComponentsToKeep), true(1,sum(foldIsCategoricalPredictor))];
    
    % ȸ�� �� �Ʒ�
    % �� �ڵ�� ��� �� �ɼ��� �����ϰ� ���� �Ʒý�ŵ�ϴ�.
    template = templateTree(...
        'MinLeafSize', 8);
    regressionEnsemble = fitrensemble(...
        trainingPredictors, ...
        trainingResponse, ...
        'Method', 'Bag', ...
        'NumLearningCycles', 30, ...
        'Learners', template);
    
    % ���� �Լ��� ����Ͽ� ��� ����ü ����
    pcaTransformationFcn = @(x) [ array2table((table2array(varfun(@double, x(:, ~isCategoricalPredictorBeforePCA))) - pcaCenters) * pcaCoefficients), x(:,isCategoricalPredictorBeforePCA) ];
    ensemblePredictFcn = @(x) predict(regressionEnsemble, x);
    validationPredictFcn = @(x) ensemblePredictFcn(pcaTransformationFcn(x));
    
    % �߰����� �ʵ带 ��� ����ü�� �߰�
    
    % ���� ������ ���
    validationPredictors = predictors(cvp.test(fold), :);
    foldPredictions = validationPredictFcn(validationPredictors);
    
    % �������� ���� ������� ����
    validationPredictions(cvp.test(fold), :) = foldPredictions;
end

% ���� RMSE ���
isNotMissing = ~isnan(validationPredictions) & ~isnan(response);
validationRMSE = sqrt(nansum(( validationPredictions - response ).^2) / numel(response(isNotMissing) ));
