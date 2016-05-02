function plotCCG(t, assignments, varargin)
% Plot cross-correlograms of all pairs.
%   plotCCG(t, assignment) plots a matrix of cross(auto)-correlograms for
%   all pairs of clusters. Inputs are:
%       t           vector of spike times           #spikes x 1
%       assignment  vector of cluster assignments   #spikes x 1

%pairs = nchoosek([1:max(assignments)],2);
nClust = max(assignments);
pairs = combvec(1:nClust,1:nClust)';
figure; 
maxlag = 20;
binsize = 0.5;
a = colormap(lines);
clrMap = a(1:7,:);
clrMap(8,:) = [0 0 0];
clrMap(9,:) = [1 0 0];


range = [-maxlag:binsize:maxlag];
bins= [range(2:end-1)];
    if find(range==0)~=0;
        izero =find(range==0);
        range = [range(1:izero-1) range(izero+1:end)];
    end   
for c=1:nClust^2
     h = zeros(1,length(range)-1);
    dat1 = t(assignments==pairs(c,1));
    dat2 = t(assignments==pairs(c,2));
        for i =1:length(dat1)
            ex = dat1(i)-dat2;
            % Delete zero
            h = h+  histcounts(flip(ex),range);
            h(round(length(range)/2))= NaN;
        end
    
    if pairs(c,1)== pairs(c,2)
        p_color = clrMap(pairs(c,1),:);
    else 
        p_color = [0.5 0.5 0.5];
    end    
    subplot(9,9,c); 
    
    bar(bins, h,'FaceColor',p_color,'EdgeColor',p_color);

    if c~= 73   
           set(gca,'XTick',[],'YTick',[]);
        
    else 
          xlabel('time(ms)'); 
           ylabel('frequency');
    end
    
end