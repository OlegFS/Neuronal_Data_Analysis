% Run the script step by step to produce plots.

load NDA_rawdata
x  = gain * double(x);

% run code
y = filterSignal(x,samplingRate);
 for i=1:4; 
     [S{i},T{i},L{i}]=detectSpikes(y(:,i), samplingRate);end
 
w = extractWaveforms(y,S,samplingRate);
%b = extractFeatures(w); Under construction







% plot figures
%% 1 - Plot filtered signal
%
plot(x(1:10000,1));hold on; plot(y(1:10000,1),'MarkerSize',4); 
legend original filter
xlabel('Time(Samples)');
ylabel('Voltage')
%% 2 -  Plot Detected spikes 
plotspikes(y,S,3,samplingRate,t1,t2)


%% 3 - Plot first 100 extracted waveforms
plot(w(:,1:100,1)); title('First 100 spikes','FontSize',14)
xlabel('Time');ylabel('Voltage');
set(gca,'XTick',[0  10 15 20 30  ])
set(gca,'XTickLabel',{'-15 ','-10','0','10','15'});
% Plot max 100 spikes;
%Find large spikes;

for i=1:size(w,2)
    a(i,1)=i;
    a(i,2)= max(w(:,i,1));
end

B = sortrows(a,[2]);
B(isnan(B(:,2)),:)=[];
%
figure;
plot(w(:,B(end-100:end,1),1)); title('The largest 100 spikes','FontSize',14)
xlabel('Time');ylabel('Voltage');
set(gca,'XTick',[0  10 15 20 30  ])
set(gca,'XTickLabel',{'-15 ','-10','0','10','15'});

%% Additional plot for 3rd task
figure('Name','First 100 spikes');

for i=1:100 % plot first 100 spikes
subplot(10,10,i);
plot(w(:,i,1));
end

figure('Name','The largest 100 spikes');

for i=1:100
    subplot(10,10,i);% The largest 100 spikes
plot(w(:,B(end-i,1),1));
end

