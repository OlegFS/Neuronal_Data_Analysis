function [s, t] = detectSpikes(x, Fs);
% Detect spikes.
%   [s, t] = detectSpikes(x, Fs) detects spikes in x, where Fs the sampling
%   rate (in Hz). The outputs s and t are column vectors of spike times in
%   samples and ms, respectively. By convention the time of the zeroth
%   sample is 0 ms.

% Function from the lecture
sigma = median(abs(x)/0.6745);

for i =1:size(x,2)
    % Threshold from the Scholarpaedia 
    % Preallocation for the cells doesn't make much difference
s{:,i}=find(x(:,i)<= - 5*sigma(i));
t{:,i} = s{i}/Fs;
end;

