function grandPlot(spikeTimes,  stimulusOnset, direction, stimulusDuration)

dirs = unique(direction);
n = numel(spikeTimes);
p = zeros(1, n);
figure;

for i = 1 : n
    counts = getSpikeCounts(spikeTimes{i}, stimulusOnset, direction, stimulusDuration, i);
     p(i) = testTuning(dirs, counts);
     
% Calculate Poisson von Mises
params = fitML(dirs, counts);
y = tuningCurve(params, dirs);
% plot a few nice ones
hold on; 
% Figure 1
subplot(5,9,i)
h1 = plot(counts'+1,'.k'); 
set(h1,'markerfacecolor',[0.4 .4 .4], 'markeredgecolor',[.4 .4 .4])
hold on; 
h2 = plot(y+1,'-b','linewidth',3);
if p(i)>0.01
    set(gca,'Color',[0.8 0.8 0.8]);
end
if i~=37
set(gca,'XTick',[],'YTick',[]);
else 
    set(gca,'XTick',[1:4:length(dirs)],'XTickLabel',num2str([dirs(1:4:end)]));
    %set(gca,'XTick',1:length(dirs),'XTickLabel',num2str(dirs));
    
   xlabel('Orientations','fontsize',16)
    ylabel('Spike Rate','fontsize',16)
end
%set(gca, 'XTick',dirs)
%set(gca,'XTickLabel',dirs,'fontsize',14);
%xlabel('orientations');
%ylabel('spike rate');

% PLot von Mises tuning curve (nive one with 28th cell )
%a4= plot(dirs,y,'-m');

%f = fitCos(dirs, counts);
% Figure Add COS Tuning Curve
%a5 =plot(dirs,f,'-b','linewidth',3);

% PLot Poisson von Mises
%a6 = plot(dirs,y2,'-k','linewidth',3);

%legend([a1,a2,a4,a5,a6],'Spike Rate','1 SD','LMS von Mises fit','Cos fit', 'Poisson von Mises fit')
%set(gcf, 'Position', [255   375   745   423])
end

