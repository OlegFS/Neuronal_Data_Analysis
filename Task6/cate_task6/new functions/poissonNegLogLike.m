function [logLike, gradient] = poissonNegLogLike(p, counts, theta)
% Negative log likelihood for Poisson spike count and von Mises tuning.
%   [logLike, gradient] = poissonNegLogLike(p, counts, theta) returns the
%   log-likelihood (and its gradient) of the von Mises model with Poisson
%   spike counts.
%
%   Inputs:
%       p           four-element vector of tuning parameters
%                   [phi, kappa, nu, alpha]
%       counts      column vector of spike counts
%       theta       column vector of directions of motion (same size as
%                   spike counts)
%
%   Outputs:
%       logLike     negative log-likelihood
%       gradient    gradient of negative log-likelihood with respect to 
%                   tuning parameters (four-element column vector)

phi = p(1);
kappa = p(2);
nu = p(3);
alpha = p(4);
theta = deg2rad(theta);

% 176 log likelihoods, one per trial. then I sum them to get the final
% negloglike.
logLike = zeros(size(counts));
gradient = zeros(4,1);
for i = 1:length(theta)
    lambda = tuningCurve(p, rad2deg(theta(i)));
    for j = 1:size(counts,1)
        k = counts(j,i);
        logLike(j,i) = k*log(lambda) - lambda;
        gradient(1) = gradient(1) + k*(2*kappa*sin(2*(theta(i)-phi)) - nu*sin(phi-theta(i))) -(2*kappa*sin(2*(theta(i)-phi))-nu*sin(phi-theta(i)))*lambda;
        gradient(2) = gradient(2) + k*(cos(2*(theta(i)-phi))-1) - ((cos(2*(theta(i)-phi))-1)*lambda);
        gradient(3) = gradient(3) + k*(cos(theta(i)-phi)-1) - ((cos(theta(i)-phi)-1))*lambda;
        gradient(4) = gradient(4) + k-lambda;
    end
end

logLike = -sum(sum(logLike));
gradient = -gradient;

end