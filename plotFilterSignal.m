function plotFilterSignal(raw, filtered, Fs, s)
% ** function plotFilterSignal(x)
%   Plots a segment of the raw signal and the filtered signal.
%   Automatically chooses a segment that contains spikes, using
%   the output 's' of function detectSpikes.
%   Inputs:
%       'raw', matrix of raw data
%       'filtered', matrix of filtered data
%       'Fs', sampling frequency
%       's', matrix of samples containing spikes

figure;
segmSize = 5000;
rawSegm = zeros(segmSize,4);      % preallocate matrix of raw and
filtSegm = zeros(segmSize,4);     % filtered data segments
h = zeros(1,4);                   % preallocate subplot handle

% randomly pick a segment with at least 10 spikes from data of
% first channel, and use it for all the other channels
% (choice of channel is arbitrary)
segmStart = 0;
j=1;
while j==1 ||...
      length(find(segmStart <= s(:,1) <= segmEnd)) <= 10
    j=j+1;
    segmStart = randi(length(raw)-segmSize);
    segmEnd = segmStart+segmSize;
end
msecs = ((0:(segmSize-1))/Fs)*1000; % this will be x-axis of plot

for i=1:size(raw,2)
    rawSegm(:,i) = raw(segmStart:segmEnd-1, i);
    filtSegm(:,i) = filtered(segmStart:segmEnd-1, i);
    h(i) = subplot(4,1,i);
    plot(msecs,rawSegm(:,i));
    hold on
    plot(msecs,filtSegm(:,i));
    text(10,300,['Channel ',num2str(i)]);
    hold off
end

linkaxes(h);
xlim([0 max(msecs)]);
set(h,'box','off');
set(h(1:3),'XTickLabel',[]);
legend(h(1),'Raw signal','Filtered signal','Orientation','horizontal');
title(h(1),'Segment of raw and filtered signal');
xlabel(h(4),'Time (ms)');
ylabel(h(4),['\mu','V'],'Interpreter','tex');
set(h,'FontSize',14)

end