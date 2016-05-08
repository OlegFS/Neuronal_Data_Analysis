function [shifts, spikesShifted] = shiftSpikes(data)
% *** function [shift, spikesWithLag] = shiftSpikes(data)
%  Estimates for each cell the lag (in samples) between measured spikes
%  and calcium trace.
%  Computes the cross-correlation of spikes and calcium time series
%  of each cell, and estimates the optimal lag as the lag with
%  maximum value of cross-correlation.
%  Applies the shift computed for each cell to the cell's spike time
%  series.
%    Input: data (struct)
%    Outputs:
%      - 10x1 vector of estimated shifts for each cell
%      - 1x10 cell array of shifted spike sequences for each cell

data = struct2cell(data);
data = reshape(data,[3,10]);
calcium = data(1,:);
spikes = data(2,:);
nCells = 10;
maxlag = 10;  % max lag (in samples) for xcorr
crosscorr = zeros(2*maxlag+1, nCells);  % preallocate
lags = zeros(nCells, 2*maxlag+1);
shifts = zeros(nCells,1);

for i=1:nCells  % for all cells
    % compute cross-correlation
    [crosscorr(:,i),lags(i,:)] = xcorr(calcium{i},spikes{i},maxlag);
    shifts(i) = lags(i, find(crosscorr(:,i)==max(crosscorr(:,i))));
end

% implement estimated shift in the spikes sequence
for i=1:nCells
    spikesShifted{i} = circshift(spikes{i},shifts(i));
    % set first sample to zero (it is an artifact of circshift function)
    spikesShifted{i}(1) = 0;
end

end