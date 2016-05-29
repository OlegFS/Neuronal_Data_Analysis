function plotPsth(spikeTimes, stimOnsets, directions, stimDuration)
% Plot peri-stimulus time histograms (PSTH).
%   plotPsth(spikeTimes, stimOnsets, directions, stimDuration) plots the
%   PSTHs for one single unit for all 16 stimulus conditons. Inputs are:
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
C = unique(directions);
binsize = 20;
time = linspace(-preStim,stimDuration+postStim,stimDuration+preStim+postStim);
range = [-preStim:binsize:stimDuration+postStim];
%Preallocation of the picture matrix
 M = zeros(preStim+stimDuration+postStim,11*length(C))';
 
 psth = zeros(length(range)-1,length(C));
 % Condition loop
 count = 1;
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
        % Convert spike time to relative values
        spikes =spikeTimes(ind)-stimOnsets(stim(c));  
        % Set the picture matrix
       % M(s,ismember(round(time),round(spikes))) = 1;
        %psth(:,i) = psth(:,i) + M(s,:)';
        psth(:,i) = psth(:,i) + histcounts(spikes,range)';
        c = c+1;
       end
       % Counter to plot everything in one image
   count = count+11;
    
end


%K = psth(1:binsize:end,:)+psth(binsize:binsize:end,:);
t = linspace(-preStim,stimDuration+postStim,size(psth,1));



%for i =1:length(C)
%plot(psth(:,i)-i*hi,'-k');
%hold on;
%area(psth(:,i)-i*hi,-i*hi);
%hold on;
%end
figure; 

ma = axes('Position',[.1 .057 .8 .9]);  % "parent" axes
%set(gca,'XTick',[0:round(1/length(psth)):1])%
set(gca,'XTick',0:25*(1/length(range)):1);
set(gca,'XTickLabel',range(1:25:end),'fontsize',14);
%set(gca,'XTickLabel',range(1:round(length(psth)/11):end));%[ -500 0 1000 1500 2000 2500 3000 3500 4000 4500 5000]
set(gca,'YTick',0.06345*[0:1:length(C)])
set(gca,'YTickLabel',  C);
title('Peristimulus time inverval');
ylabel('Stimulus (deg)')
 xlabel('time');
N = size(psth,2);  % number of vertical bars

 hi = max(max(psth),[],2)+1;
for ii=1:N, 
   % create an axes inside the parent axes for the ii-the barh
   sa = axes('Position', [.1, .057*ii, 0.8, 0.9]); % position the ii-th barh
   bar(psth(:,ii), 'Parent', sa,'FaceColor',[0 0 0],'EdgeColor',[0 0 0]);
  
  ylim([0 hi*15]); 

   axis off
   hold on;
end
 




%ylim([0 170])



