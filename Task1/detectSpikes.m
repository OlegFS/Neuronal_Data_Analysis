function [s, t] = detectSpikes(x, Fs);
% Detect spikes.
%   [s, t] = detectSpikes(x, Fs) detects spikes in x, where Fs the sampling
%   rate (in Hz). The outputs s and t are column vectors of spike times in
%   samples and ms, respectively. By convention the time of the zeroth
%   sample is 0 ms. x(:,3)


nChannels = size(x,2);
% Function from the lecture
sigma = median(abs(x)/0.6745);


 [l,s]=findpeaks(-x,'MinPeakHeight',3*sigma);
% Comment: Since we are detecting the peaks our waveforms have to be aligned;
 
 
% Alternative way - Faster, but dirtier. 
%It usually misses some spikes on the edges. 
%m=find(x<=-5*sigma);
%s = m(logical([0 ; (diff(m)>30)]));

t = s/Fs;

