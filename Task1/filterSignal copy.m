function y = filterSignal(x, Fs)
% Filter raw signal
%   y = filterSignal(x, Fs) filters the signal x. Each column in x is one
%   recording channel. Fs is the sampling frequency. The filter delay is
%   compensated in the output y.

d = designfilt('bandpassfir','FilterOrder',50,...
'CutoffFrequency1',500,'CutoffFrequency2',2800, ...
'SampleRate',Fs);
y = filtfilt(d,x);
% filtfilt produces zero phase distortion, thus compensating
% for the filter delay.

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% OPTIONAL: FOURIER SPECTRUM OF RAW VS. FILTERED SIGNAL %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %  Prepare data (one channel only)
% x1 = x(:,1);
% 
% %  Do Fourier transform of raw signal
% Fs = samplingRate;      % TO DELETE
% T = 1/Fs;               % sampling period
% L = length(x1);    % number of samples
% t = (0:L-1)*T;          % time vector
% yft = fft(x1);     % FFT
% P2 = abs(yft/L);
% P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = Fs*(0:(L/2))/L;     % define frequency range
% 
% %  Design the filter
% d = designfilt('bandpassfir','FilterOrder',50,...
% 'CutoffFrequency1',500,'CutoffFrequency2',3000, ...
% 'SampleRate',samplingRate);
% xfilt = filtfilt(d,x1);
% 
% %  Check power spectrum of raw vs. filtered signal
% yftFilt = fft(xfilt);     % FFT of filtered signal
% P2Filt = abs(yftFilt/L);
% P1Filt = P2Filt(1:L/2+1);
% P1Filt(2:end-1) = 2*P1Filt(2:end-1);
% 
% figure;
% subplot(1,2,1);
% plot(f,P1)
% ylim([0 0.002])
% title('Raw signal')
% xlabel('frequency (Hz)')
% ylabel('power')
% hold on
% subplot(1,2,2);
% plot(f,P1Filt)
% ylim([0 0.002])
% title('Filtered signal')
% xlabel('frequency (Hz)')
% ylabel('power')