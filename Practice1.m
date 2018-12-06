load('housePrices.mat');
houseTrain(:,9:10) = [];
houseTest(:,9:10) = [];

truePrice = houseTest(:,end);
houseTest(:,end)=[];
mdl = fitlm(houseTrain);
predPrice = mdl.predict(houseTest);

error = truePrice.MedianValue - predPrice;
stem(error)
sqrt(mean(error.^2))


%%
load('housePrices.mat');
