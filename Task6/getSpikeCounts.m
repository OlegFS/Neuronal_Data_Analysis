function counts = getSpikeCounts(spikeTimes, stimOnsets, directions, stimDuration, nCell)
% Get firing rate matrix for stimulus presentations.
%   counts = getSpikeCounts(spikeTimes, stimOnsets, directions, stimDuration)
%   Inputs:
%       spikeTimes      vector of spike times           #spikes x 1
%       stimOnsets      vector of stimulus onset times (one per trial)
%                                                       #trials x 1
%       directions      vector of stimulus directions (one per trial)
%                                                       #trials x 1
%       stimDuration    duration of stimulus presentation in ms
%                                                       scalar
%   Output: 
%   counts      matrix of spike counts during stimulus presentation. The
%               matrix has dimensions #trials/direction x #directions

% prepare cell array of spikes belonging to each trial
nTrials = length(stimOnsets);
nDir = length(unique(directions));
nTrialsPerDir = nTrials/nDir;
% rowHeight = repmat(linspace(-10,10,nTrialsPerDir)', [nDir,1]);
for i = 1:nTrials     % for each trial number
    spikesPerTrial{i} = spikeTimes(spikeTimes >= stimOnsets(i) &...
        spikeTimes <= stimOnsets(i) + stimDuration);
    spikesPerTrial{i} = spikesPerTrial{i} - stimOnsets(i); % align to stim onset
end

% create matrix with cell indices of 'spikesPerTrial' for each direction
SPTind = zeros(nTrialsPerDir, nDir);   % #trial x #direction
uniqueDirs = unique(directions);
for i = 1:nDir
    SPTind(:,i) = find(directions==uniqueDirs(i));
end
SPTindvec = reshape(SPTind,[nTrials,1]);  % reshape as 176x1 vector

for i = 1:nTrials
    % sort trials by ascending direction
    SPTsorted{i} = spikesPerTrial{SPTindvec(i)};
end

counts = zeros(nTrials,1);
for i = 1:nTrials
    counts(i) = numel(SPTsorted{i});
end
counts = reshape(counts,[nTrialsPerDir,nDir]);  % reshape as 16x11 vector


% plot
%{
figure;
h1 = plot(counts','.k');
hold on
h2 = plot(mean(counts),'-ro');
xlim([1 nDir]);
set(gca,'XTick',1:nDir,'XTickLabel',num2str(uniqueDirs));
title(['Average spike counts and fitted tuning curve for cell ',num2str(nCell)]);
xlabel('Direction of motion (degrees)');
ylabel('Spike count');
hold on
f = fitCos(uniqueDirs, counts);
h3 = plot(f,'-b');
legend([h1(1),h2,h3],'All trials','Average count','Fitted cosine');
hold on
%}
end