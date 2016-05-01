function [s, t] = detectSpikes(x, Fs)
% Detect spikes.
%   [s, t] = detectSpikes(x, Fs) detects spikes in x, where Fs the sampling
%   rate (in Hz). The outputs s and t are column vectors of spike times in
%   samples and ms, respectively. By convention the time of the zeroth
%   sample is 0 ms.

sigma = median(abs(x)/0.6745); % estimate of standard deviation of noise
thr = 3*sigma;                 % threshold for spike detection

s = nan(size(x));   % preallocate s
for i=1:size(x,2)
    smpls = find(findpeaks(-x(:,i))>=thr(i));  % temporary variable
    s(1:length(smpls),i) = smpls;
end
clear smpls
filter = all(isnan(s),2);   % get rid of extra rows of all NaNs
s(filter,:) = [];
clear filter
t = (s/Fs)*1000;    % times in ms

end