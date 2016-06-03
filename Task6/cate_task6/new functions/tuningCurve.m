function y = tuningCurve(p, theta)
% Evaluate tuning curve.
%   y = tuningCurve(p, theta) evaluates the parametric tuning curve at
%   directions theta (in degrees, 0..360). The parameters are specified by
%   a 1-by-k vector p.
%   PARAMETERS: [phi, kappa, nu, alpha]

phi = p(1);
kappa = p(2);
nu = p(3);
alpha = p(4);
theta = deg2rad(theta);

y = exp(alpha + kappa*(cos(2*(theta-phi))-1) + nu*(cos(theta-phi)-1));

end