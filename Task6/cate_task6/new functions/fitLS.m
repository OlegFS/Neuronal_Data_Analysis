function params = fitLS(dirs, counts)
% Fit parametric tuning curve using least squares.
%   params = fitLS(dirs, counts) fits a parametric tuning curve using least
%   squares and returns the fitted parameters. 
%
%   Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)

x0 = [pi 1 1 pi];
params = lsqcurvefit(@tuningCurve, x0, dirs, mean(counts)');

end