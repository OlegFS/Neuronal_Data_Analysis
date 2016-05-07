% 1- Filter 
xF = filterTraces(x, fs);
% 2- Kernel estimation
% 3- Deconvolution
kern = exppdf(1:100,10);
h = deconvTraces(xF,y,kern);
% 4- Inward rectification - Now inside 
        % ROC curve OR percentage of false positive
        falsePositives(h,y)
        corr(h,y)
% 5- Spike Extraction
s = spikeExtraction(h);
% 6 - Normalization
% 7 - Classification

corr = corrResp(h,y);

% Logistic Regression
B = logisticReg(s',corr)
%B  = mnrfit(s',categorical(corr))
for i =1:length(s)
p(i) = (sigmoid([B'*[0; s(:,i)]])>=0.5)';
end

% SVM
SVMStruct = svmtrain(s',corr)
for i=1:length(s)
Group(i) = svmclassify(SVMStruct,s(:,i)');
end


