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

n = 1000;
qdistr = zeros(1,n);
for i =1:n
    ind = randi(numel(counts),size(counts,1),size(counts,2));
    m = mean(counts(ind));
    v =  (1/4)* exp(2*1i*deg2rad(double(dirs)));
    q = m*v;
    qdistr(i) = abs(q);
end
m = mean(counts);
v =  (1/4)* exp(2*1i*deg2rad(double(dirs)));
q = m*v;
q = abs(q);


ratio= sum(qdistr>q);
p=ratio/n;