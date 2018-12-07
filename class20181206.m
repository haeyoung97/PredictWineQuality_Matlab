%% training data & test data �����
% trainRegressionModel�� ���� ������ ��������
% trainData & testData ���� ������ ���� ���� ���ġ�� ������
a = readtable('White_Wine.xlsx');

inputTable = a;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;

% Ȧ��ƿ� ���� ����
cvp = cvpartition(size(response, 1), 'Holdout', 0.2);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :); 
validationResponse = response(cvp.test, :);
validationPredictors = predictors(cvp.test, :);
    

trainData = trainingPredictors;
trainData.Quality = trainingResponse;
writetable(trainData, 'trainData.xlsx');
testData = validationPredictors;
writetable(testData, 'testData.xlsx');
testResoponseData = validationResponse;
writetable(table(testResoponseData), 'testResponseData.xlsx');

%% mlWine �Լ��� �����
% quality = mlWine('trainData.xlsx','testData.xlsx');

%% mlWineTest �Լ��� ���� mse�� ��� test �غ���.
mse = mlWineTest('trainData.xlsx','testData.xlsx', 'testResponseData.xlsx')

%% mlWine �Լ��� ���� ����ȭ �ϴ� ���
% 1. �������Ķ���� Ʃ��
    %  regressionSVM = fitrsvm() �Լ� �� �ɼǵ��� �پ��ϴ�.
    % % fitrsvm �Լ��� ��ҵ��� �ڵ�ȭ �Ͽ� ������ �������� ������ ã�ƾ� �Ѵ�.
    % % �Լ� ȣ�� �� ���ڸ� �����Ͽ� test ���� 
    % ���� �ٲ� �� �� ���⼺�� ã�ƺ����Ѵ�.
    
% 2. X - axis 
%  �׷����� �������ų�(negative) �ö󰡴�(positive) ������ ���� �� ������� ����.

% 3. Actual Plot
% Actual plot�� �̿��Ͽ�  true response�� ���� �󸶳� �� ���ߴ��� Ȯ��
% residuals plot Ȯ��
%  % Box plot �� �ǹ̸� �˾ƾ� �Ѵ�.

% 4. mix model
% ��찡 �������� �ߴ� -> X - axis�� ���⼺�� ���� �Ǵ�
%  ex> ���ڿ��� �� �̻��� �̷� ��, �� ���ϴ� �̷� ��

% 5. PCA option
% test data�� ������ �� �ȸ´� ���� = overfitting
% PCA option�� �־��� �� rmse or mse �� ���� �� �� ������, test data�� �־��� �� ������ �� �ִ�.


% 12�� 18�� 7�� ����
% ���蹮���� �����ֿ� �˷��ش�
% �ӽŷ����� �����ΰ� 
% 12�� 17�� ����