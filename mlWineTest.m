function mse = mlWineTest(trainXlsFileName, testXlsFileName, testResponseXlsFileName)
%MLWINETEST 이 함수의 요약 설명 위치
%   자세한 설명 위치
mse = [];
%% hyper parameter tuning
%for KernerScale = 0.83 - 0.5 : 0.1 : 0.83 + 0.5
%   quality = mlWine(trainXlsFileName, testXlsFileName,KernerScale);
%  trueQuality = readtable(testResponseXlsFileName);
%
%    testMse = mean((quality - trueQuality).^2);
%    mse = [mse testMse];
%end

%% 여러개의 모델을 합쳐서 진행
%if alcohol > 5
%    quality = mlWine(trainXlsFileName, testXlsFileName,'linear');
%    trueQuality = readtable(testResponseXlsFileName);

%    mse2 = mean((quality - trueQuality).^2);
%else
%    quality = mlWine(trainXlsFileName, testXlsFileName,'linear');
%    trueQuality = readtable(testResponseXlsFileName);

%    mse2 = mean((quality - trueQuality).^2);
%end
%% 데이터를 합치거나 나눠서 평균값 또는 표준편차 값을 구하여 사용
% ex > Acid를 하나로 묶어서 새로운 데이터 형을 만들어본다

%% test
trueQuality = readtable(testResponseXlsFileName);
trueQuality = table2array(trueQuality);

quality = mlWine(trainXlsFileName, testXlsFileName,1);
testMse = mean((quality - trueQuality).^2);
mse = [mse testMse];

quality = mlWine(trainXlsFileName, testXlsFileName,2);
testMse =  mean((quality - trueQuality).^2);
mse = [mse testMse];

quality = mlWine(trainXlsFileName, testXlsFileName,0);
testMse =  mean((quality - trueQuality).^2);
mse = [mse testMse];
%%
% mseSet = [mse1 mse2];
% [data, index] = sort(mseSet);



end

