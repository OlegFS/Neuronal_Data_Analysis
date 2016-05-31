function [logLike, grad] = poissonNegLogLikeK(x, counts, theta, fun)
% Negative log likelihood for Poisson spike count and von Mises tuning.
%   [logLikeFun, gradient] = poissonNeglogLikeFun(p, counts, theta) returns the
%   log-likelihood (and its gradient) of the von Mises model with Poisson
%   spike counts.
%
%   Inputs:


%       x           four-element vector of tuning parameters
%       counts      matrix of spike counts
%       theta       column vector of directions of motion (same size as
%                   spike counts)(in radius)
%
%   Outputs:
%       logLike     negative log-likelihood
%       gradient    gradient of negative log-likelihood with respect to 
%                   tuning parameters (four-element column vector)
% 
if ~isempty(find(theta>10))
    theta=theta*2*pi/360;
end
    
logLike= 0;
grad=zeros(4,1);
% 
% for nD=1:length(theta)
%      % x = the parameters: x(1) = alpha, x(2) = Kappa, x(3) = nu, x(4) = phi
%     lambda = fun(x,theta(nD));   
%     for nT=1:size(counts,1) 
%         k=counts(nT,nD);
%          logLike = logLike - k*log(lambda)+lambda+log(factorial(k));
% %         logLike = logLike - k*log(lambda)+lambda;
%         grad(1)=grad(1)+(lambda-k);
%         grad(2)=grad(2)+(lambda-k)*(cos(2*(theta(nD)-x(4)))-1);
%         grad(3)=grad(3)+(lambda-k)*(cos(theta(nD)-x(4))-1);
%         grad(4)=grad(4)+(lambda-k)*(2*x(2)*sin(2*(theta(nD)-x(4)))+x(3)*sin(theta(nD)-x(4)));
%     end
% end

%% counts as vector
for nD=1:size(theta,1)
     % x = the parameters: x(1) = alpha, x(2) = Kappa, x(3) = nu, x(4) = phi
    lambda = fun(x,theta(nD));   
    sum_counts=sum(counts);
        k=sum_counts(nD);
        logLike = logLike - k*log(lambda)+lambda;
        grad(1)=grad(1)+(lambda-k);
        grad(2)=grad(2)+(lambda-k)*(cos(2*(theta(nD)-x(4)))-1);
        grad(3)=grad(3)+(lambda-k)*(cos(theta(nD)-x(4))-1);
        grad(4)=grad(4)+(lambda-k)*(2*x(2)*sin(2*(theta(nD)-x(4)))+x(3)*sin(theta(nD)-x(4)));
   
end

%% 
% syms a k nu phi lambda
% 
% logLikeFun= 0;
% for nD=1:length(theta)
%     for nT=1:size(counts,1)
%     % x = the parameters: x(1) = alpha, x(2) = Kappa, x(3) = nu, x(4) = phi
%     lambda = exp( a + k * (cos(2* (theta(nD)-phi ) ) -1)    ... 
%                         + nu * (cos(1* (theta(nD)-phi ) ) -1)   );        
%     logLikeFun = logLikeFun - counts(nT,nD)*log(lambda)+lambda+log(factorial(counts(nT,nD)));
%     end
% end
% 
% logLikeFun=sym(logLikeFun);
% 
% % grad=matlabFunction(diff(logLikeFun,a),diff(logLikeFun,k),diff(logLikeFun,nu),diff(logLikeFun,phi));
% 
% grad{1}=matlabFunction(diff(logLikeFun,a));
% grad{2}=matlabFunction(diff(logLikeFun,k));
% grad{3}=matlabFunction(diff(logLikeFun,nu));
% grad{4}=matlabFunction(diff(logLikeFun,phi));
% % logLikeFun=subs(logLikeFun,[a,k,nu,phi],[x(1),x(2),x(3),x(4)]);
% logLikeFun=matlabFunction(logLikeFun);
% % 
% % logLikeFun=@(x)logLikeFun(x(1),x(2),x(3),x(4));
% % grad=@(x)grad(x(1),x(2),x(3),x(4));
% 
% 
% logLike=logLikeFun(x(1),x(2),x(3),x(4));
% gradient(1,1)=grad{1}(x(1),x(2),x(3),x(4));
% gradient(2,1)=grad{2}(x(1),x(2),x(3),x(4));
% gradient(3,1)=grad{3}(x(1),x(2),x(3),x(4));
% gradient(4,1)=grad{4}(x(1),x(2),x(3),x(4));