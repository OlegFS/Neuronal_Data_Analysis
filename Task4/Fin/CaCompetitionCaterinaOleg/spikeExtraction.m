function [f,hLocks] = spikeExtraction(h)
% s(window,number of waveforms);
maxWindow = 10;
[hPeaks,hLocks] = findpeaks(h);
[hMins,hMinLocks] = findpeaks(-h);

f = zeros((maxWindow*2)+1,length(hLocks));
mid = ceil(((maxWindow*2)+1)/2);
for i =1:length(hLocks)
    f(mid,i) = hPeaks(i);
    p=0;
        for c=1:maxWindow
             if sum(ismember(hMinLocks,hLocks(i)+p))==0 & hLocks(i)+p<= length(h)
                f(mid+p,i) = h(hLocks(i)+p);
                p = p+1;
             else
                break
             end
        end
    p =0;
     for c=1:maxWindow
         if sum(ismember(hMinLocks,hLocks(i)-p))==0 & hLocks(i)-p>0;
            f(mid-p,i) = h(hLocks(i)-p);
            p = p+1;
         else
             break
         end
     end
     
end

