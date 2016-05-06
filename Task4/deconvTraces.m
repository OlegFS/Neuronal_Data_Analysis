function result = deconvTraces(x,y);
% x - filtered data
% y - spike traces

% Exponential kernel
kern = exppdf(1:100,10); 
% Forward conv
C = conv(kern,y);
disp(['forward convolution: ' ...
    num2str(corr(C(1:length(x)),x))])


result = deconv(x,kern);
% Inward rectifier 
result = result.*(result>0); 
%[res rem] = deconv(xF,kern);
disp(['Inverse(deconvolution): ' ...
    num2str(corr(y(1:length(result)), result))])
