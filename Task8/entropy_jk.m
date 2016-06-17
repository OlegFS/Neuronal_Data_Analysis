function H = entropy_jk(p)
% function H = entropy_jk(p)
%   p   vector with observed frequencies of all words
%   H   jackknife estimate of entropy

% jack-knifed entropy estimator (paninski, p. 1198)



for i=1:length(p)
ind =randi(length(p),1);
sampp = p(1:end ~=ind);  % draw a random sample from the uniform distribution
sampHist = accumarray(sampp',1);
%ps = p(randi(length(p),length(p),1));
%ph = ps./sum(ps);
%H_perm(i) = - nansum(ph.*log2(ph));

ph = sampHist./sum(sampHist);
H_perm(i) = - nansum(ph.*log2(ph));
end



N = length(p);
D = mean(H_perm);
sampHist = accumarray(p',1);
ph = sampHist./sum(sampHist);
H = - N*nansum(ph.*log2(ph)) - ((N-1)*D);
