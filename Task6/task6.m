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
clear all
load NDA_task6_data
load NDA_stimulus

dirs = unique(direction);
n = numel(spikeTimes);
p = zeros(1, n);
counts = getSpikeCounts(spikeTimes{28}, stimulusOnset, direction, stimulusDuration, 28);
f = fitCos(dirs, counts);
[p, q, qdistr] = testTuning(dirs, counts);
theta = 0:337.5;
params = [pi 1 1 pi];
y = tuningCurve(params, theta);
estPar = fitLS(dirs, counts);