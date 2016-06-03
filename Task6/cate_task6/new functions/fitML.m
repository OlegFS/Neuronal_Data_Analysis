function params = fitML(dirs, counts)
% Fit tuning curve using maximum likelihood and Poisson noise model.
%   params = fitML(dirs, counts) fits a parametric tuning curve using
%   maximum liklihood and a Poisson noise model and returns the fitted
%   parameters.
%
%   Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)

% X0 = [pi 10 0.5 4.5]';    % initialize parameters
X0 = [pi 1 1 pi]';

[X, fX, i] = minimize(X0, 'poissonNegLogLike', 10000, counts, dirs);
params = X;

end