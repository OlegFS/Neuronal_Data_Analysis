function [f, df] = poissonNegLogLike(p, counts, theta)
% Negative log likelihood for Poisson spike count and von Mises tuning.
%   [logLike, gradient] = poissonNegLogLike(p, counts, theta) returns the
%   log-likelihood (and its gradient) of the von Mises model with Poisson
%   spike counts.
%
%   Inputs:
%       p           four-element vector of tuning parameters
%       counts      column vector of spike counts
%       theta       column vector of directions of motion (same size as
%                   spike counts)
%
%   Outputs:
%       logLike     negative log-likelihood
%       gradient    gradient of negative log-likelihood with respect to 
%                   tuning parameters (four-element column vector)
theta = deg2rad(theta);
alpha = p(1);
k = p(2);
v = p(3);
phi = p(4);

y = exp(alpha+k*(cos(2*(theta-phi))-1)+v*(cos(theta-phi)-1));
%x = mean(counts);
x = mean(counts)';
% Poisson loglikelihood
f = -sum((x'*log(y))-y);

df(:,1) = -sum(sum(x)-y);
df(:,2) = -sum(x'*(cos(2*(theta-phi))-1) - ((cos(2*(theta-phi))-1).*y));
df(:,3) = -sum(x'*(cos(theta-phi)-1) - ((cos(theta-phi)-1)).*y);
%df(4) = sum(x*(-2*k*sin(2*(theta-phi)) - v*sin(theta-phi) -...
%    ((2*k*sin(2*(theta-phi))- v*(sin(theta-phi))))).*y);
df(:,4)= -sum(x'*(2*k*sin(2*(theta-phi)) - v*sin(phi-theta)) -(2*k*sin(2*(theta-phi))-v*sin(phi-theta)).* y) ;
 
df = df';