
[shifts, spikesShifted] = shiftSpikes(data);
H = {};
Y = {};
X = {};
Correct = {}; 
XF = {};
F = {};
cell = [1 2 4 5 6 7 8 9 10]
i=1;
for i=1:length(cell)
X{i} = data(cell(i)).GalvoTraces(:);
%y = data(cells(i)).SpikeTraces(:);
Y{i} = spikesShifted{cell(i)};
fs = data(cell(i)).fps;
XF{i} = filterTraces(X{i}, fs);
F{i} = spikeExtraction(XF{i});
Correct{i} = corrResp2(XF{i},Y{i});
end


y = [Y{1}; Y{2}; Y{3}; Y{4}; Y{5}; Y{6} ;Y{7}; Y{8}; Y{9}];
xF = [XF{1}; XF{2}; XF{3}; XF{4}; XF{5}; XF{6} ;XF{7}; XF{8}; XF{9}];
f = [F{1} F{2} F{3} F{4} F{5} F{6} F{7} F{8} F{9}];
correct = [Correct{1}; Correct{2}; Correct{3}; Correct{4};...
    Correct{5}; Correct{6} ;Correct{7};  Correct{8}; Correct{9}];


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

