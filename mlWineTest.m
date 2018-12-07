function mse = mlWineTest(trainXlsFileName, testXlsFileName, testResponseXlsFileName)
%MLWINETEST �� �Լ��� ��� ���� ��ġ
%   �ڼ��� ���� ��ġ
mse = [];
%% hyper parameter tuning
%for KernerScale = 0.83 - 0.5 : 0.1 : 0.83 + 0.5
%   quality = mlWine(trainXlsFileName, testXlsFileName,KernerScale);
%  trueQuality = readtable(testResponseXlsFileName);
%
%    testMse = mean((quality - trueQuality).^2);
%    mse = [mse testMse];
%end

%% �������� ���� ���ļ� ����
%if alcohol > 5
%    quality = mlWine(trainXlsFileName, testXlsFileName,'linear');
%    trueQuality = readtable(testResponseXlsFileName);

%    mse2 = mean((quality - trueQuality).^2);
%else
%    quality = mlWine(trainXlsFileName, testXlsFileName,'linear');
%    trueQuality = readtable(testResponseXlsFileName);

%    mse2 = mean((quality - trueQuality).^2);
%end
%% �����͸� ��ġ�ų� ������ ��հ� �Ǵ� ǥ������ ���� ���Ͽ� ���
% ex > Acid�� �ϳ��� ��� ���ο� ������ ���� ������

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

