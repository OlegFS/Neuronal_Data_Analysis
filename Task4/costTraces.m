function [cost,grad]=costTraces(weight,x,y);

result =deconvTraces(x,y,weight);
m = length(x);
cost =1/m*sum(((result/norm(result,1))-(y/norm(y,1))).^2);
grad = 2*(1/m)*sum((result-y(length(result))))*weight;


