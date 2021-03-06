function [ccg,bins] = correlogram(t, assignments, binsize, maxlag)
% Calculate cross-correlograms. bins
%   ccg = calcCCG(t, assignment, binsize, maxlag) calculates the cross- and
%   autocorrelograms for all pairs of clusters with input
%       t               spike times             #spikes x 1
%       assignment      cluster assignments     #spikes x 1
%       binsize         bin size in ccg         scalar
%       maxlag          maximal lag             scalar
% 
%  and output
%       ccg             computed correlograms   #bins x #clusters x
%                                                               #clusters
%       bins            bin times relative to center    #bins x 1
nClust = max(assignments);
[c1, c2]=find(triu(ones(nClust))==1);
z = size([c1 c2],1);
range = [-maxlag:binsize:maxlag];
bins= [range(2:end-1)];
    if find(range==0)~=0;
        izero =find(range==0);
        range = [range(1:izero) range(izero+2:end)];
    end
ccg =zeros(length(range)-1,z);
for c=1:z
    dat1 = t(assignments==c1(c));
    dat2 = t(assignments==c2(c));
        for i =1:length(dat1)
            ex = dat1(i)-dat2;
            ccg(:,c) = ccg(:,c) + histcounts(flip(ex),range)';
            ccg(izero,c)= NaN;
        end
end



