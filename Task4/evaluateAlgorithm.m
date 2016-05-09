
[shifts, spikesShifted] = shiftSpikes(data);

i=1;
x = data(i).GalvoTraces(:);
%y = data(cells(i)).SpikeTraces(:);
y = spikesShifted{i};
fs = data(i).fps;

% 1- Filter 
xF = filterTraces(x, fs);
% 2- Kernel estimation
% 3- Deconvolution
kern = exppdf(1:100,10);
h = deconvTraces(xF,y,kern);


% 4- Inward rectification - Now inside 
        % ROC curve OR percentage of false positive
        %falsePositives(h,y)
        %corr(h,y)
% 5- Spike Extraction - probably leave only f

[G,f] = spikeExtraction(h);

% 6 - Normalization
% 7 - Classification

[Locs,correct] = corrResp(h,y);

% SVM

for i=1:length(f)
ClassSpikes(i) =  svmclassify(SVMStruct,f(:,i)');
end

% Height extimate
[~,hLocks] = findpeaks(double(h));
spikeFlag = zeros(length(h),1);
spikeFlag(hLocks(logical(ClassSpikes)))=1;
heightExtimate = predictHeight(h(hLocks(logical(ClassSpikes))),spikeFlag);
% recontruct the data
spikeRate = zeros(length(y),1);
spikeRate(hLocks(logical(ClassSpikes))) = heightExtimate;
corr(spikeRate,y)