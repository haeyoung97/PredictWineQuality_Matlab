%% training data & test data �����
% trainRegressionModel�� ���� ������ ��������
% trainData & testData ���� ������ ���� ���� ���ġ�� ������
a = readtable('White_Wine.xlsx');
trainRegressionModel(a);
trainData = trainingPredictors;
trainData.Quality = trainingResponse;
writhetable(trainData, 'trainData.xlsx');
testData = validationPredictors;
writhetable(testData, 'testData.xlsx');
testResoponseData = validationResponse;
writhetable(table(testResoponseData), 'testResponseData.xlsx');

%% mlWine �Լ��� �����

%% mlWineTest �Լ��� ���� mse�� ��� test �غ���.

%% mlWine �Լ��� ���� ����ȭ �ϴ� ���
% 1. �������Ķ���� Ʃ��
    %  regressionSVM = fitrsvm() �Լ� �� �ɼǵ��� �پ��ϴ�.
    % % fitrsvm �Լ��� ��ҵ��� �ڵ�ȭ �Ͽ� ������ �������� ������ ã�ƾ� �Ѵ�.
    % % �Լ� ȣ�� �� ���ڸ� �����Ͽ� test ���� 
   
% 2. X - axis 
%  �׷����� �������ų�(negative) �ö󰡴�(positive) ������ ���� �� ������� ����.

% 3. Actual Plot
% Actual plot�� �̿��Ͽ�  true response�� ���� �󸶳� �� ���ߴ��� Ȯ��
% residuals plot Ȯ��
%  % Box plot �� �ǹ̸� �˾ƾ� �Ѵ�.

% 4. mix model
% ��찡 �������� �ߴ� -> X - axis�� ���⼺�� ���� �Ǵ�
%  ex> ���ڿ��� �� �̻��� �̷� ��, �� ���ϴ� �̷� ��

% 12�� 18�� 7�� ����
% ���蹮���� �����ֿ� �˷��ش�
% �ӽŷ����� �����ΰ� 
% 12�� 17�� ����