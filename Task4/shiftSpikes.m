function [shift, spikesShifted] = shiftSpikes(data)
% *** function [shift, spikesWithLag] = shiftSpikes(data)
%  Outputs the average lag (in samples) between measured spikes and
%  calcium trace across all cells of the dataset.
%  Computes the cross-correlation of spikes and calcium sequence, and
%  estimates the shift as the lag with maximum value of cross-correlation.
%    Input: data (struct).
%    Outputs:
%      - estimated shift (average for all cells)
%      - cell array of new shifted spike sequences for each cell.

data = struct2cell(data);
data = reshape(data,[3,10]);
calcium = data(1,:);
spikes = data(2,:);
nCells = 10;
maxlag = 10;  % max lag (in samples) for xcorr
crosscorr = zeros(2*maxlag+1, nCells);  % preallocate
lags = zeros(nCells, 2*maxlag+1);
maxshift = zeros(nCells,1);

for i=1:nCells  % for all cells
    % compute cross-correlation
    [crosscorr(:,i),lags(i,:)] = xcorr(calcium{i},spikes{i},maxlag);
    maxshift = lags(i, find(crosscorr(:,i)==max(crosscorr(:,i))));
end
shift = mean(maxshift);

% implement estimated shift in the spikes sequence
for i=1:nCells
    spikesShifted{i} = circshift(spikes{i},shift);
    % set first sample to zero (it is an artifact of circshift function)
    spikesShifted{i}(1) = 0;
end

end