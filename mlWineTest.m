function mse = mlWineTest(trainXlsFileName, testXlsFileName, testResponseXlsFileName)
%MLWINETEST �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ

quality = mlWine(trainXlsFileName, testXlsFileName,'gaussian');
trueQuality = readtable(testResponseXlsFileName);

mse1 = mean((quality - trueQuality).^2);

quality = mlWine(trainXlsFileName, testXlsFileName,'linear');
trueQuality = readtable(testResponseXlsFileName);

mse2 = mean((quality - trueQuality).^2);

mseSet = [mse1 mse2];
[data, index] = sort(mseSet);



end

