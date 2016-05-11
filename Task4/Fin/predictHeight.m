function heightExtimate = predictHeight(h,spikeFlags)
% Estimate the spikes height via regression
% Betas estimated for the 10 training cells (3577 peaks)
Beta =  [6.7336 ;1.6425 ;   0.1220]
peaks = find(spikeFlags>0);
% Estimate the neighbours of each waveform as a regressor
for i=1:length(peaks)
Neighbours(i) = sum(spikeFlags(peaks(i)-4:peaks(i)+4)); % try 6
end
X = [ones(length(h),1) h Neighbours'];
heightExtimate = X*Beta; 
