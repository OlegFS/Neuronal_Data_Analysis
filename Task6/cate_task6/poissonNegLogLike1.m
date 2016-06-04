function [logLike, grad] = poissonNegLogLike1(p, counts, theta)
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

lambda = exp(alpha + kappa*(cos(2*(theta-phi))-1) + nu*(cos(theta-phi)-1));
k = counts;

logLike = zeros(11,16);

for i =1:length(k) % For each datapoint
logLike(:,i) = k(:,i)*log(lambda(i)) - lambda(i);
end

logLike = -sum(sum(logLike));

gradient = zeros(11,16,4);
for i =1:length(k)
gradient(:,i,1) =k(:,i)*(2*kappa*sin(2*(theta(i)-phi)) - nu*sin(phi-theta(i))) -(2*kappa*sin(2*(theta(i)-phi))-nu*sin(phi-theta(i)))*lambda(i);
gradient(:,i,2) = k(:,i)*(cos(2*(theta(i)-phi))-1) - (cos(2*(theta(i)-phi))-1)*lambda(i);
gradient(:,i,3) = k(:,i)*(cos(theta(i)-phi)-1) - ((cos(theta(i)-phi)-1))*lambda(i);
gradient(:,i,4) =k(:,i)-lambda(i);
end

grad = zeros(4,1);
grad(1:4) = - reshape(sum(sum(gradient)),1,4);
    
end
