%%

load('/Users/olegvinogradov/Documents/MATLAB/Neuronal_Data_Analysis/Task4/TrainingData.mat');
%% PRecrocessing

Y = {};
X = {};
Correct = {}; 
XF = {};
F = {};
cell = [1 2 3 4 6 7 8 9 10];
i=1;
for i=1:9
X{i} = circshift(data(cell(i)).GalvoTraces(:),-1);
Y{i} = data(cell(i)).SpikeTraces(:);
fs = data(cell(i)).fps;
XF{i} = filterTraces(X{i}, fs);
F{i} = spikeExtraction(XF{i});
Correct{i} = corrResp2(XF{i},Y{i});
end
%%


y = [Y{1}; Y{2}; Y{3}; Y{4}; Y{5}; Y{6} ;Y{7}; Y{8}; Y{9}];
xF = [XF{1}; XF{2}; XF{3}; XF{4}; XF{5}; XF{6} ;XF{7}; XF{8}; XF{9}];
f = [F{1} F{2} F{3} F{4} F{5} F{6} F{7} F{8} F{9}];
correct = [Correct{1}; Correct{2}; Correct{3}; Correct{4};...
    Correct{5}; Correct{6} ;Correct{7};  Correct{8}; Correct{9}];
%% Training
%% Extract features
f = f(1:16,:);
Fe = zeros(84,length(f));
Fe(1,:)= moment(f,1);
Fe(2,:)=moment(f,2);
Fe(3,:)=moment(f,3);
Fe(4,:)=moment(f,4);
for i=1:length(f)
SW(i,:)= reshape(swt(f(:,i),4,'haar'),1,5*16);
end
Fe(6:85,:) = SW';
%%
%SVM = fitcsvm(Fe',correct,'KernelScale','auto','Standardize',true,'KernelFunction','polynomial') %svmtrain
for i=1:length(f)
ClassSpikes(i) = predict(SVM,Fe(:,i)'); %svmclassify
end

[xPeak,xLocks] = findpeaks(double(xF));
spikeFlag = zeros(length(xF),1);
spikeFlag(xLocks(logical(ClassSpikes)))=1;
%spikeFlag(xLocks(logical(xPeak)))=1;
heightExtimate = predictHeight(xF(xLocks(logical(ClassSpikes))),spikeFlag);
% recontruct the data
spikeRate = zeros(length(y),1);
spikeRate(xLocks(logical(ClassSpikes))) =heightExtimate;%yfit%xF(xLocks(logical(ClassSpikes)))*100;

spikeRate(spikeRate<=0.5) = ceil(spikeRate(spikeRate<=0.5)); % round values
spikeRate(spikeRate>0.5) = round(spikeRate(spikeRate>0.5));
corr(spikeRate,y)

%%
findpeaks(xF(2400:2600))
hold on;plot(y(2400:2600)/40);
plot(spikeFlag(2400:2600)/10,'ko');

%%
plot(spikeRate(:))
hold on;plot(y(:)+10);

