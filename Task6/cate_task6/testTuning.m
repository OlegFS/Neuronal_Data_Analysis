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

nIter = 1000;
qdistr = zeros(nIter,1);
for iter = 1:nIter
    shuffledOrder = randperm(length(dirs));
    permcounts = counts(:,shuffledOrder);
    m = mean(permcounts)';
    v = (1/4)*exp(2i*(pi.*dirs/180));
    qdistr(iter) = abs(m'*v);
end

% q observed in data
m = mean(counts)';
v = (1/4)*exp(2i*(pi.*dirs/180));
q = abs(m'*v);

% p-value
p = length(qdistr(qdistr>q))/nIter;

% plot null of distribution
% plot(1:nIter, qdistr, 'o');
figure;
histogram(qdistr,'FaceColor','k','FaceAlpha',1)
ax = gca;
hold on
height = get(ax,'ylim');
h = plot([q q],height,'-r');
title('Null distribution of |q| via permutation test (1000 iterations)')
xlabel('|q|')
ylabel('Number of permuted samples')
legend(h,['|q| = ',num2str(q)],'Location','northwest');

end
