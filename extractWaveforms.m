function w = extractWaveforms(x,s,fs)
% Extract spike waveforms.
%   w = extractWaveforms(x, s) extracts the waveforms at times s (given in
%   samples) from the filtered signal x using a fixed window around the
%   times of the spikes. The return value w is a 3d array of size
%   length(window) x #spikes x #channels.

% 1ms window into samples
t = 0.001*fs;
nChannels = size(x,2);
% size for preasllocation
for i=1:nChannels
    l(i)=length(s{i});
end

% Preallocation
w = NaN(2*t,max(l),nChannels);
for i =1:nChannels
    for n=1:length(s{i})
        % Exctaction :)
w(:,n,i) = x([s{i}(n)-t]:[s{i}(n)+t-1],i) ;
    end
end


