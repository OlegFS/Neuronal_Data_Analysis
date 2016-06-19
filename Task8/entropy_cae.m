function H = entropy_cae(p)

% function H = entropy_cae(p)
%   p   vector with observed frequencies of all words
%   H   coverage adjusted estimate of entropy

ph = p./sum(p);
N = length(ph);
C = 1 - sum(p==1)/N;
Pc = C*ph;

Hi = zeros(length(ph),1);
for i = 1:length(ph)
    Hi(i) = (Pc(i)*log2(Pc(i)))/(1-(1-Pc(i))^N);
end
H = - nansum(Hi);

end