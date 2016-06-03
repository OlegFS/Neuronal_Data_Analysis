function [p, q, qdistr] = testTuning(dirs, counts)
% Test significance of orientation tuning by permutation test.
%   [p, q, qdistr] = testTuning(dirs, counts) computes a p-value for
%   orientation tuning by running a permutation test on the second Fourier
%   component.
%
%   Inputs:
%       counts      matrix of spike counts as returned by getSpikeCounts.
%       dirs        vector of directions (#directions x 1)
%
%   Outputs:
%       p           p-value
%       q           magnitude of second Fourier component
%       qdistr      sampling distribution of |q| under the null hypothesis

% I HAVE TO SHUFFLE ALL ELEMENTS!
countsRS = reshape(counts,[numel(counts),1]);
nIter = 1000;
qdistr = zeros(nIter,1);
for iter = 1:nIter
    shuffledOrder = randperm(length(countsRS));
    permcounts = countsRS(shuffledOrder);
    permcountsRS = reshape(permcounts,[11,16]);
    m = mean(permcountsRS)';
    v = (1/4)*exp(2i*(pi.*dirs/180));
    qdistr(iter) = abs(m'*v);
end

% q observed in data
m = mean(counts)';
v = (1/4)*exp(2i*(pi.*dirs/180));
q = abs(m'*v);

% p-value
p = length(qdistr(qdistr>q))/nIter;

end
