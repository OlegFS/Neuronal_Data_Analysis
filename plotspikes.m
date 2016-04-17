function plotspikes(y,S,nsigma,samplingRate,t1,t2)

% plotspikes function
% Input: 
%   y - data (nx4 matrix)
%   S - indices of the spikes; S - nx4 cell
%   nsigma - The threshold, that was used for detection (e.g. 3,5)
%   samplingRate - 
%   t1 -t2 - time interval in samples (e.g, t1=980000;t2 = 1000000;)
%
%

sigma = median(abs(y)/0.6745);

t = [1:length(y)]./samplingRate;
tm = NaN(length(y),4);
tm(S{1},1)=y(S{1},1);
tm(S{2},2)=y(S{2},2);
tm(S{3},3)=y(S{3},3);
tm(S{4},4)=y(S{4},4);

thr = NaN(length(y),4);
n=nsigma;
thr(:,1) = n*sigma(1);
thr(:,2) = n*sigma(2);
thr(:,3) = n*sigma(3);
thr(:,4) = n*sigma(4);

% Plot Identified Spikes
%Data
figure('Position', [100, 100, 1049, 1049]); 

h1=plot(t(t1:t2),y(t1:t2,1),'k-',t(t1:t2),y(t1:t2,2)-150,'k-',...
    t(t1:t2),y(t1:t2,3)-300,'k-'...
    , t(t1:t2),y(t1:t2,4)-450,'k-'); hold on; 
%set(gca,'YLim',[0 -600])
set(gca,'YTick',[-450 -300 -150 0])
set(gca,'YTickLabel',{'channel 4','channel 3','channel 2','channel 1'})
xlabel('Time (s)')


%Pointers
h = plot(t(t1:t2),tm(t1:t2,1)-sigma(1),'b^',...
    t(t1:t2),tm(t1:t2,2)-sigma(2)-150,'b^',...
    t(t1:t2),tm(t1:t2,3)-sigma(3)-300,...
    'b^',t(t1:t2),tm(t1:t2,4)-sigma(4)-450,'b^');

set(h,'MarkerSize',6,'MarkerFace','auto')
% Threshold
 plot(t((t1:t2)),-thr(t1:t2,1),'r--');
 plot(t((t1:t2)),-thr(t1:t2,2)-150,'r--');
 plot(t((t1:t2)),-thr(t1:t2,3)-300,'r--');
 plot(t((t1:t2)),-thr(t1:t2,4)-450,'r--');