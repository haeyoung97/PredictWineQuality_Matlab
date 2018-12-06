function mse = mlWineTest(trainXlsFileName, testXlsFileName, testResponseXlsFileName)
%MLWINETEST 이 함수의 요약 설명 위치
%   자세한 설명 위치

quality = mlWine(trainXlsFileName, testXlsFileName,'gaussian');
trueQuality = readtable(testResponseXlsFileName);

mse1 = mean((quality - trueQuality).^2);

quality = mlWine(trainXlsFileName, testXlsFileName,'linear');
trueQuality = readtable(testResponseXlsFileName);

mse2 = mean((quality - trueQuality).^2);

mseSet = [mse1 mse2];
[data, index] = sort(mseSet);



end

