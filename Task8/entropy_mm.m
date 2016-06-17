function H = entropy_mm(p)
% function H = entropy_mle(p)
%   p   vector with observed frequencies of all words
%   H   ML estimate of entropy with miller-maddow correction


ph = p./sum(p);
d = sum(p>0); 
H = - nansum(ph.*log2(ph)) + (d-1)/(2*sum(p));