function [trainedModel, validationRMSE] = trainRegressionModelSVM(trainingData)
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

% MATLAB���� 2018-12-07 17:08:19�� �ڵ� ������


% ���� ������ ���� ���� ����
% �� �ڵ�� ���� �Ʒý�Ű�⿡ ������ ���·� �����͸�
% ó���մϴ�.
inputTable = trainingData;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false];

% ȸ�� �� �Ʒ�
% �� �ڵ�� ��� �� �ɼ��� �����ϰ� ���� �Ʒý�ŵ�ϴ�.
responseScale = iqr(response);
if ~isfinite(responseScale) || responseScale == 0.0
    responseScale = 1.0;
end
boxConstraint = responseScale/1.349;
epsilon = responseScale/13.49;
regressionSVM = fitrsvm(...
    predictors, ...
    response, ...
    'KernelFunction', 'gaussian', ...
    'PolynomialOrder', [], ...
    'KernelScale', 3.3, ...
    'BoxConstraint', boxConstraint, ...
    'Epsilon', epsilon, ...
    'Standardize', true);

% ���� �Լ��� ����Ͽ� ��� ����ü ����
predictorExtractionFcn = @(t) t(:, predictorNames);
svmPredictFcn = @(x) predict(regressionSVM, x);
trainedModel.predictFcn = @(x) svmPredictFcn(predictorExtractionFcn(x));

% �߰����� �ʵ带 ��� ����ü�� �߰�
trainedModel.RequiredVariables = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
trainedModel.RegressionSVM = regressionSVM;
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
    
    % ȸ�� �� �Ʒ�
    % �� �ڵ�� ��� �� �ɼ��� �����ϰ� ���� �Ʒý�ŵ�ϴ�.
    responseScale = iqr(trainingResponse);
    if ~isfinite(responseScale) || responseScale == 0.0
        responseScale = 1.0;
    end
    boxConstraint = responseScale/1.349;
    epsilon = responseScale/13.49;
    regressionSVM = fitrsvm(...
        trainingPredictors, ...
        trainingResponse, ...
        'KernelFunction', 'gaussian', ...
        'PolynomialOrder', [], ...
        'KernelScale', 3.3, ...
        'BoxConstraint', boxConstraint, ...
        'Epsilon', epsilon, ...
        'Standardize', true);
    
    % ���� �Լ��� ����Ͽ� ��� ����ü ����
    svmPredictFcn = @(x) predict(regressionSVM, x);
    validationPredictFcn = @(x) svmPredictFcn(x);
    
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
