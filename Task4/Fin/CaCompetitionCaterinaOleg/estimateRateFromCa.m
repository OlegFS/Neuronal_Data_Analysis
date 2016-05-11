function inferredRate = estimateRateFromCa(trace, fs)
% Inferring the spike rate using the SVM to estimate the positions and
%regression to estimate the height.


% 1. prepare data
trace = double(trace);

% 2. filter calcium trace
xF = filterTraces(trace, fs);

% 3. extract calcium waveforms
[f,xLocks] = spikeExtraction(xF);

% 4. train classifier
load SVMStruct
for i=1:length(f)
ClassSpikes(i) = svmclassify(SVMStruct,f(:,i)');
end

% 5. detect calcium traces associated with spikes
spikeFlag = zeros(length(xF),1);
spikeFlag(xLocks(logical(ClassSpikes))) = 1;

% 6. estimate height of detected spikes
heightExtimate = predictHeight(xF(xLocks(logical(ClassSpikes))),spikeFlag);

% 7. reconstruct estimated spike rate
inferredRate = zeros(length(xF),1);
inferredRate(logical(spikeFlag)) = heightExtimate;

end