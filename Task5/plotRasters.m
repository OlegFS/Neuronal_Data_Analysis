function plotRasters(spikeTimes, stimOnsets, directions, stimDuration)
% Plot spike rasters.
%   plotRasters(spikeTimes, stimOnsets, directions, stimDuration) plots the
%   spike rasters for one single unitfor all 16 stimulus conditons. Inputs
%   are:
%       spikeTimes      vector of spike times           #spikes x 1
%       stimOnsets      vector of stimulus onset times (one per trial)
%                                                       #trials x 1
%       directions      vector of stimulus directions (one per trial)
%                                                       #trials x 1
%       stimDuration    duration of stimulus presentation in ms
%                                                       scalar

% plotting parameters
preStim = 500;
postStim = 500;
count =1;
% Conditions 
C  = unique(directions);
%Timecount
time = linspace(-preStim,stimDuration+postStim,stimDuration+preStim+postStim);
%Preallocation of the picture matrix
 M = zeros(preStim+stimDuration+postStim,11*length(C))';
 % Condition loop
for i =1:length(C)
    % Pick indices for one condtion
    stim = find(directions==C(i));
    
 % zeros(length(spikeTimes),1);
    c = 1;
       % Repetitive trials loop
       for s =count:count+10;     
           % Find indices of spikes in time interval
        ind = spikeTimes>=stimOnsets(stim(c))-preStim ...
         & spikeTimes<=(stimOnsets(stim(c))+stimDuration+postStim);
        % Convert spike time in relative values
        spikes =spikeTimes(ind)-stimOnsets(stim(c));  
        % Set the picture matrix
        M(s,ismember(round(time),round(spikes))) = 1;
        c = c+1;
       end
       % Counter to plot everything in one image
   count = count+11;
    
end

% Pic properties
imagesc(M);
colormap('gray');
set(gca,'YTick',1:11:size(M,1))
set(gca,'YTickLabel',C)
set(gca,'XTickLabel',[ 0 1000 1500 2000 2500 3000 3500 4000 4500])
set(gca, 'YGrid', 'on','GridColor',[1 1 1]);
ylabel('Anlge');
xlabel('Time (ms)')










