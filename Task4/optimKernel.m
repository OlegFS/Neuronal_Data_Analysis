function [params,costVal] = optimKernel(calcium, spikes)
% *** function [params,costVal] = optimKernel(calcium, spikes)
% Function for finding optimal kernel parameters by minimizing
% cost function.
% Cost function is defined as mean of squared deviations between
% measured calcium trace and predicted calcium trace.
% Parameters to be optimized are:
%    1. mu: mean of kernel exponential function. mu=1/lambda
%    2. scalingFactor: scales amplitude of the predicted calcium trace.

% -- settings for fminunc
maxIter = 100;
x0 = [5, 0.01];  % parameters for initializing the descent
options = optimset('GradObj','on','MaxIter',maxIter);
[params,costVal] = fminunc(@costKernel, x0, options);
% [params,costVal] = fminunc(@costKernel, x0);

% -- nested function that computes the cost function
% -- param(1) is mu.
% -- param(2) is amplitude.
    function [cost,grad] = costKernel(param)
        % -- create kernel with given mu parameter
        x_kernel = 0:100-1;
        kernel = double(exppdf(x_kernel,param(1)));
        % -- compute predicted calcium time course using convolution
        truncN = length(calcium)-(length(kernel)-1); % equalize vector lengths
        calcium_hat = param(2)*conv(spikes(1:truncN),kernel);
        % -- calculate cost
        cost = (1/truncN)*(calcium-calcium_hat)'*(calcium-calcium_hat);
        % -- calculate gradients (partial derivatives w/r/t parameters)
        kernDeriv = -(1/param(1)^2)*exp((-1/param(1))*x_kernel);
        grad(1) = (1/truncN)*2*(calcium-param(2)*(conv(spikes(1:truncN),kernel)))'*(param(2)*conv(spikes(1:truncN),kernDeriv));
        grad(2) = (1/truncN)*2*(calcium-param(2)*(conv(spikes(1:truncN),kernel)))'*(conv(spikes(1:truncN),kernel));
    end

end