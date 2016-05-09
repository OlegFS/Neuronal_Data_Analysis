

[shifts, spikesShifted] = shiftSpikes(data);
cells = [ 1 2 4 5 7 8 9];
H = {};
Y = {};
i=1;
for i =1:length(cells)
x = data(cells(i)).GalvoTraces(:);
%y = data(cells(i)).SpikeTraces(:);
y = spikesShifted{cells(i)};
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
for i=1:length(cells)
[G,F{i}] = spikeExtraction(H{i});
end
% 6 - Normalization
% 7 - Classification
for i =1:length(cells)
[Locs,Correct{i}] = corrResp(H{i},Y{i});
end
% SVM
f = [F{1} F{2} F{3} F{4} F{5} F{6} F{7}];
correct = [Correct{1}; Correct{2}; Correct{3}; Correct{4};...
    Correct{5}; Correct{6} ;Correct{7}];
y = [Y{1}; Y{2}; Y{3}; Y{4}; Y{5}; Y{6} ;Y{7}];
h = [H{1}; H{2}; H{3}; H{4}; H{5}; H{6} ;H{7}];


SVMStruct = svmtrain(f',correct,'kernel_function','rbf')
for i=1:length(f)
ClassSpikes(i) = svmclassify(SVMStruct,f(:,i)');
end

SVMModel = fitcsvm(f',correct)
for i=1:length(f)
ClassSpikes(i) =  svmclassify(SVMStruct,f(:,i)');
end

% Height extimate
spikeFlag = zeros(length(h),1);
spikeFlag(hLocks(logical(ClassSpikes)))=1;
heightExtimate = predictHeight(h(hLocks(logical(ClassSpikes))),spikeFlag);
% recontruct the data
spikeRate = zeros(length(y),1);
spikeRate(hLocks(logical(ClassSpikes))) = heightExtimate;
corr(spikeRate,y)

%% Plot the classification result
t1= 400;
t2  = 500;
%[~,yLocks] = findpeaks(double(y));
[~,hLocks] = findpeaks(double(h));
kk = zeros(length(h),1);
kC = zeros(length(y),1);
kk(hLocks(logical(ClassSpikes)))=1;
kC(hLocks(logical(correct)))=1;
kk(kk==0)=NaN;
kC(kC==0)=NaN;
plot(h(t1:t2));hold on;
plot(kk(t1:t2),'or'); hold on;
plot(kC(t1:t2)+1,'ob'); hold on;
plot(y(t1:t2)+2)

%% Plot the ROC for SVM
[~,scores2] = resubPredict(SVMStruct);
[X,Y] = perfcurve(correct,scores2(:,2),1)
plot(X,Y); hold on
plot([0 1] ,[0 1],'-k')

%% 



