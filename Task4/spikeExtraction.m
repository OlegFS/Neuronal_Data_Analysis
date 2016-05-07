function s = spikeExtraction(h)
% s(window,number of waveforms);
maxWindow = 20;

[hPeaks,hLocks] = findpeaks(h);

s = zeros((maxWindow*2)+1,length(hLocks));
mid = ceil(((maxWindow*2)+1)/2);
for i =1:length(hLocks)
    s(mid,i) = hPeaks(i);
    p=1;
        for c=1:maxWindow
             if h(hLocks(i)+p)>0
                s(mid+p,i) = h(hLocks(i)+p);
                p = p+1;
             else
                break
             end
        end
    p = 1;
     for c=1:maxWindow
         if h(hLocks(i)-p)>0
            s(mid-p,i) = h(hLocks(i)-p);
            p = p+1;
         else
             break
         end
     end
    
end