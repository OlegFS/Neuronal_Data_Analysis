function heightExtimate = predictHeight(h,spikeFlags)

Beta = [0.9389;    1.1678;    0.5782];
%Beta = [1.0002;   17.9086;    0.0526]

peaks = find(spikeFlags>0);
for i=1:length(peaks)
Neighbours(i) = sum(spikeFlags(peaks(i)-4:peaks(i)+4)); % try 6
end


X = [ones(length(h),1) h Neighbours']
heightExtimate = X*Beta; 
