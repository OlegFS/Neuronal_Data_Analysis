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

lambda = exp(alpha + kappa*(cos(2*(theta-phi))-1) + nu*(cos(theta-phi)-1));
k = sum(counts)';

logLike = -sum(sum(k.*log(lambda)) - lambda);

gradient(1) = -sum(k'*(2*kappa*sin(2*(theta-phi)) - nu*sin(phi-theta)) -(2*kappa*sin(2*(theta-phi))-nu*sin(phi-theta)).*exp(alpha + kappa*(cos(2*(theta-phi))-1) + nu*(cos(theta-phi)-1)));
gradient(2) = -sum(k'*(cos(2*(theta-phi))-1) - ((cos(2*(theta-phi))-1).*exp(alpha + kappa*(cos(2*(theta-phi))-1) + nu*(cos(theta-phi)-1))));
gradient(3) = -sum(k'*(cos(theta-phi)-1) - ((cos(theta-phi)-1)).*exp(alpha + kappa*(cos(2*(theta-phi))-1) + nu*(cos(theta-phi)-1)));
gradient(4) = -sum(sum(k)-exp(alpha + kappa*(cos(2*(theta-phi))-1) + nu*(cos(theta-phi)-1)));
gradient = gradient';


% logLike = -(sum(k.*log(lambda)) - lambda);
% gradient(1) = -sum(k).*(2.*kappa.*sin(2.*theta-2.*phi)+nu.*sin(theta-phi))+(2.*kappa.*sin(2.*theta-2.*phi)+nu.*sin(theta-phi)).*-exp(kappa.*(cos(2.*theta-2.*phi)-1)+nu.*(cos(theta-phi)-1)+alpha)+1;
% gradient(2) = (cos(2.*theta-2.*phi)-1).*-exp(kappa.*(cos(2.*theta-2.*phi)-1)+nu.*(cos(theta-phi)-1)+alpha)-sum(k).*(cos(2.*theta-2.*phi)-1);
% gradient(3) = (cos(theta-phi)-1).*-exp(kappa.*(cos(2.*theta-2.*phi)-1)+nu.*(cos(theta-phi)-1)+alpha)-sum(k).*(cos(theta-phi)-1);
% gradient(4) = -sum(k)-exp(kappa.*(cos(2.*theta-2.*phi)-1)+nu.*(cos(theta-phi)-1)+alpha)+1;
% gradient = gradient';

% logLike = zeros(1, length(theta));   % neg log likelihood for each direction
% for i = 1:length(theta)
%     lambda = tuningCurve(p, theta(i));
%     k = counts(:,i);
%     logLike(i) = -(sum(k)*log(lambda) - lambda);
%     gradient(1,i) = -sum(k)*(2*kappa*sin(2*theta(i)-2*phi)+nu*sin(theta(i)-phi))+(2*kappa*sin(2*theta(i)-2*phi)+nu*sin(theta(i)-phi))*-exp(kappa*(cos(2*theta(i)-2*phi)-1)+nu*(cos(theta(i)-phi)-1)+alpha)+1;
%     gradient(2,i) = (cos(2.*theta(i)-2.*phi)-1).*-exp(kappa.*(cos(2.*theta(i)-2.*phi)-1)+nu.*(cos(theta(i)-phi)-1)+alpha)-sum(k).*(cos(2.*theta(i)-2.*phi)-1);
%     gradient(3,i) = (cos(theta(i)-phi)-1).*-exp(kappa.*(cos(2.*theta(i)-2.*phi)-1)+nu.*(cos(theta(i)-phi)-1)+alpha)-sum(k).*(cos(theta(i)-phi)-1);
%     gradient(4,i) = -sum(k)-exp(kappa.*(cos(2.*theta(i)-2.*phi)-1)+nu.*(cos(theta(i)-phi)-1)+alpha)+1;
% end

% lambda = tuningCurve(p, theta);
% k = counts(:,i);
% logLike = -(sum(k)*log(lambda) - lambda);
% gradient(1) = -sum(k).*(2.*kappa.*sin(2.*theta-2.*phi)+nu.*sin(theta-phi))+(2.*kappa.*sin(2.*theta-2.*phi)+nu.*sin(theta-phi)).*-exp(kappa.*(cos(2.*theta-2.*phi)-1)+nu.*(cos(theta-phi)-1)+alpha)+1;
% gradient(2) = (cos(2.*theta-2.*phi)-1).*-exp(kappa.*(cos(2.*theta-2.*phi)-1)+nu.*(cos(theta-phi)-1)+alpha)-sum(k).*(cos(2.*theta-2.*phi)-1);
% gradient(3) = (cos(theta-phi)-1).*-exp(kappa.*(cos(2.*theta-2.*phi)-1)+nu.*(cos(theta-phi)-1)+alpha)-sum(k).*(cos(theta-phi)-1);
% gradient(4) = -sum(k)-exp(kappa.*(cos(2.*theta-2.*phi)-1)+nu.*(cos(theta-phi)-1)+alpha)+1;
% gradient = gradient';

    
end
