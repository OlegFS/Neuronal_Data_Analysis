function params = fitML(dirs, counts)
% Fit tuning curve using maximum likelihood and Poisson noise model.
%   params = fitML(dirs, counts) fits a parametric tuning curve using
%   maximum liklihood and a Poisson noise model and returns the fitted
%   parameters.
%
%   Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)

%p1 = rand(4,1);
%p1=[pi 1 1 pi];
p1 = rand(4,1)
[params, ~, ~] = minimize(p1,'poissonNegLogLike',1,counts,dirs);

%options = optimset('GradObj', 'on', 'MaxIter', 1000);
%params = fminunc(@(p)(poissonNegLogLike(p, counts, dirs)),p1,options);