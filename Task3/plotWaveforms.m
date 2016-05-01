function plotWaveforms(w, assignments, varargin)
% Plot waveforms for each cluster.
%   plotWaveforms(w, assignment) plots for all four channels of each
%   cluster 100 sample waveforms, overlaid by the average waveform. All
%   panels are drawn on the same scale to facilitate comparison.
data = reshape(w,32,size(w,2)*size(w,3),1);

for i=1:9;
 subplot(3,3,i)
 %100 rand spikes
plot([-15.5:15.5],data(:,randsample(find(assignments==i),100))...
    ,'color',[0.5 0.5 0.5]); hold on 
% average
plot([-15.5:15.5],mean(data(:,assignments==i,:),2),'-k','linewidth',4);
xlabel('time'); ylabel('$\mu V$','interpreter','latex')
title(['Cluster ' num2str(i)])
end
