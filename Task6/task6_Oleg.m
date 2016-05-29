% load data
load NDA_task6_data
load NDA_stimulus

% test for significant tuning
dirs = unique(direction);
n = numel(spikeTimes);
p = zeros(1, n);

for i = 27
    counts = getSpikeCounts(spikeTimes{i}, stimulusOnset, direction, stimulusDuration);
     p(i) = testTuning(dirs, counts);
end
fprintf('%d of %d cells are tuned at p < 0.01\n', sum(p < 0.01), n)

%Calculate Poisson LMS
params= fitLS(dirs,counts);
y = tuningCurve(params, dirs);
% Calculate Poisson von Mises
params = fitML(dirs, counts);
y2 = tuningCurve(params, dirs);
% plot a few nice ones

% Figure 1
a1=plot(dirs,zscore(mean(counts)),'-r','linewidth',5); hold on
a2= plot(dirs,zscore(mean(counts))-1,'--r','linewidth',1);
a3= plot(dirs,zscore(mean(counts))+1,'--r','linewidth',1);
set(gca, 'XTick',dirs)
set(gca,'XTickLabel',dirs,'fontsize',14);
xlabel('orientations');
ylabel('spike rate');

% PLot von Mises tuning curve (nive one with 28th cell )
a4= plot(dirs,zscore(y),'-m');

f = fitCos(dirs, counts);
% Figure Add Tuning Curve
a5 =plot(dirs,zscore(f),'-b','linewidth',5);


% PLot Poisson von Mises
a6 = plot(dirs,zscore(y2),'-k','linewidth',5);

legend Rate SD SD LMS COS Poisson

% Figure; Add poisson fit of Von-Mises Distribution


%plot(y2);
% Figure 3
figure;
histogram(qdistr); hold on;
plot(q,1,'o')

