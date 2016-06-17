function H = entropy_mle(p)
% function H = entropy_mle(p)
%   p   vector with observed frequencies of all words
%   H   ML estimate of entropy

ph = p./sum(p);
H = - nansum(ph.*log2(ph));