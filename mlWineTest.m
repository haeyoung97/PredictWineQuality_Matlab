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

%% �������� ���� ���ļ� ����



%% test
trueQuality = readtable(testResponseXlsFileName);
trueQuality = table2array(trueQuality);

% % SVM
% for KernelScale =3.3 - 1.0 : 0.1 : 3.3 + 1.0
%    quality = mlWine(trainXlsFileName, testXlsFileName,3,'linear',KernelScale);
%     testMse = mean((quality - trueQuality).^2);
%     mse = [mse testMse];
% 
%     quality = mlWine(trainXlsFileName, testXlsFileName,3,'gaussian',KernelScale);
%     testMse = mean((quality - trueQuality).^2);
%     mse = [mse testMse];
% 
%     quality = mlWine(trainXlsFileName, testXlsFileName,3,'polynomial',KernelScale);
%     testMse = mean((quality - trueQuality).^2);
%     mse = [mse testMse];
% end
% 
% 
% % Ensemble
% quality = mlWine(trainXlsFileName, testXlsFileName,1,'temp', KernelScale);
% testMse = mean((quality - trueQuality).^2);
% mse = [mse testMse];
% 
% %EnsemblePCA
% quality = mlWine(trainXlsFileName, testXlsFileName,2,'temp', KernelScale);
% testMse =  mean((quality - trueQuality).^2);
% mse = [mse testMse];

% Gauss
% for i = 1:1:10
%     for kfold = 5:1:10
%         KernelScale = kernelFuncGauss(i);
%         quality = mlWine(trainXlsFileName, testXlsFileName,4,'none',KernelScale,kfold);
%         testMse = mean((quality - trueQuality).^2);
%         mse = [mse testMse];
% 
%         quality = mlWine(trainXlsFileName, testXlsFileName,4,'constant',KernelScale,kfold);
%         testMse = mean((quality - trueQuality).^2);
%         mse = [mse testMse];
% 
%         quality = mlWine(trainXlsFileName, testXlsFileName,4,'linear',KernelScale,kfold);
%         testMse = mean((quality - trueQuality).^2);
%         mse = [mse testMse];
% 
%         quality = mlWine(trainXlsFileName, testXlsFileName,4,'pureQuadratic',KernelScale,kfold);
%         testMse = mean((quality - trueQuality).^2);
%         mse = [mse testMse];
%     end
% end

% % GaussPCA
kernelFuncGauss = ["exponential" "squaredexponential" "matern32" "matern52" "rationalquadratic" "ardexponential" "ardsquaredexponential" "ardmatern32" "ardmatern52" "ardrationalquadratic"];
%for i = 1:1:10
 %    for kfold = 5:1:10
        kfold = 6;
        KernelScale = kernelFuncGauss(2);
%         quality = mlWine(trainXlsFileName, testXlsFileName,5,'none',KernelScale,kfold);
%         testMse = mean((quality - trueQuality).^2);
%         mse = [mse testMse];
% 
%         quality = mlWine(trainXlsFileName, testXlsFileName,5,'constant',KernelScale,kfold);
%         testMse = mean((quality - trueQuality).^2);
%         mse = [mse testMse];

        quality = mlWine(trainXlsFileName, testXlsFileName,4,'linear',KernelScale,kfold);
        testMse = mean((quality - trueQuality).^2);
        mse = [mse testMse];

%         quality = mlWine(trainXlsFileName, testXlsFileName,5,'pureQuadratic',KernelScale,kfold);
%         testMse = mean((quality - trueQuality).^2);
%         mse = [mse testMse];
%     end
%end

%%
% mseSet = [mse1 mse2];
% [data, index] = sort(mseSet);



end

