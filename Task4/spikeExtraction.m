function [s,G,f] = spikeExtraction(h,fs)
% s(window,number of waveforms);
maxWindow = 7;
[hPeaks,hLocks] = findpeaks(h);

f = zeros((maxWindow*2)+1,length(hLocks));
mid = ceil(((maxWindow*2)+1)/2);
for i =1:length(hLocks)
    f(mid,i) = hPeaks(i);
    p=1;
        for c=1:maxWindow
             if h(hLocks(i)+p)>0
                f(mid+p,i) = h(hLocks(i)+p);
                p = p+1;
             else
                break
             end
        end
    p = 1;
     for c=1:maxWindow
         if h(hLocks(i)-p)>0
            f(mid-p,i) = h(hLocks(i)-p);
            p = p+1;
         else
             break
         end
     end
   
end

for i =1:size(f,2)
G{i} =[0; f(f(:,i)>0); 0];
end

s = zeros((maxWindow*2)+1,length(hLocks));
for i =1:length(G)
s(:,i) = imresize(G{i}, [size(f,1) 1]);
end