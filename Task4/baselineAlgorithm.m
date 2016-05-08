
cells = [ 1 2 4 5 7 8 9];
H = {};
Y = {};
for i =1:length(cells)
x = data(cells(i)).GalvoTraces(:);
y = data(cells(i)).SpikeTraces(:);
fs = data(cells(i)).fps;

% 1- Filter 
xF = filterTraces(x, fs);
% 2- Kernel estimation
% 3- Deconvolution
kern = exppdf(1:100,10);
h = deconvTraces(xF,y,kern);

H{i} = h;
Y{i} = y;
end
% 4- Inward rectification - Now inside 
        % ROC curve OR percentage of false positive
        %falsePositives(h,y)
        %corr(h,y)
% 5- Spike Extraction - probably leave only f
[s,G,f] = spikeExtraction(h);
% 6 - Normalization
% 7 - Classification

correct = corrResp(h,y);
% SVM
SVMStruct = svmtrain(f',correct)
for i=1:length(s)
ClassSpikes(i) = svmclassify(SVMStruct,f(:,i)');
end
% Height extimate

% recontruct the data
spikeRate = zeros(length(y),1);
spikeRate(ClassSpikes) = heightExtimate;



%% Plot the classification result
%[~,yLocks] = findpeaks(double(y));
[~,hLocks] = findpeaks(double(h));
kk = zeros(length(h),1);
kC = zeros(length(h),1);
kk(hLocks(ClassSpikes))=1;
kC(hLocks(correct))=1;
kk(kk==0)=NaN;
kC(kC==0)=NaN;
plot(h(1:100));hold on;
plot(kk(1:100),'or'); hold on;
plot(kC(1:100)+1,'ob'); hold on;
plot(y(1:100)+2)

%% Plot the ROC for SVM
[~,scores2] = resubPredict(MODEL);
[X,Y] = perfcurve(correct,scores2(:,2),1)
plot(X,Y); hold on
plot([0 1] ,[0 1],'-k')