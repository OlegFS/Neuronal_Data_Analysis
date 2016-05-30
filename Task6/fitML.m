function params = fitML(dirs, counts)
% Fit tuning curve using maximum likelihood and Poisson noise model.
%   params = fitML(dirs, counts) fits a parametric tuning curve using
%   maximum liklihood and a Poisson noise model and returns the fitted
%   parameters.
%
%   Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)
%alpha = p(1);
%k = p(2);
%v = p(3);
%phi = p(4);
p1 = rand(4,1);
%p1(4) = pi;
%p1 = [ 0.5758    8.1856   -0.4844    3.3641];
[params, ~, ~] = minimize(p1,'poissonNegLogLike',400,counts,dirs);

%options = optimset('GradObj', 'on', 'MaxIter', 1000);
%params = fminunc(@(p)(poissonNegLogLike(p, counts, dirs)),p1,options);