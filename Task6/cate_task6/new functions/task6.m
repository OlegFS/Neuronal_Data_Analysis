% load data
load NDA_task6_data
load NDA_stimulus

% test for significant tuning
dirs = unique(direction);
n = numel(spikeTimes);
p = zeros(1, n);
for i = 1 : n
    counts = getSpikeCounts(spikeTimes{i}, stimulusOnset, direction, stimulusDuration, i);
    p(i) = testTuning(dirs, counts);
end
fprintf('%d of %d cells are tuned at p < 0.01\n', sum(p < 0.01), n)

% plot a few nice ones
% 1. average spike counts and fitted tuning curve


%% RUN ALL OF THIS
% clear all
load NDA_task6_data
load NDA_stimulus
nCell = 1;

dirs = unique(direction);
n = numel(spikeTimes);
% 1. estimate firing rates
counts = getSpikeCounts(spikeTimes{nCell}, stimulusOnset, direction, stimulusDuration, nCell);
% 2. cosine fit
theta = 0:dirs(end);
f = fitCos(dirs, counts);
% 4. von Mises least squares
estPar = fitLS(dirs, counts);
y = tuningCurve(estPar, theta);
% 5. poisson noise model
paramsPoiss = fitML(dirs, counts);
yPoiss = tuningCurve(paramsPoiss, theta);
checkgrad('poissonNegLogLike', paramsPoiss, 1e-5, counts, dirs)


% plot with cosine
figure;
h1 = plot(counts','.');
set(h1, 'MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5],...
    'MarkerSize',10);
hold on
h2 = plot(mean(counts),'-k');
xlim([1 length(dirs)]);
% ylim([-3 30]);
set(gca,'XTick',1:length(dirs),'XTickLabel',num2str(dirs));
title(['Cell ',num2str(nCell)]);
xlabel('Direction of motion (degrees)');
ylabel('Spike count');
h3 = plot(f,'-m');
legend([h1(1),h2,h3],'All trials','Average count','Cosine fit');

% plot with von Mises fits
figure;
h1 = plot(counts','.');
set(h1, 'MarkerFaceColor',[0.5 0.5 0.5],'MarkerEdgeColor',[0.5 0.5 0.5],...
    'MarkerSize',10);
hold on
h2 = plot(mean(counts),'-k');
xlim([1 length(dirs)]);
% ylim([-3 30]);
set(gca,'XTick',1:length(dirs),'XTickLabel',num2str(dirs));
title(['Cell ',num2str(nCell)]);
xlabel('Direction of motion (degrees)');
ylabel('Spike count');
h4 = plot(linspace(1,length(dirs),length(y)), y, '-r');
h5 = plot(linspace(1,length(dirs),length(yPoiss)), yPoiss, '-b');
legend([h1(1),h2,h4,h5],'All trials','Average count','von Mises + Gaussian noise','von Mises + Poisson noise');

%% plot null of distribution

% 3. permutation test
[p, q, qdistr] = testTuning(dirs, counts);
% plot
figure;
histogram(qdistr,'DisplayStyle','stairs');
ax = gca;
hold on
height = get(ax,'ylim');
h = plot([q q],height,'-r');
title(['Cell ', num2str(nCell)]);
xlabel('|q|')
ylabel('Number of samples')
text(1,2,['|q| = ',num2str(q)],'FontSize',14);
text(3,4,['p-value = ',num2str(p)],'FontSize',14);
set(gca,'FontSize',14);

%% test for all cells
for i = 1 : n
    counts = getSpikeCounts(spikeTimes{i}, stimulusOnset, direction, stimulusDuration, i);
    p(i) = testTuning(dirs, counts);
end
fprintf('%d of %d cells are tuned at p < 0.01\n', sum(p < 0.01), n)