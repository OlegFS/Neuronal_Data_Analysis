% load data
load NDA_task6_data
load NDA_stimulus

% test for significant tuning
dirs = unique(direction);
n = numel(spikeTimes);
p = zeros(1, n);
for i = 1 : n
    counts = getSpikeCounts(spikeTimes{i}, stimulusOnset, direction, stimulusDuration, i);
%     p(i) = testTuning(dirs, counts);
end
fprintf('%d of %d cells are tuned at p < 0.01\n', sum(p < 0.01), n)

% plot a few nice ones
% 1. average spike counts and fitted tuning curve


%% RUN ALL OF THIS
% clear all
load NDA_task6_data
load NDA_stimulus
nCell = 18;

dirs = unique(direction);
n = numel(spikeTimes);
p = zeros(1, n);
% 1. estimate firing rates
counts = getSpikeCounts(spikeTimes{nCell}, stimulusOnset, direction, stimulusDuration, nCell);
% 2. cosine fit
f = fitCos(dirs, counts);
% 3. permutation test
[p, q, qdistr] = testTuning(dirs, counts);
% 4. von Mises least squares
estPar = fitLS(dirs, counts);
theta = 0:dirs(end);
y = tuningCurve(estPar, theta);
% 5. poisson noise model
% [logLike, gradient] = poissonNegLogLike(estPar, counts, dirs);
paramsPoiss = fitML(dirs, counts);
yPoiss = tuningCurve(paramsPoiss, dirs);
checkgrad('poissonNegLogLike', paramsPoiss, 1e-5, counts, dirs)

% plots
figure;
h1 = plot(counts','.k');
hold on
h2 = plot(mean(counts),'-ro');
xlim([1 length(dirs)]);
set(gca,'XTick',1:length(dirs),'XTickLabel',num2str(dirs));
title(['Average spike counts and fitted tuning curves for cell ',num2str(nCell)]);
xlabel('Direction of motion (degrees)');
ylabel('Spike count');
h3 = plot(f,'-b');
h4 = plot(linspace(1,length(dirs),length(y)), y, '-g');
h5 = plot(linspace(1,length(dirs),length(yPoiss)), yPoiss/15, '-m');
legend([h1(1),h2,h3,h4,h5],'All trials','Average count','Fitted cosine',...
    'Least squares von Mises fit','Poisson noise model');

%% check concavity
figure;
for iter=1:1000
    [ll, gradients] = poissonNegLogLike([randn randn randn randn], counts, dirs);
    plot(iter,ll,'o')
    hold on
end
grid on