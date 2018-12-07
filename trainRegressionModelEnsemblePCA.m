function [trainedModel, validationRMSE] = trainRegressionModelEnsemblePCA(trainingData)
% [trainedModel, validationRMSE] = trainRegressionModel(trainingData)
% 훈련된 회귀 모델과 그 RMSE을(를) 반환합니다. 이 코드는 회귀 학습기 앱에서 훈련된 모델
% 을 다시 만듭니다. 생성된 코드를 사용하여 동일한 모델을 새 데이터로 훈련시키는 것을 자동
% 화하거나, 모델을 프로그래밍 방식으로 훈련시키는 방법을 익힐 수 있습니다.
%
%  입력값:
%      trainingData: 앱으로 가져온 것과 동일한 예측 변수와 응답 변수 열을 포함하는 테
%       이블입니다.
%
%  출력값:
%      trainedModel: 훈련된 회귀 모델이 포함된 구조체입니다. 이 구조체에는 훈련된 모
%       델에 대한 정보가 포함된 다양한 필드가 들어 있습니다.
%
%      trainedModel.predictFcn: 새 데이터를 사용하여 예측하기 위한 함수입니다.
%
%      validationRMSE: RMSE를 포함하는 double형입니다. 앱에서는 내역 목록에 각 모델
%       에 대한 RMSE가 표시됩니다.
%
% 새 데이터로 모델을 훈련시키려면 이 코드를 사용하십시오. 모델을 다시 훈련시키려면 명령줄
% 에서 원래 데이터나 새 데이터를 입력 인수 trainingData(으)로 사용하여 함수를 호출하십
% 시오.
%
% 예를 들어, 원래 데이터 세트 T(으)로 훈련된 회귀 모델을 다시 훈련시키려면 다음을 입력하
% 십시오.
%   [trainedModel, validationRMSE] = trainRegressionModel(T)
%
% 새 데이터 T2에서 반환된 'trainedModel'을(를) 사용하여 예측하려면 다음을 사용하십시
% 오.
%   yfit = trainedModel.predictFcn(T2)
%
% T2은(는) 적어도 훈련 중에 사용된 것과 동일한 예측 변수 열을 포함하는 테이블이어야 합니
% 다. 세부 정보를 보려면 다음을 입력하십시오.
%   trainedModel.HowToPredict

% MATLAB에서 2018-12-07 17:18:50에 자동 생성됨


% 예측 변수와 응답 변수 추출
% 이 코드는 모델을 훈련시키기에 적합한 형태로 데이터를
% 처리합니다.
inputTable = trainingData;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false];

% 예측 변수 행렬에 PCA를 적용합니다.
% 숫자형 예측 변수에 대해서만 PCA를 실행합니다. categorical형 예측 변수는 PCA를 거쳐도 전혀 변경되지 않습니다.
isCategoricalPredictorBeforePCA = isCategoricalPredictor;
numericPredictors = predictors(:, ~isCategoricalPredictor);
numericPredictors = table2array(varfun(@double, numericPredictors));
% PCA의 경우 'inf' 값은 누락된 데이터로 처리되어야 합니다.
numericPredictors(isinf(numericPredictors)) = NaN;
[pcaCoefficients, pcaScores, ~, ~, explained, pcaCenters] = pca(...
    numericPredictors);
% 원하는 크기의 분산을 설명하기에 충분한 성분 개수를 유지합니다.
explainedVarianceToKeepAsFraction = 95/100;
numComponentsToKeep = find(cumsum(explained)/sum(explained) >= explainedVarianceToKeepAsFraction, 1);
pcaCoefficients = pcaCoefficients(:,1:numComponentsToKeep);
predictors = [array2table(pcaScores(:,1:numComponentsToKeep)), predictors(:, isCategoricalPredictor)];
isCategoricalPredictor = [false(1,numComponentsToKeep), true(1,sum(isCategoricalPredictor))];

% 회귀 모델 훈련
% 이 코드는 모든 모델 옵션을 지정하고 모델을 훈련시킵니다.
template = templateTree(...
    'MinLeafSize', 8);
regressionEnsemble = fitrensemble(...
    predictors, ...
    response, ...
    'Method', 'Bag', ...
    'NumLearningCycles', 30, ...
    'Learners', template);

% 예측 함수를 사용하여 결과 구조체 생성
predictorExtractionFcn = @(t) t(:, predictorNames);
pcaTransformationFcn = @(x) [ array2table((table2array(varfun(@double, x(:, ~isCategoricalPredictorBeforePCA))) - pcaCenters) * pcaCoefficients), x(:,isCategoricalPredictorBeforePCA) ];
ensemblePredictFcn = @(x) predict(regressionEnsemble, x);
trainedModel.predictFcn = @(x) ensemblePredictFcn(pcaTransformationFcn(predictorExtractionFcn(x)));

% 추가적인 필드를 결과 구조체에 추가
trainedModel.RequiredVariables = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
trainedModel.PCACenters = pcaCenters;
trainedModel.PCACoefficients = pcaCoefficients;
trainedModel.RegressionEnsemble = regressionEnsemble;
trainedModel.About = '이 구조체는 회귀 학습기 R2018b에서 내보낸 훈련된 모델입니다.';
trainedModel.HowToPredict = sprintf('새 테이블 T를 사용하여 예측하려면 다음을 사용하십시오. \n yfit = c.predictFcn(T) \n여기서 ''c''를 이 구조체를 나타내는 변수의 이름(예: ''trainedModel'')으로 바꾸십시오. \n \n테이블 T는 다음에서 반환된 변수를 포함해야 합니다. \n c.RequiredVariables \n변수 형식(예: 행렬/벡터, 데이터형)은 원래 훈련 데이터와 일치해야 합니다. \n추가 변수는 무시됩니다. \n \n자세한 내용은 <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appregression_exportmodeltoworkspace'')">How to predict using an exported model</a>을(를) 참조하십시오.');

% 예측 변수와 응답 변수 추출
% 이 코드는 모델을 훈련시키기에 적합한 형태로 데이터를
% 처리합니다.
inputTable = trainingData;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;
isCategoricalPredictor = [false, false, false, false, false, false, false, false, false, false, false];

% 교차 검증 수행
KFolds = 5;
cvp = cvpartition(size(response, 1), 'KFold', KFolds);
% 예측값을 적절한 크기로 초기화
validationPredictions = response;
for fold = 1:KFolds
    trainingPredictors = predictors(cvp.training(fold), :);
    trainingResponse = response(cvp.training(fold), :);
    foldIsCategoricalPredictor = isCategoricalPredictor;
    
    % 예측 변수 행렬에 PCA를 적용합니다.
    % 숫자형 예측 변수에 대해서만 PCA를 실행합니다. categorical형 예측 변수는 PCA를 거쳐도 전혀 변경되지 않습니다.
    isCategoricalPredictorBeforePCA = foldIsCategoricalPredictor;
    numericPredictors = trainingPredictors(:, ~foldIsCategoricalPredictor);
    numericPredictors = table2array(varfun(@double, numericPredictors));
    % PCA의 경우 'inf' 값은 누락된 데이터로 처리되어야 합니다.
    numericPredictors(isinf(numericPredictors)) = NaN;
    [pcaCoefficients, pcaScores, ~, ~, explained, pcaCenters] = pca(...
        numericPredictors);
    % 원하는 크기의 분산을 설명하기에 충분한 성분 개수를 유지합니다.
    explainedVarianceToKeepAsFraction = 95/100;
    numComponentsToKeep = find(cumsum(explained)/sum(explained) >= explainedVarianceToKeepAsFraction, 1);
    pcaCoefficients = pcaCoefficients(:,1:numComponentsToKeep);
    trainingPredictors = [array2table(pcaScores(:,1:numComponentsToKeep)), trainingPredictors(:, foldIsCategoricalPredictor)];
    foldIsCategoricalPredictor = [false(1,numComponentsToKeep), true(1,sum(foldIsCategoricalPredictor))];
    
    % 회귀 모델 훈련
    % 이 코드는 모든 모델 옵션을 지정하고 모델을 훈련시킵니다.
    template = templateTree(...
        'MinLeafSize', 8);
    regressionEnsemble = fitrensemble(...
        trainingPredictors, ...
        trainingResponse, ...
        'Method', 'Bag', ...
        'NumLearningCycles', 30, ...
        'Learners', template);
    
    % 예측 함수를 사용하여 결과 구조체 생성
    pcaTransformationFcn = @(x) [ array2table((table2array(varfun(@double, x(:, ~isCategoricalPredictorBeforePCA))) - pcaCenters) * pcaCoefficients), x(:,isCategoricalPredictorBeforePCA) ];
    ensemblePredictFcn = @(x) predict(regressionEnsemble, x);
    validationPredictFcn = @(x) ensemblePredictFcn(pcaTransformationFcn(x));
    
    % 추가적인 필드를 결과 구조체에 추가
    
    % 검증 예측값 계산
    validationPredictors = predictors(cvp.test(fold), :);
    foldPredictions = validationPredictFcn(validationPredictors);
    
    % 예측값을 원래 순서대로 저장
    validationPredictions(cvp.test(fold), :) = foldPredictions;
end

% 검증 RMSE 계산
isNotMissing = ~isnan(validationPredictions) & ~isnan(response);
validationRMSE = sqrt(nansum(( validationPredictions - response ).^2) / numel(response(isNotMissing) ));
