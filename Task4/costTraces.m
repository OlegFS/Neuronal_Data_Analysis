function [cost,grad]=costTraces(weight,x,y);
result = deconv(x,weight);
result = result.*(result>0); 
m = length(x);
cost =1/m*sum((result-y(length(result))).^2);
grad = (1/m)*sum((result-y(length(result))))*weight;

