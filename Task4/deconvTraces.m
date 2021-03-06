function result = deconvTraces(x,y,kern);
% x - filtered data
% y - spike traces

% Exponential kernel
%kern = exppdf(1:100,10); 
% Deconvolution + zero padding
result = deconv([x; zeros(length(kern)-1,1)],kern);
% Rectification
result = result.*(result>0);
