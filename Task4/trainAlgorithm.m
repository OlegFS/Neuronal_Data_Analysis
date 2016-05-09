
[shifts, spikesShifted] = shiftSpikes(data);
H = {};
Y = {};
X = {};
Correct = {}; 
cell = [1 2 4 5 6 7 8 9 10]
i=1;
for i=1:length(cell)
X{i} = data(cell(i)).GalvoTraces(:);
%y = data(cells(i)).SpikeTraces(:);
Y{i} = spikesShifted{cell(i)};
fs = data(cell(i)).fps;
xF{i} = filterTraces(X{i}, fs);
[G,F{i}] = spikeExtraction(xF{i});
Correct{i} = corrResp2(xF,y);
end

for i=1:length(i)
y = [Y{1}; Y{2}; Y{3}; Y{4}; Y{5}; Y{6} ;Y{7}];
h = [H{1}; H{2}; H{3}; H{4}; H{5}; H{6} ;H{7}];

end

SVMStruct = svmtrain(f',correct,'kernel_function','rbf')
for i=1:length(f)
ClassSpikes(i) = svmclassify(SVMStruct,f(:,i)');
end

[~,xLocks] = findpeaks(double(xF));
spikeFlag = zeros(length(xF),1);
spikeFlag(xLocks(logical(ClassSpikes)))=1;
heightExtimate = predictHeight(xF(xLocks(logical(ClassSpikes))),spikeFlag);
% recontruct the data
spikeRate = zeros(length(y),1);
spikeRate(xLocks(logical(ClassSpikes))) = heightExtimate;
corr(spikeRate,y)
