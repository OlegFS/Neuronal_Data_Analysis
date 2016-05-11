function heightExtimate = predictHeight(h,spikeFlags)
% Estimate the spikes height via regression
% Betas estimated for the 10 training cells (3577 peaks)
%Beta =[ 1.1051;    2.4642;    0.4086]; 

 
%Beta =[ 1.0002; 17.9086;    0.0526]

Beta = [0.6996; 2.9420;    0.2175;    0.0171];
 %Beta = [1.1899;     3.0978;    0.2887;    0.0107] 
%h = diff([ 0 ;h]);
%h = h.^2;

peaks = find(spikeFlags>0);

% Estimate the neighbours of each waveform as a regressor
Neighbours = zeros(length(h),1)';
if (peaks(1)-3)>0 
    p1 = 0; 
    
else 
    pp = find((peaks-3)>0);
    p1 = pp(1)-1;
    
end

if (peaks(end)+3)<length(spikeFlags)

    p2=0;
else
    pp = find((peaks+3)>length(spikeFlags));
    p2 = pp(end)+1;
end

for i=1+p1:length(peaks)-p2;
   Neighbours(i) = sum(spikeFlags(peaks(i)-3:peaks(i)+3)); % try 6
end

distNeighbours = zeros(length(peaks),1)';
p3 = 0;
if (peaks(1)-20)<0
    pp = find(peaks - 20)>0;
    p3 = pp(1);
end
    

for i=1+p3:length(peaks)
distNeighbours(i) = sum(spikeFlags(peaks(i)-20:peaks(i))); % try 6
end

X = [ones(length(h),1) h Neighbours' distNeighbours'];
heightExtimate = X*Beta; 
