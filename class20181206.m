%% training data & test data 만들기
% trainRegressionModel로 사전 변수값 가져오기
% trainData  & testData 엑셀 파일을 직접 만들어서 평균치를 구하자
a = readtable('White_Wine.xlsx');

inputTable = a;
predictorNames = {'FixAcid', 'VolAcid', 'CitAcid', 'ResSugar', 'Chlorides', 'FreeS02', 'TotalS02', 'Density', 'pH', 'Sulphates', 'Alcohol'};
predictors = inputTable(:, predictorNames);
response = inputTable.Quality;

% 홀드아웃 검증 설정
cvp = cvpartition(size(response, 1), 'Holdout', 0.2);
trainingPredictors = predictors(cvp.training, :);
trainingResponse = response(cvp.training, :); 
validationResponse = response(cvp.test, :);
validationPredictors = predictors(cvp.test, :);
    

trainData = trainingPredictors;
trainData.Quality = trainingResponse;
writetable(trainData, 'trainData3.xlsx');
testData = validationPredictors;
writetable(testData, 'testData3.xlsx');
testResoponseData = validationResponse;
writetable(table(testResoponseData), 'testResponseData3.xlsx');

%% mlWine 함수를 만든다
% quality = mlWine('trainData.xlsx','testData.xlsx');

%% mlWineTest 함수를 통해 mse를 얻어 test 해본다.
% 기본 데이터

mse = mlWineTest('trainData.xlsx','testData.xlsx', 'testResponseData.xlsx')
mse1 = mlWineTest('trainData1.xlsx','testData1.xlsx', 'testResponseData1.xlsx')
mse2 = mlWineTest('trainData2.xlsx','testData2.xlsx', 'testResponseData2.xlsx')
mse3 = mlWineTest('trainData3.xlsx','testData3.xlsx', 'testResponseData3.xlsx')


% % 로그 씌운 데이터
% trainData = trainingPredictors;
% testData = validationPredictors;
% 
% for i = 2:1:3920
%     trainData.ResSugar(i) = log10(trainData.ResSugar(i));
% end
% for i = 2:1:980
%     testData.ResSugar(i) = log10(testData.ResSugar(i));
% end
% 
% trainData.Quality = trainingResponse;
% writetable(trainData, 'trainData.xlsx');
% writetable(testData, 'testData.xlsx');
% testResoponseData = validationResponse;
% writetable(table(testResoponseData), 'testResponseData.xlsx');
% 
% mse2 = mlWineTest('trainData.xlsx','testData.xlsx', 'testResponseData.xlsx')

% Alchole 제외

%% mlWine 함수를 통해 최적화 하는 방법
% 1. 하이퍼파라미터 튜닝
    %  regressionSVM = fitrsvm() 함수 안 옵션들이 다양하다.
    % % fitrsvm 함수안 요소들을 코드화 하여 일일이 돌려봐야 최적을 찾아야 한다.
    % % 함수 호출 시 인자를 전달하여 test 시행 
    % 값을 바꿔 갈 때 경향성을 찾아봐야한다.
    
% 2. X - axis 
%  그래프가 내려가거나(negative) 올라가는(positive) 형상이 보일 때 영향력이 높다.

% 3. Actual Plot
% Actual plot을 이용하여  true response에 대해 얼마나 잘 맞추는지 확인
% residuals plot 확인
%  % Box plot 의 의미를 알아야 한다.

% 4. mix model
% 경우가 나눠져야 했다 -> X - axis로 경향성을 보고 판단
%  ex> 알코올이 얼마 이상은 이런 모델, 얼마 이하는 이런 모델

% 5. PCA option
% test data를 넣으면 잘 안맞는 이유 = overfitting
% PCA option을 넣었을 때 rmse or mse 가 높아 질 수 있지만, test data를 넣었을 때 낮아질 수 있다.


% 12월 18일 7시 시험
% 시험문제는 다음주에 알려준다
% 머신러닝은 무엇인가 
% 12월 17일 제출