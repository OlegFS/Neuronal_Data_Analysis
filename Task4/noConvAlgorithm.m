


%[shifts, spikesShifted] = shiftSpikes(data);
i=1;
%x = data(i).GalvoTraces(:);
%y = data(cells(i)).SpikeTraces(:);
%y = spikesShifted{i};
%fs = data(i).fps;
xF = filterTraces(x, fs);
[f,xLocks] = spikeExtraction(xF);
%[Locs,correct] = corrResp2(xF,y);

%SVMStruct = svmtrain(f',correct,'kernel_function','rbf')
for i=1:length(f)
ClassSpikes(i) = svmclassify(SVMStruct,f(:,i)');
end
%[~,xLocks] = findpeaks(double(xF));
spikeFlag = zeros(length(xF),1);
spikeFlag(xLocks(logical(ClassSpikes)))=1;
heightExtimate = predictHeight(xF(xLocks(logical(ClassSpikes))),spikeFlag);
% recontruct the data
spikeRate = zeros(length(y),1);
spikeRate(logical(spikeFlag)) = heightExtimate;
%corr(spikeRate,y)



%% Plot the classification result
t1= 1;
t2  = 100;
%[~,yLocks] = findpeaks(double(y));
[~,hLocks] = findpeaks(double(xF));
kk = zeros(length(xF),1);
kC = zeros(length(y),1);
kk(hLocks(logical(ClassSpikes)))=1;
kC(hLocks(logical(correct)))=1;
kk(kk==0)=NaN;
kC(kC==0)=NaN;
plot(xF(t1:t2)*10);hold on;
plot(kk(t1:t2),'or'); hold on;
plot(kC(t1:t2)+0.5,'ob'); hold on;
plot((y(t1:t2))+1)


%% Plot the spike reconstruction results result
plot(y(1:300)/2,'Color',[1 0.78 0.90 ],'linewidth',2); hold on;
plot(spikeRate(1:300),'-k','linewidth',1);
plot(xF(1:300)*7,'Color',[0.5 0.5 0.5]);
legend RealSpikes EstimatedSpikes CaTrace
title('Algorithm output')

