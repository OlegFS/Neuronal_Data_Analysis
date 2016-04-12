function y = filterSignal(x, Fs)
% Filter raw signal
%   y = filterSignal(x, Fs) filters the signal x. Each column in x is one
%   recording channel. Fs is the sampling frequency. The filter delay is
%   compensated in the output y.

fs = Fs;
fcutlow  = 300;
fcuthigh = 3000;
%[b,a]    = butter(order,[fcutlow,fcuthigh]/(fs/2), 'bandpass'); IIR filter
% Probably the best solution is to use FIR, since there is no phase shift; 
% Not sure yet which order of the filter to choose; 
d = designfilt('bandpassfir','FilterOrder',20, ...
'CutoffFrequency1',fcutlow,'CutoffFrequency2',fcuthigh, ...
'SampleRate',fs);

y    = filtfilt(d,x);

