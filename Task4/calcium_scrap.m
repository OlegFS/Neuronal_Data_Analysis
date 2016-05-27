
% --------------------------- NOTES ------------------------------- %
% model the noise and regress it out.
%
% normalize everything!!!!!
%
% for each sample point, we want to have an estimate (associated
% with a probability value) of the spike count in the previous bin.
% model the probabilities with a mixture of gaussians.
% 
% average the calcium trace associated with one single spike,
% and determine the parameters to feed to the 'findpeaks' function.
% optimize the threshold for findpeaks.
% how long does it take for a calcium transient to return to baseline?
% must determine the average delay between spike and calcium peak.
% ------------------------------------------------------------------ %

%% RUN THIS WHOLE SECTION!
% load
clear all
load('TrainingData.mat')
% prepare variables
nCell = 2;
x_calc = double(data(nCell).GalvoTraces);
% x_calc = zscore(x_calc);  % normalize calcium trace
x_spikes = double(data(nCell).SpikeTraces);
Fs = data(nCell).fps;       % sampling rate
T = 1/Fs;                   % sampling period
L = length(x_calc);         % number of samples
t = (0:L-1)*T;              % time series vector
window = 200;               % window for plotting (in samples)
%  design the filter
d = designfilt('bandpassfir','FilterOrder',20,...
'CutoffFrequency1',0.04,'CutoffFrequency2',3, ...
'SampleRate',Fs);
xfilt = filtfilt(d,x_calc);
xfilt = zscore(xfilt);     % normalize filtered calcium signal

% WAVEFORM EXTRACTION (make separate function)
% -- extract calcium waveforms associated with spikes (any bin count>0)
lengthWav = floor(0.5*Fs); % -1s:+1s length (in samples) of waveform window
j=1;
for i = 1+lengthWav : L-lengthWav
    if x_spikes(i)==1 % take all bins containing spikes, regardless of spike count
        if all(x_spikes([i-lengthWav:i-1, i+1:i+lengthWav]) == 0)
            singlespikes(j) = i;
            j=j+1;
        end
    end
end

waveforms = zeros(lengthWav*2+1, length(singlespikes));
for i=1:length(singlespikes)
    waveforms(:,i) = xfilt(singlespikes(i)-lengthWav:singlespikes(i)+lengthWav);
end

% -- plot of superimposed waveforms
% zWavs = zscore(waveforms);
zWavs = waveforms;
figure;
plot(zWavs);
hold on
avgwave = mean(zWavs,2);
avgwavePlot = plot(avgwave,'k','LineWidth',2);
spikeTime = (size(waveforms,1)+1)/2;
spikeLine = plot([spikeTime,spikeTime],[-3 3],'--k',...
    'LineWidth',2);
title({['Cell ',num2str(nCell)],['Normalized calcium trace in a window of ',num2str(lengthWav*2/Fs),' sec around spike time']})
xlabel('sample n.');
legend([avgwavePlot,spikeLine],'Mean calcium waveform','Spike time')
% -- estimate threshold for findpeaks as the max of average waveform
thr_filt = max(avgwave);

% -- PCA to extract features of waveforms

% -- design kernel as poisson distribution fit of extracted waveform
% fitInterval = spikeTime:size(zWavs,1);
% waveKern = mean(zWavs(fitInterval,:),2)+1;
% waveKernPD = fitdist(waveKern,'exponential');
% figure;
% waveKernFit = pdf(phat,0:length(fitInterval));
% kernel = waveKernFit;
% plot(kernel);
% title(['Kernel (',waveKernPD.DistributionName,' distribution fit of extracted waveform)'])
% kernel = waveKernFit(waveKernFit>0);


% ----------- VISUALISATIONS -----------

% -- fourier transform of raw signal    
yft = fft(x_calc);     % FFT
P2 = abs(yft/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;         % define frequency range
% % -- check power spectrum of raw vs. filtered signal
% yftFilt = fft(xfilt);     % FFT of filtered signal
% P2Filt = abs(yftFilt/L);
% P1Filt = P2Filt(1:L/2+1);
% P1Filt(2:end-1) = 2*P1Filt(2:end-1);
% figure;
% subplot(2,1,1);
% plot(f,P1)
% % ylim([0 0.002])
% title('Raw signal')
% xlabel('frequency (Hz)')
% ylabel('power')
% hold on
% subplot(2,1,2);
% plot(f,P1Filt)
% % ylim([0 0.002])
% title('Filtered signal')
% xlabel('frequency (Hz)')
% ylabel('power')

% -- plots of overlayed calcium+spike traces
figure;
% subplot(2,1,1);
% plot(t(1:window),x_calc(1:window));
% title('Raw calcium trace')
% hold on
% plot(t(1:window),x_spikes(1:window)*mean(x_calc(1:window)));
% hold on
% % -- indicate peaks in raw signal
% thr_raw = mean(x_calc)+0.7*std(x_calc);
% [pks_raw,loc_raw] = findpeaks(x_calc(1:window),'MinPeakHeight',thr_raw);
% loc_raw = T*loc_raw;
% plot(loc_raw,pks_raw,'xk');
% hold off
% ylim([-0.1 0.3])
% subplot(2,1,2);
plot(t(1:window),xfilt(1:window));
title({['Cell ',num2str(nCell)],'Estimated spike trace with findpeaks'})
hold on
% x_spikes_stand = abs(x_spikes(1:window)-mean(xfilt(1:window)))/std(xfilt(1:window));
% plot(t(1:window),x_spikes_stand);
plot(t(1:window),zscore(x_spikes(1:window)));
xlabel('time (s)')
% -- define threshold for findpeaks
% thr_filt = mean(xfilt)+0.7*std(xfilt);   
plot([0 t(window)], [thr_filt thr_filt], '--k')
% -- find peaks
[pks_filt,loc_filt] = findpeaks(xfilt(1:window),'MinPeakHeight',thr_filt);
[pks_filt_all,loc_filt_all] = findpeaks(xfilt,'MinPeakHeight',thr_filt);
% -- sequence containing peaks (to evaluate correlation with real spikes)
pks_sequence = zeros(L,1);
pks_sequence(loc_filt_all) = pks_filt_all;

% -- estimate average lag (in samples) between spike and calcium peak
%  by computing cross-correlogram of measured spikes and calcium
%  peak sequence
%  N.B. ESTIMATE AVERAGE LAG ACROSS ALL CELLS, TO USE AS FIXED PARAMETER
maxlag = 1;                   % max lag in seconds
maxlagbin = floor(Fs*maxlag); % max lag in bins
[crosscorr,lags] = xcorr(pks_sequence, x_spikes, maxlagbin);
lag = lags(crosscorr==max(crosscorr));
% -- implement estimated lag in the calcium peaks sequence
pks_sequence = zeros(L,1);
pks_sequence(loc_filt_all-lag) = pks_filt_all;

% -- evaluate correlation with measured spike count
% disp(['Cell ',num2str(nCell),'. Inverse correlation with measured spike count = ',num2str(corr(pks_sequence,x_spikes))])
% disp(' ')
% -- plot peaks
plot(t(1:window),pks_sequence(1:window),'-g');
legend('Filtered calcium trace','Measured spikes','Threshold','Estimated spikes')
hold off
% -- bar plot of cross-correlation lags
figure;
bar(-maxlagbin:maxlagbin, crosscorr);
title({['Cell ',num2str(nCell)],'Cross-correlogram of calcium peak sequence and measured spikes'})
xlabel('Lag (samples)')

% -- average calcium peak height for each spike count
nonzero_spikecounts = unique(x_spikes(x_spikes>0));
avg_calc_peak = zeros(length(nonzero_spikecounts),1);
for i=1:length(nonzero_spikecounts)
    spikeInd = find(x_spikes==i);
    if ~isempty(spikeInd)
        if spikeInd>1
            spikeInd = [spikeInd-1, spikeInd, spikeInd+1];
            avg_calc_peak(i) = mean(max(pks_sequence(spikeInd),[],2));
        end
    end
end
figure;
plot(nonzero_spikecounts,avg_calc_peak,'-o');
title({['Cell ',num2str(nCell)],'Average calcium peak height for each spike count'})
xlabel('Spike count')

% DECONVOLUTION
% ---- EXPONENTIAL KERNEL WITH OPTIMIZED PARAMETERS -----
[params,costVal] = optimKernel(xfilt, pks_sequence);
x_kernel = 0:100-1;
mu = params(1);
scalingFactor = params(2);
kernel = double(exppdf(x_kernel,mu));
figure;
plot(kernel);
title('Estimated kernel')
legend(['\lambda = ',num2str(1/mu)])

[q_filt,~] = deconv(xfilt,kernel);  % recovered trace has fewer datapoints!
% [q_raw,~] = deconv(x_calc,kernel);
q_filt(q_filt<0) = 0;   % half-wave rectification (spike count must be positive)
q_filt = scalingFactor*q_filt;
% q_raw(q_raw<0) = 0;

convol = scalingFactor*conv(pks_sequence,kernel);
corr_forw = corr(convol(1:length(xfilt)),xfilt);
% corr_forw_raw = corr(convol(1:length(x_calc)),x_calc);
corr_inv_deconv = corr(q_filt,x_spikes(1:length(q_filt)));
corr_inv_pks = corr(pks_sequence,x_spikes);
% corr_inv_raw = corr(q_raw,x_spikes(1:length(q_raw)));
disp(['Cell ',num2str(nCell),'. Forward correlation = ',num2str(corr_forw)]);
disp(' ');
disp(['Cell ',num2str(nCell),'. Inverse correlation (deconv) = ',num2str(corr_inv_deconv)]);
disp(' ');
disp(['Cell ',num2str(nCell),'. Inverse correlation (findpeaks) = ',num2str(corr_inv_pks)]);
disp(' ');
disp(' ');

% -- plot overlayed real spike data and inferred spikes
figure;
plot(t(1:window),x_spikes(1:window));
title({['Spike trace of cell ',num2str(nCell)],['Forward correlation = ',num2str(corr_forw),'.   Inverse correlation = ',num2str(corr_inv_deconv)]})
hold on
plot(t(1:window),q_filt(1:window));
plot(t(1:window),pks_sequence(1:window),'g');
xlabel('time (s)')
legend('Original spike trace','Estimated spike trace (deconv)','Estimated spike trace (findpeaks)')

% -- plot overlayed measured calcium and inferred calcium
% figure;
% plot(t(1:window),xfilt(1:window));
% title({['Calcium trace of cell ',num2str(nCell)],['Forward correlation = ',num2str(corr_forw),'.   Inverse correlation = ',num2str(corr_inv_deconv)]})
% hold on
% plot(t(1:window),convol(1:window));
% xlabel('time (s)')
% legend('Filtered calcium trace','Estimated calcium trace')

% -- FIX EDGES???????
% edgeLength = (length(x_spikes)-length(q))/2;
% corr(q,x_spikes(edgeLength:end-edgeLength-1))

% -- bar plot of forward and inverse correlations for all cells

%% DO NOT RUN - WORK IN PROGRESS
[pks_singlespikes,loc_singlespikes] = findpeaks(singlespikes(1:window),...
    'MinPeakDistance',lengthWav*Fs);
loc_singlespikes_time = T*loc_singlespikes;
hold on
plot(loc_singlespikes_time,pks_singlespikes*mean(x_calc(1:window)),'dg');


mean(loc_singlespikes_time-loc_filt_time(1:length(loc_singlespikes_time)));
alignedSpikes = x_spikes(x_spikes>0 && find(x_spikes)-loc_filt_all<0);
mean(find(x_spikes>0) - loc_filt_all);
