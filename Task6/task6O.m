% load data
%load NDA_task6_data
%load NDA_stimulus

% test for significant tuning
dirs = unique(direction);
n = numel(spikeTimes);
p = zeros(1, n);

for i = 1:n
    counts = getSpikeCounts(spikeTimes{i}, stimulusOnset, direction, stimulusDuration,i);
     [p(i),q, qdistr] = testTuning(dirs, counts);
end
fprintf('%d of %d cells are tuned at p < 0.01\n', sum(p < 0.01), n)

%Calculate Poisson LMS
params= fitLS(dirs,counts);
y = tuningCurve(params, dirs);
% Calculate Poisson von Mises
params1 = fitML(dirs, counts,rand(4,1));
y2 = tuningCurve(params1, dirs);
% plot a few nice ones

% Figure 1
figure;
a1=plot(dirs,mean(counts),'color',[.5 .5 .5],'linewidth',5); hold on
a2= plot(dirs,mean(counts)-std(counts),'color',[.5 .5 .5],'linestyle','--','linewidth',1);
a3= plot(dirs,mean(counts)+std(counts),'color',[.5 .5 .5],'linestyle','--','linewidth',1);
set(gca, 'XTick',dirs)
set(gca,'XTickLabel',dirs,'fontsize',14);
xlabel('orientations');
ylabel('spike rate');

% PLot von Mises tuning curve (nive one with 28th cell )
a4= plot(dirs,y,'-m');

f = fitCos(dirs, counts);
% Figure Add COS Tuning Curve
a5 =plot(dirs,f,'-b','linewidth',3);

% PLot Poisson von Mises
a6 = plot(dirs,y2,'-k','linewidth',3);

%legend([a1,a2,a4,a5,a6],'Spike Rate','1 SD','LMS von Mises fit','Cos fit', 'Poisson von Mises fit')
set(gcf, 'Position', [255   375   745   423])
% Figure; Add poisson fit of Von-Mises Distribution


%plot(y2);
% Figure 3
%figure;
%histogram(qdistr); hold on;


% plot null of distribution
 
figure;
histogram(qdistr,'Normalization','probability','DisplayStyle','stairs')
hold on
plot([q q],[0 0.2],'-r')
plot(q,0,'o')

xlabel('Rate');
ylabel('Frequency')

