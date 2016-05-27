function inferredRate = estimateRateFromCa(trace, fs,SVM)
% Inferring the spike rate using the SVM to estimate the positions and
%regression to estimate the height.


% 1. prepare data
trace = double(trace);
trace = circshift(trace,-1);
trace(end) = mean(trace);
% 2. filter calcium trace
xF = filterTraces(trace, fs);

% 3. extract calcium waveforms
[f,xLocks] = spikeExtraction(xF);
% Extact features
Fe = extractWFeatures(f); 
% 4. Predict by SVM

% 4. train classifier
load SVMStruct

for i=1:length(f)
ClassSpikes(i) = predict(SVM,Fe(:,i)');
end

% 5. detect calcium traces associated with spikes
spikeFlag = zeros(length(xF),1);
spikeFlag(xLocks(logical(ClassSpikes))) = 1;
[xPeak,xLocks] = findpeaks(double(xF));
% 6. estimate height of detected spikes
heightExtimate = predictHeight(xF(xLocks(logical(ClassSpikes))),spikeFlag);

% 7. reconstruct estimated spike rate
inferredRate = zeros(length(xF),1);
%inferredRate(logical(spikeFlag)) = xPeak(logical(ClassSpikes))*10;
inferredRate(logical(spikeFlag)) =  heightExtimate*10;
inferredRate(logical(spikeFlag)) = heightExtimate;

inferredRate(inferredRate<=0.5) = ceil(inferredRate(inferredRate<=0.5)); % round values
inferredRate(inferredRate>0.5) = round(inferredRate(inferredRate>0.5));