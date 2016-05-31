function lambda =fun(x,theta)
phi = x(4);
kappa = x(2);
nu = x(3);
alpha = x(1);
theta = deg2rad(theta);

lambda = exp(alpha + kappa*(cos(2*(theta-phi))-1) + nu*(cos(theta-phi)-1));